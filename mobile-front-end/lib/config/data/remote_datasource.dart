import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../core/constants/constants.dart';
import '../core/services/event_bus.dart';
import '../core/services/locator.dart';
import 'api_models/response_livekit_token.dart';
import 'http_exception_helper.dart';
import 'local_datasource.dart';

class JournalEntry {
  final int? id;
  final String title;
  final String text;
  final String? sentiment;
  final double? score;
  final String? date;

  JournalEntry({
    this.id,
    required this.title,
    required this.text,
    this.sentiment,
    this.score,
    this.date,
  });

  Map<String, dynamic> toJson() => {
        'title': title,
        'text': text,
      };

  factory JournalEntry.fromJson(Map<String, dynamic> json) => JournalEntry(
        id: json['id'],
        title: json['title'],
        text: json['entry'],
        sentiment: json['sentiment'],
        score: json['score']?.toDouble(),
        date: json['date'],
      );
}

class CheckIn {
  final int? id;
  final int mood;
  final List<String> feelings;
  final List<String> events;
  final String? date;

  CheckIn({
    this.id,
    required this.mood,
    required this.feelings,
    required this.events,
    this.date,
  });

  Map<String, dynamic> toJson() => {
        'mood': mood,
        'feelings': feelings,
        'events': events,
      };

  factory CheckIn.fromJson(Map<String, dynamic> json) => CheckIn(
        id: json['id'],
        mood: json['mood'],
        feelings: json['feelings'] is String
            ? [json['feelings']]
            : List<String>.from(json['feelings']),
        events: json['events'] is String
            ? [json['events']]
            : List<String>.from(json['events']),
        date: json['date'],
      );
}

class API {
  var client = http.Client();
  Bus eventbus = locator<Bus>();
  final LocalDataSource localDB = locator<LocalDataSource>();

  void printWrapped(String text) {
    print("API Data Response:\n");
    final pattern = RegExp('.{1,800}');
    pattern.allMatches(text).forEach((match) => print(match.group(0)));
  }

  dynamic _response(http.Response response) {
    switch (response.statusCode) {
      case 200:
        var responseJson = json.decode(response.body.toString());
        if (kDebugMode) {
          print(response.body);
        }
        return responseJson;
      case 400:
        throw BadRequestException(response.body.toString());
      case 404:
        var responseJson = json.decode(response.body.toString());
        throw BadRequestException(response.body.toString());
      case 403:
        throw UnauthorisedException(response.body.toString());
      default:
        throw FetchDataException(
            'Internal server error: ${response.statusCode}');
    }
  }

  Future<void> createJournalEntry(JournalEntry entry) async {
    final response = await client.post(
      Uri.parse('${Constants.baseUrl}/journal_entry/'),
      headers: {...localDB.headers, 'Content-Type': 'application/json'},
      body: jsonEncode(entry.toJson()),
    );
    return _response(response);
  }

  Future<void> checkIn(CheckIn checkIn) async {
    final response = await client.post(
      Uri.parse('${Constants.baseUrl}/check_in/'),
      headers: {...localDB.headers, 'Content-Type': 'application/json'},
      body: jsonEncode(checkIn.toJson()),
    );
    return _response(response);
  }

  Future<List<CheckIn>> getCheckIns() async {
    final response = await client.get(
      Uri.parse('${Constants.baseUrl}/check_ins/'),
      headers: localDB.headers,
    );
    final List<dynamic> responseData = _response(response);
    return responseData.map((json) => CheckIn.fromJson(json)).toList();
  }

  Future<dynamic> getDominantTrait() async {
    final response = await client.get(
      Uri.parse('${Constants.baseUrl}/dominant_trait/'),
      headers: localDB.headers,
    );
    return _response(response);
  }

  Future<void> resetTraits() async {
    final response = await client.post(
      Uri.parse('${Constants.baseUrl}/reset_traits/'),
      headers: localDB.headers,
    );
    return _response(response);
  }

  Future<List<JournalEntry>> getJournalEntries() async {
    final response = await client.get(
      Uri.parse('${Constants.baseUrl}/journal_entries/'),
      headers: localDB.headers,
    );
    final List<dynamic> responseData = _response(response);
    return responseData.map((json) => JournalEntry.fromJson(json)).toList();
  }

  Future<void> wipeAllMainData() async {
    final response = await client.post(
      Uri.parse('${Constants.baseUrl}/wipe_all_main_data/'),
      headers: localDB.headers,
    );
    return _response(response);
  }

  Future<ResponseLiveKitToken?> getLiveKitToken() async {
    String feelingsString = localDB.feelings.join(',');
    String eventsString = localDB.events.join(',');

    var response = await client.get(
        Uri.parse(
            "${Constants.LivekitApiUrl}/jobs/v1/livekit/get_livekit_token2?feeling=$feelingsString&emotion=$eventsString"),
        headers: localDB.headers);
    if (response.statusCode == 200) {
      Map<String, dynamic> responseMap = _response(response);
      var parsed = ResponseLiveKitToken.fromJson(responseMap);
      return parsed;
    } else {
      return null;
    }
  }
}
