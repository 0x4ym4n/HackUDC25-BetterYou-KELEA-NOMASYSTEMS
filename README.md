# Better You - Your AI Wellbeing Coach 🧘‍♂️

Better You is a comprehensive Flutter-based mobile application designed to be your personal AI wellbeing coach, helping you achieve your health and personal development goals through intelligent guidance and tracking.

## 📱 Demo


<div style="display: flex; justify-content: space-around; margin: 20px 0;">
  <div style="flex: 1; margin-right: 10px;">
    <video width="100%" controls>
      <source src="https://github.com/0x4ym4n/HackUDC25-BetterYou-KELEA-NOMASYSTEMS/raw/refs/heads/master/assets/demo1.mp4" type="video/mp4">
      Your browser does not support the video tag.
    </video>
  </div>
  <div style="flex: 1; margin-left: 10px;">
    <video width="100%" controls>
      <source src="https://github.com/0x4ym4n/HackUDC25-BetterYou-KELEA-NOMASYSTEMS/raw/refs/heads/master/assets/demo2.mp4" type="video/mp4">
      Your browser does not support the video tag.
    </video>
  </div>
</div>
## 🌟 Features

- **AI-Powered Coaching**: Personalized guidance and support for your wellbeing journey
- **Progress Tracking**: Monitor your achievements and maintain streaks
- **Real-time Communication**: Chat functionality with video call support
- **Goal Setting**: Set and track personal development goals
- **Custom Analytics**: Visual representation of your progress using Syncfusion charts
- **Cross-Platform**: Supports iOS, Android, macOS, Windows, Linux, and Web

## 🛠 Technology Stack

### Core
- Flutter SDK ^3.6.0
- Dart
- GetX for State Management
- Injectable for Dependency Injection

### Key Dependencies
- **State Management**
  - `get: ^4.6.6`
  - `get_it: ^7.6.4`
  - `injectable: ^2.3.0`

- **UI Components**
  - `google_fonts: ^6.1.0`
  - `flutter_svg: ^2.0.7`
  - `shimmer: ^3.0.0`
  - `animate_do: ^3.0.2`
  - `lottie: ^2.4.0`

- **Data Management**
  - `hive: ^2.2.3`
  - `hive_flutter: ^1.1.0`
  - `path_provider: ^2.0.15`

- **Communication**
  - `socket_io_client: ^1.0.1`
  - `livekit_client: ^2.3.6`

- **UI/UX Utilities**
  - `calendar_timeline: ^1.1.3`
  - `sticky_grouped_list: ^3.1.0`
  - `syncfusion_flutter_charts: ^28.2.6`

## 🚀 Getting Started

### Prerequisites
- Flutter SDK ^3.6.0
- Dart SDK
- Android Studio / VS Code
- iOS Simulator / Android Emulator (for mobile development)
- Python 3.8+ (for server)
- pip (Python package manager)


### Installation

1. Clone the repository:
```bash
git clone https://github.com/0x4ym4n/HackUDC25-BetterYou-KELEA-NOMASYSTEMS.git
```

2. Navigate to project directory:
```bash
cd better_you
```

3. Install dependencies:
```bash
flutter pub get
```

4. Run the application:
```bash
flutter run
```

## Platform Support

- ✅ Android
- ✅ iOS
- ✅ macOS
- ✅ Windows
- ✅ Linux
- ✅ Web

## Project Structure

```
lib/
├── config/
│   ├── core/
│   │   ├── constants/
│   │   ├── routes/
│   │   └── services/
│   └── data/
│       └── api_models/
├── lib/
│   ├── config/
│   │   └── theme/
│   └── presentation/
│       ├── common/
│       └── pages/
```

5. Set up environment variables:
   Create a `.env` file in the root directory with the following variables:
   ```
   API_BASE_URL=your_api_url
   LIVEKIT_API_URL=your_livekit_api_url
   LIVEKIT_URL=your_livekit_url
   LOCAL_DB_NAME=your_local_db_name
   ```

### Server Setup

1. Create and activate virtual environment:
```bash
python -m venv venv
source venv/bin/activate  # On Unix/macOS
.\venv\Scripts\activate   # On Windows
```

2. Install dependencies:
```bash
pip install -r requirements.txt
```

3. Run the server:
```bash
uvicorn server:app --host 0.0.0.0 --port 8000 --reload
```

## Security

- Secure data storage using Hive
- Permission handling for sensitive features
- Secure communication protocols

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Support

For support, please open an issue in the GitHub repository or contact the development team.

---

Made with ❤️ by the Better You Team