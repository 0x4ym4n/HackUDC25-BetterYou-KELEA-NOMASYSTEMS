// JsonResponse({"status": "ok", "data": {"token": token.to_jwt()}})

// {"status": "ok", "data": {"token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZGVudGl0eSI6IiIsIm5hbWUiOiJBeW1hbiBCYXJha2F0IiwidmlkZW8iOnsicm9vbUNyZWF0ZSI6ZmFsc2UsInJvb21MaXN0IjpmYWxzZSwicm9vbVJlY29yZCI6ZmFsc2UsInJvb21BZG1pbiI6ZmFsc2UsInJvb21Kb2luIjp0cnVlLCJyb29tIjoiaW50ZXJ2aWV3LXgiLCJjYW5QdWJsaXNoIjp0cnVlLCJjYW5TdWJzY3JpYmUiOnRydWUsImNhblB1Ymxpc2hEYXRhIjp0cnVlLCJjYW5QdWJsaXNoU291cmNlcyI6W10sImNhblVwZGF0ZU93bk1ldGFkYXRhIjpmYWxzZSwiaW5ncmVzc0FkbWluIjpmYWxzZSwiaGlkZGVuIjpmYWxzZSwicmVjb3JkZXIiOmZhbHNlLCJhZ2VudCI6ZmFsc2V9LCJzaXAiOnsiYWRtaW4iOmZhbHNlLCJjYWxsIjpmYWxzZX0sImF0dHJpYnV0ZXMiOnt9LCJtZXRhZGF0YSI6IiIsInNoYTI1NiI6IiIsInN1YiI6ImlkZW50aXR5IiwiaXNzIjoiQVBJeURDSlQ5bVl6Y2JXIiwibmJmIjoxNzI4MjE4NDIyLCJleHAiOjE3MjgyNDAwMjJ9.sDSRePnbZ8B3EvaLQpZtwjXHK6qUMlIw3DYH8LK_UgM"}}

class ResponseLiveKitToken {
  String status;
  LiveKitToken data;

  ResponseLiveKitToken({required this.status, required this.data});

  factory ResponseLiveKitToken.fromJson(Map<String, dynamic> json) =>
      ResponseLiveKitToken(
        status: json["status"],
        data: LiveKitToken.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "data": data.toJson(),
      };
}

class LiveKitToken {
  String token;
  String roomName;
  LiveKitToken({required this.token, required this.roomName});

  factory LiveKitToken.fromJson(Map<String, dynamic> json) => LiveKitToken(
        token: json["token"],
        roomName: json["room_name"],
      );

  Map<String, dynamic> toJson() => {
        "token": token,
        "room_name": roomName,
      };
}
