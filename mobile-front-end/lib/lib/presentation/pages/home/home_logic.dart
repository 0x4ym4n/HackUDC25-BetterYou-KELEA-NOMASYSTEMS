import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../config/core/routes/app_routes.dart';
import '../../common/sheet_add.dart';
import 'home_state.dart';
import '/config/core/services/base_controller.dart';
import '../../../../config/data/remote_datasource.dart'; // Add this import

class HomeModel extends BaseGetxController with StateMixin<dynamic> {
  @override
  final HomeState state = HomeState();

  @override
  void onReady() {
    fetchCounts();
    fetchDominantTrait(); // Add this line
    change(state, status: RxStatus.loading());
    super.onReady();
  }

  Future<void> fetchCounts() async {
    try {
      // Replace these with your actual API calls
      localDB.journalEntries = await api.getJournalEntries();
      localDB.checkIns = await api.getCheckIns();

      localDB.journalCount = localDB.journalEntries.length;
      localDB.checkInCount = localDB.checkIns.length;
      change(state, status: RxStatus.success());
    } catch (e) {
      // Handle error
      print('Error fetching counts: $e');
    }
  }

  Future<void> fetchDominantTrait() async {
    try {
      final response = await api.getDominantTrait();
      state.dominantTrait = response['dominant_trait'];
      change(state, status: RxStatus.success());
    } catch (e) {
      print('Error fetching dominant trait: $e');
    }
  }

  // Add these methods and implement your API calls
  Future<List<dynamic>> getJournalEntries() async {
    return await api.getJournalEntries();
  }

  Future<List<dynamic>> getCheckIns() async {
    return await api.getCheckIns();
  }

  void updateBottomNavIndex(int index) async {
    if (index == 2) {
      showSheet();
      return;
    }

    // Fade out current page
    state.isPageVisible = false;
    update();

    await Future.delayed(const Duration(milliseconds: 150));

    // Clear previous page (optional)
    // You might want to add specific cleanup logic here

    // Update index
    state.currentBottomNavIndex = index;

    // Small delay to ensure cleanup is complete
    await Future.delayed(const Duration(milliseconds: 50));

    // Fade in new page
    state.isPageVisible = true;
    update();
  }

  Future<void> addJournalEntry(String title, String text) async {
    try {
      final entry = JournalEntry(
        title: title,
        text: text,
      );

      await api.createJournalEntry(entry);
      await fetchCounts(); // Refresh counts after adding
    } catch (e) {
      print('Error creating journal entry: $e');
      // You might want to show an error message to the user here
    }
  }

  Future<void> addCheckIn(
      int mood, List<String> feelings, List<String> events) async {
    try {
      print('HomeModel.addCheckIn called with:');
      print('Mood: $mood');
      print('Feelings: $feelings');
      print('Events: $events');
      localDB.feelings = feelings;
      localDB.events = events;
      final checkIn = CheckIn(
        mood: mood,
        feelings: feelings,
        events: events,
      );

      print('Created CheckIn object, calling API...');
      await api.checkIn(checkIn);
      print('API call successful');

      print('Refreshing counts...');
      await fetchCounts(); // Refresh counts after adding
      print('Counts refreshed successfully');
    } catch (e, stackTrace) {
      print('Error in HomeModel.addCheckIn:');
      print('Error: $e');
      print('Stack trace: $stackTrace');
      rethrow;
    }
  }

  int calculateCurrentStreak() {
    if (localDB.checkIns.isEmpty && localDB.journalEntries.isEmpty) return 0;

    // Combine and sort all dates
    List<DateTime> allDates = [];

    // Add check-in dates
    allDates.addAll(localDB.checkIns
        .where((c) => c.date != null)
        .map((c) => DateTime.parse(c.date!)));

    // Add journal dates
    allDates.addAll(localDB.journalEntries
        .where((j) => j.date != null)
        .map((j) => DateTime.parse(j.date!)));

    // Sort dates in descending order (newest first)
    allDates.sort((b, a) => a.compareTo(b));

    // Remove duplicates (in case there are multiple entries on the same day)
    allDates = allDates.toSet().toList();

    int currentStreak = 0;
    DateTime currentDate = DateTime.now();
    currentDate =
        DateTime(currentDate.year, currentDate.month, currentDate.day);

    // Check if there's any activity today
    if (allDates.isEmpty ||
        !allDates.any((date) =>
            date.year == currentDate.year &&
            date.month == currentDate.month &&
            date.day == currentDate.day)) {
      // Check if yesterday has any activity to continue the streak
      DateTime yesterday = currentDate.subtract(Duration(days: 1));
      if (!allDates.any((date) =>
          date.year == yesterday.year &&
          date.month == yesterday.month &&
          date.day == yesterday.day)) {
        return 0;
      }
      currentDate = yesterday;
    }

    for (var i = 0; i < allDates.length; i++) {
      DateTime dateToCheck = DateTime(
        currentDate.year,
        currentDate.month,
        currentDate.day - currentStreak,
      );

      if (allDates.any((date) =>
          date.year == dateToCheck.year &&
          date.month == dateToCheck.month &&
          date.day == dateToCheck.day)) {
        currentStreak++;
      } else {
        break;
      }
    }

    return currentStreak;
  }
}
