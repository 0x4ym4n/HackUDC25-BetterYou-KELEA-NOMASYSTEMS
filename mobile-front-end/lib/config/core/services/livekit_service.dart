import 'package:get/get.dart';
import 'package:livekit_client/livekit_client.dart';

import '../../../lib/presentation/pages/interview/interview_logic.dart';
import '../constants/constants.dart';

class LiveKitService {
  Room room = Room();
  Map<String, TranscriptionSegment> transcriptions = {};

  Future<void> initLiveKit(String token) async {
    print(token);
    late final EventsListener<RoomEvent> listener = room.createListener();
    listener.on<TranscriptionEvent>((event) {
      for (final segment in event.segments) {
        final newSegment = NewTranscriptionSegment(
          id: segment.id,
          text: segment.text.replaceAll("*", "").replaceAll("#", ""),
          firstReceivedTime: segment.firstReceivedTime,
          lastReceivedTime: segment.lastReceivedTime,
          language: segment.language ?? '',
          speakerIdentity: event.participant.identity,
          isFinal: segment.isFinal,
        );

        Get.find<InterviewLogic>().addOrUpdateTranscriptionSegment(newSegment);
      }
    });

    await room.connect(Constants.livekitUrl, token);
    await room.localParticipant?.setMicrophoneEnabled(true);
    print("LiveKit Connected");
  }

  closeLiveKit() async {
    await room.disconnect();
    await room.dispose();
  }
}

class NewTranscriptionSegment {
  final String id;
  String text;
  final DateTime firstReceivedTime;
  DateTime lastReceivedTime;
  final String language;
  final String speakerIdentity;
  final bool isFinal;

  NewTranscriptionSegment({
    required this.id,
    required this.text,
    required this.firstReceivedTime,
    required this.lastReceivedTime,
    required this.language,
    required this.speakerIdentity,
    required this.isFinal,
  });

  void update(String newText, DateTime newLastReceivedTime) {
    text = newText;
    lastReceivedTime = newLastReceivedTime;
  }
}
