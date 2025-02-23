import sqlite3
import datetime
from transformers import pipeline
from fastapi import FastAPI, HTTPException
from pydantic import BaseModel
from typing import List

#from chat import router as chat_router

app = FastAPI()
#app.include_router(chat_router)

@app.get("/")
def read_root():
    return {"message": "API is working!"}

# Load AI models
sentiment_pipeline = pipeline("sentiment-analysis")
big5_pipeline = pipeline("zero-shot-classification", model="MoritzLaurer/multilingual-MiniLMv2-L6-mnli-xnli")

# Database setup
conn = sqlite3.connect("emotions.db", check_same_thread=False)
cursor = conn.cursor()

# Create tables
cursor.execute("""
CREATE TABLE IF NOT EXISTS personality_traits (
    id INTEGER PRIMARY KEY DEFAULT 1,
    neuroticism REAL DEFAULT 0,
    openness REAL DEFAULT 0,
    conscientiousness REAL DEFAULT 0,
    extraversion REAL DEFAULT 0,
    agreeableness REAL DEFAULT 0
)
""")

cursor.execute("""
CREATE TABLE IF NOT EXISTS journal_entries (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    title TEXT,
    entry TEXT,
    sentiment TEXT,
    score REAL,
    date TEXT DEFAULT CURRENT_TIMESTAMP
)
""")

cursor.execute("""
CREATE TABLE IF NOT EXISTS check_ins (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    mood INTEGER,
    feelings TEXT,
    events TEXT,
    date TEXT DEFAULT CURRENT_TIMESTAMP
)
""")

conn.commit()

# Ensure a row exists in personality_traits
cursor.execute("SELECT COUNT(*) FROM personality_traits")
if cursor.fetchone()[0] == 0:
    cursor.execute("INSERT INTO personality_traits (id) VALUES (1)")
    conn.commit()

class JournalEntry(BaseModel):
    title: str
    text: str

class CheckIn(BaseModel):
    mood: int
    feelings: List[str]
    events: List[str]
# Mood and event effects
MOOD_EFFECTS = {
    1: {"Extraversion": -1, "Neuroticism": 2, "Agreeableness": -1},  
    2: {"Conscientiousness": -1, "Neuroticism": 2, "Openness": -1},  
    3: {},  
    4: {"Agreeableness": 1, "Neuroticism": -1},  
    5: {"Conscientiousness": 1, "Openness": 1}  
}

FEELING_EFFECTS = {
    "Excited": {"Extraversion": 1.5, "Openness": 1},
    "Sociable": {"Extraversion": 1.5, "Agreeableness": 1},
    "Anxious": {"Neuroticism": 1.5, "Extraversion": -0.5},
    "Frustrated": {"Neuroticism": 1.5, "Agreeableness": -1},
    "Relaxed": {"Neuroticism": -1.5, "Agreeableness": 1},
    "Motivated": {"Conscientiousness": 1.5}
}

EVENT_EFFECTS = {
    "Socializing": {"Extraversion": 1.5, "Agreeableness": 1},
    "Work": {"Conscientiousness": 1, "Neuroticism": 1.5},
    "Inner Thoughts": {"Agreeableness": -1.5, "Neuroticism": 1.5},
    "Learning": {"Openness": 1, "Conscientiousness": 1},
    "Helping Others": {"Agreeableness": 1.5, "Extraversion": 1},
    "Failure": {"Conscientiousness": -1.5, "Neuroticism": 2}
}

TRAIT_MIN, TRAIT_MAX, ADJUSTMENT_RATE = -10, 10, 0.3

def adjust_trait(current, change):
    return max(TRAIT_MIN, min(TRAIT_MAX, current + (change * ADJUSTMENT_RATE)))

def update_traits(changes):
    cursor.execute("SELECT neuroticism, openness, conscientiousness, extraversion, agreeableness FROM personality_traits WHERE id = 1")
    row = cursor.fetchone()
    updated_traits = {
        "Neuroticism": row[0],
        "Openness": row[1],
        "Conscientiousness": row[2],
        "Extraversion": row[3],
        "Agreeableness": row[4]
    }
    
    for trait, change in changes.items():
        updated_traits[trait] = adjust_trait(updated_traits[trait], change)
    
    cursor.execute("""
    UPDATE personality_traits SET
    neuroticism = ?, openness = ?, conscientiousness = ?, extraversion = ?, agreeableness = ? WHERE id = 1
    """, (updated_traits["Neuroticism"], updated_traits["Openness"], updated_traits["Conscientiousness"], updated_traits["Extraversion"], updated_traits["Agreeableness"]))
    conn.commit()
    return updated_traits

