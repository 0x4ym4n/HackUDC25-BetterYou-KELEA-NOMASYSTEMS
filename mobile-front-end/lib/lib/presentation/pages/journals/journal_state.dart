import '../../../../config/data/remote_datasource.dart';

class JournalState {
  int currentBottomNavIndex = 0;
  List<JournalEntry> entries = []; // Add this line

  JournalState() {
    ///Initialize variables
  }
}

// Add this class for type safety
