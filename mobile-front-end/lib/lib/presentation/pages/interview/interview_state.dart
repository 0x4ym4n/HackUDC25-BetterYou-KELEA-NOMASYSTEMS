import 'package:flutter/material.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';

import '../../../../config/core/services/livekit_service.dart';

class InterviewState {
  Status status = Status.chat;
  String token = "";
  final RxMap<String, NewTranscriptionSegment> activeSegments =
      <String, NewTranscriptionSegment>{}.obs;
  final RxList<NewTranscriptionSegment> completedSegments =
      <NewTranscriptionSegment>[].obs;
}

enum Status { start, chat, results, fetchFeedback }
