import 'dart:async';


class ChatState {
  List<dynamic> messages = [];
  late String conversationId; // Add this line

  String lastSeen = "";
  StreamSubscription? messagesSubscription;

  String uploadedImageUrl = "";

  var name = "";
  var number = "";
  var profilePictureUrl = "";

  ChatState();
}
