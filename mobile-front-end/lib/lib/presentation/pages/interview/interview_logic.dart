import 'package:get/get.dart';

import '../../../../config/core/services/event_bus.dart';
import '../../../../config/core/services/livekit_service.dart';
import '/config/core/services/base_controller.dart';
import 'interview_state.dart';

class InterviewLogic extends BaseGetxController with StateMixin<dynamic> {
  LiveKitService? liveKit = LiveKitService();
  @override
  final InterviewState state = InterviewState();
  var recentCompletedSegmentsText = List<String>.empty(growable: true);

  @override
  void onInit() {
    change(state, status: RxStatus.success());
    super.onInit();
    eventbus.eventBus.on<LiveKitTranscription>().listen((event) {
      update();
    });
    toggleStart();
  }

  void toggleStart() {
    state.status = Status.chat;
    api.getLiveKitToken().then((value) async {
      await liveKit!.initLiveKit(
        value!.data.token,
      );
    });
    update();
  }

  void addOrUpdateTranscriptionSegment(NewTranscriptionSegment newSegment) {
    if (state.activeSegments.containsKey(newSegment.speakerIdentity)) {
      final existingSegment = state.activeSegments[newSegment.speakerIdentity]!;
      if (existingSegment.id != newSegment.id) {
        // The segment ID has changed, so the previous segment is complete
        state.completedSegments.add(existingSegment);
        state.activeSegments[newSegment.speakerIdentity] = newSegment;
      } else {
        // Update the existing segment
        existingSegment.update(newSegment.text, newSegment.lastReceivedTime);
      }
    } else {
      // This is a new speaker, add the segment to active segments
      state.activeSegments[newSegment.speakerIdentity] = newSegment;
    }

    if (newSegment.isFinal && state.completedSegments.length > 2) {
      // Check if completed segments contain agent speaker identity
      if (state.completedSegments
          .any((segment) => segment.speakerIdentity.contains("agent"))) {
        // Create a copy to avoid modifying the original list
        final recentCompletedSegments = List.from(state.completedSegments);
        recentCompletedSegments.addAll(state.activeSegments.values);

        // Sort by lastReceivedTime using a separate list for clarity
        final sortedRecentSegments = recentCompletedSegments.toList()
          ..sort((a, b) => a.firstReceivedTime.compareTo(b.firstReceivedTime));

        // Convert to a List<String> with proper formatting
        recentCompletedSegmentsText = sortedRecentSegments.map((segment) {
          final speakerPrefix = segment.speakerIdentity.contains("agent")
              ? "Interviewer: "
              : "Agent: ";
          return '$speakerPrefix${segment.text}';
        }).toList();

        print("recentCompletedSegmentsText: $recentCompletedSegmentsText");
        print("do end of interview check");
      }
    }
    update();
  }

  void closeInterview() {
    if (recentCompletedSegmentsText.length < 5) {
      liveKit!.room.localParticipant?.setMicrophoneEnabled(false);
      liveKit!.closeLiveKit();
      liveKit = null;
      return;
    }
    update();
  }

  List<NewTranscriptionSegment> getLatestSegments() {
    final latestSegments =
        List<NewTranscriptionSegment>.from(state.completedSegments);
    latestSegments.addAll(state.activeSegments.values);
    latestSegments
        .sort((a, b) => a.firstReceivedTime.compareTo(b.firstReceivedTime));
    return latestSegments.length > 10
        ? latestSegments.sublist(latestSegments.length - 10)
        : latestSegments;
  }

  @override
  void onClose() async {
    super.onClose();
    await liveKit?.closeLiveKit();
    liveKit = null;
  }
}
