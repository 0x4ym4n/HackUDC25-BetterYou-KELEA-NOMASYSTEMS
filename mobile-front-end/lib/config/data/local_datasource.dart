import 'package:better_you/config/data/remote_datasource.dart';
import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:injectable/injectable.dart';
import 'package:path_provider/path_provider.dart';

import '../core/constants/constants.dart';

@lazySingleton
class LocalDataSource {
  int journalCount = 0;
  int checkInCount = 0;
  List<JournalEntry> journalEntries = [];
  List<CheckIn> checkIns = [];
  List<String> feelings = [];
  List<String> events = [];
  late Box localDataStore;
  Map<String, String> headers = {};
  String senderId = '';
  String phoneNumber = '';
  String name = '';
  bool voiceEnabled = false;
  String callerJid = "";
  bool isCaller = false;

  Future<void> init() async {
    headers = {
      "Authorization": "B5t3yXquwP0k3Hn1qplMlT2IhxPJRhJX",
      "lang": "en",
    };
    if (!kIsWeb) {
      final dir = await getApplicationDocumentsDirectory();
      Hive.init(dir.path);
    }

    localDataStore = await Hive.openBox(Constants.localDB);
  }

  void clearAll() {
    localDataStore.clear();
  }
}