@app.post("/check_in/")
def check_in(check_in: CheckIn):
    try:
        date_now = datetime.datetime.utcnow().isoformat()
        
        changes = {}
        
        if check_in.mood in MOOD_EFFECTS:
            for trait, effect in MOOD_EFFECTS[check_in.mood].items():
                changes[trait] = changes.get(trait, 0) + effect
        
        for feeling in check_in.feelings:
            if feeling in FEELING_EFFECTS:
                for trait, effect in FEELING_EFFECTS[feeling].items():
                    changes[trait] = changes.get(trait, 0) + effect
        
        for event in check_in.events:
            if event in EVENT_EFFECTS:
                for trait, effect in EVENT_EFFECTS[event].items():
                    changes[trait] = changes.get(trait, 0) + effect
        
        updated_traits = update_traits(changes) if changes else {}
        
        cursor.execute("""
            INSERT INTO check_ins (mood, feelings, events, date)
            VALUES (?, ?, ?, ?)
        """, (check_in.mood, ', '.join(check_in.feelings), ', '.join(check_in.events), date_now))
        
        conn.commit()
        return {"message": "Check-in recorded", "updated_traits": updated_traits}
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Error processing check-in: {str(e)}")
    
@app.get("/journal_entries/")
def get_journal_entries():
    cursor.execute("SELECT id, title, entry, sentiment, score, date FROM journal_entries ORDER BY id DESC")
    entries = cursor.fetchall()
    return [{"id": row[0], "title": row[1], "entry": row[2], "sentiment": row[3], "score": row[4], "date": row[5]} for row in entries]

@app.get("/check_ins/")
def get_check_ins():
    cursor.execute("SELECT id, mood, feelings, events, date FROM check_ins ORDER BY id DESC")
    checkins = cursor.fetchall()
    return [{"id": row[0], "mood": row[1], "feelings": row[2], "events": row[3], "date": row[4]} for row in checkins]
    
@app.post("/journal_entry/")
def journal_entry(entry: JournalEntry):
    try:
        sentiment = sentiment_pipeline(entry.text)[0]
        big5_result = big5_pipeline(entry.text, candidate_labels=list(FEELING_EFFECTS.keys()), multi_label=True)
        
        if "labels" not in big5_result or "scores" not in big5_result:
            raise ValueError("Unexpected response from Big5 pipeline")

        changes = {}
        for label, score in zip(big5_result["labels"], big5_result["scores"]):
            if label in FEELING_EFFECTS:
                for trait, effect in FEELING_EFFECTS[label].items():
                    changes[trait] = changes.get(trait, 0) + (effect * score)

        updated_traits = update_traits(changes) if changes else {}
        date_now = datetime.datetime.utcnow().isoformat()

        cursor.execute("""
            INSERT INTO journal_entries (title, entry, sentiment, score, date)
            VALUES (?, ?, ?, ?, ?)
        """, (entry.title, entry.text, sentiment["label"], sentiment["score"], date_now))

        conn.commit()
        return {"message": "Journal entry recorded", "updated_traits": updated_traits}
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Error processing journal entry: {str(e)}")

@app.put("/journal_entry/{entry_id}/")
def update_journal_entry(entry_id: int, entry: JournalEntry):
    cursor.execute("SELECT entry FROM journal_entries WHERE id = ?", (entry_id,))
    old_entry = cursor.fetchone()
    
    if not old_entry:
        raise HTTPException(status_code=404, detail="Journal entry not found")

    sentiment = sentiment_pipeline(entry.text)[0]
    big5_result = big5_pipeline(entry.text, candidate_labels=list(FEELING_EFFECTS.keys()), multi_label=True)

    changes = {}
    for label, score in zip(big5_result["labels"], big5_result["scores"]):
        if label in FEELING_EFFECTS:
            for trait, effect in FEELING_EFFECTS[label].items():
                changes[trait] = changes.get(trait, 0) + (effect * score)

    updated_traits = update_traits(changes) if changes else {}

    cursor.execute("""
        UPDATE journal_entries 
        SET title = ?, entry = ?, sentiment = ?, score = ?, date = ?
        WHERE id = ?
    """, (entry.title, entry.text, sentiment["label"], sentiment["score"], datetime.datetime.utcnow().isoformat(), entry_id))
    conn.commit()

    return {"message": "Journal entry updated", "updated_traits": updated_traits}


@app.get("/dominant_trait/")
def dominant_trait():
    cursor.execute("SELECT * FROM personality_traits WHERE id = 1")
    row = cursor.fetchone()
    traits = {"Neuroticism": row[1], "Openness": row[2], "Conscientiousness": row[3], "Extraversion": row[4], "Agreeableness": row[5]}
    dominant = max(traits, key=traits.get)
    return {"dominant_trait": dominant, "value": traits[dominant]}

@app.post("/reset_traits/")
def reset_traits():
    cursor.execute("UPDATE personality_traits SET neuroticism = 0, openness = 0, conscientiousness = 0, extraversion = 0, agreeableness = 0 WHERE id = 1")
    conn.commit()
    return {"message": "Personality traits reset"}

@app.post("/wipe_all_main_data/")
def wipe_all_data_main():
    try:
        conn = sqlite3.connect("emotions.db", check_same_thread=False)
        cursor = conn.cursor()
        
        cursor.execute("DELETE FROM personality_traits")
        cursor.execute("DELETE FROM journal_entries")
        cursor.execute("DELETE FROM check_ins")
        conn.commit()

        # Reset autoincrement
        cursor.execute("VACUUM")
        conn.commit()
        
        cursor.execute("INSERT INTO personality_traits (id) VALUES (1)")
        conn.commit()
        
        return {"message": "All journal and check-in data wiped successfully and personality traits reset."}
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Error wiping data: {str(e)}")
