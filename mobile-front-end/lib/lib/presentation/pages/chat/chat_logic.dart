import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';

import '/config/core/services/base_controller.dart';
import 'chat_state.dart';

class ChatLogic extends BaseGetxController with StateMixin<dynamic> {
  static const Duration _participantCheckInterval = Duration(seconds: 3);
  static const Duration _retryInterval = Duration(seconds: 5);

  @override
  final ChatState state = ChatState();
  final RxList<Map<String, dynamic>> messages = <Map<String, dynamic>>[].obs;
  final RxInt roomParticipantsCount = 0.obs;
  final TextEditingController messageController = TextEditingController();
  ScrollController scrollController = ScrollController();
  late Timer _timer;
  late Timer _retryTimer;
  final Set<String> _processedMessageIds = <String>{};

  var uuid = Uuid();
  int messagePage = 0;
  static const int messagePageSize = 10;
  bool isLoadingMore = false;
  bool hasMoreMessages = true;

  @override
  void onInit() async {
    scrollController = ScrollController();

    super.onInit();
    state.conversationId = Get.arguments ?? "";
    change(state, status: RxStatus.success());
    messageController.addListener(() {
      update();
    });
  }



  @override
  void onClose() {
    super.onClose();
    scrollController.dispose();
    messageController.dispose();
    state.messagesSubscription?.cancel();
    _timer?.cancel();
    _processedMessageIds.clear();
  }

  Future<void> selectAndUploadImage() async {
    ImageSource? source = await Get.bottomSheet<ImageSource>(
      Container(
        color: Colors.white,
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text("Camera"),
              onTap: () => Get.back(result: ImageSource.camera),
            ),
            ListTile(
              leading: const Icon(Icons.image),
              title: const Text("Gallery"),
              onTap: () => Get.back(result: ImageSource.gallery),
            ),
          ],
        ),
      ),
    );
    if (source != null) {
      final picker = ImagePicker();
      final pickedFile =
          await picker.pickImage(source: source, imageQuality: 80);
      if (pickedFile != null) {
        File file = File(pickedFile.path);
        await uploadProfilePicture(file);
        // sendMessage(state.uploadedImageUrl);
      }
    }
  }

  Future<void> uploadProfilePicture(File file) async {
    try {
      var uri = Uri.parse("http://api.impadvantage.com/profile/upload_picture");
      var request = http.MultipartRequest('POST', uri);
      request.fields['user_id'] = localDB.phoneNumber;

      var stream = http.ByteStream(file.openRead());
      var length = await file.length();
      var multipartFile = http.MultipartFile(
        'profile_picture',
        stream,
        length,
        filename: file.path.split("/").last,
      );
      request.files.add(multipartFile);

      var response = await request.send();
      if (response.statusCode == 200) {
        var responseString = await response.stream.bytesToString();
        var jsonResponse = json.decode(responseString);
        if (jsonResponse["status"] == "success") {
          state.uploadedImageUrl = jsonResponse["data"]["profile_picture_url"];
        } else {
          Get.snackbar("Error", "Failed to upload your picture");
        }
      } else {
        Get.snackbar("Error", "Failed to upload image: ${response.statusCode}");
      }
    } catch (e) {
      Get.snackbar("Error", e.toString());
    }
  }
}
