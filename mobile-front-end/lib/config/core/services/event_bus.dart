import 'package:event_bus/event_bus.dart';
import 'package:injectable/injectable.dart';
import 'package:livekit_client/livekit_client.dart';
// import 'package:livekit_client/livekit_client.dart';

@lazySingleton
class Bus {
  EventBus eventBus = EventBus();
}

class RefreshHome {}

class ResetJobCountAndRefreshHome {}

class ApplyJob {
  String jobId;
  ApplyJob(this.jobId);
}

class FireSubscriptions {
  String revenueCatUserId = "";
  FireSubscriptions(this.revenueCatUserId);
}

class LiveKitTranscription {
  List<TranscriptionSegment> transcriptions = [];

  LiveKitTranscription(this.transcriptions);
}
