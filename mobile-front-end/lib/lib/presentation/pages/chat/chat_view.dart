import 'package:better_you/lib/presentation/pages/chat/widgets/chat_bubble.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:grouped_list/grouped_list.dart';

import '../../../../config/core/routes/app_routes.dart';
import 'chat_logic.dart';

class ChatView extends StatefulWidget {
  const ChatView({super.key});

  @override
  State<ChatView> createState() => _ChatViewState();
}

class _ChatViewState extends State<ChatView> {
  final ChatLogic model = Get.put(ChatLogic());

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    Get.delete<ChatLogic>();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();


  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: model.obx(
        (state) => _buildBody(model),
        onLoading: const Center(child: CircularProgressIndicator()),
        onEmpty: const Center(child: Text("No messages yet")),
        onError: (error) => Center(child: Text(error.toString())),
      ),
    );
  }

  Widget _buildBody(ChatLogic model) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Color(0xFFFDFDFD),
          scrolledUnderElevation: 0.5,
          elevation: 0.5,
          shadowColor: Color(0xFFE9EAEB),
          surfaceTintColor: Color(0xFFE9EAEB),
          title: Row(
            spacing: 15,
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    image: CachedNetworkImageProvider(
                        model.state.profilePictureUrl),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(model.state.name,
                      style: TextStyle(
                          fontSize: 15.19,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF101828))),
                  Text(model.state.lastSeen,
                      style: TextStyle(fontSize: 12, color: Color(0xFF414651))),
                ],
              ),
            ],
          ),
          actions: [
            IconButton(
              onPressed: () {},
              style: TextButton.styleFrom(
                padding: EdgeInsets.all(8),
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                // Important for tight layout
                minimumSize: Size.zero,
              ),
              icon: Image.asset(
                "assets/png/VideoCall.png",
                height: 20,
              ),
            ),
            Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: IconButton(
                    onPressed: () {
                      model.localDB.isCaller = true;
                      // Get.toNamed(AppRoutes.call);
                    },
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.all(8),
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      // Important for tight layout
                      minimumSize: Size.zero,
                    ),
                    icon: Image.asset(
                      "assets/png/Phone.png",
                      height: 20,
                    ))),
          ],
          leading: Padding(
            padding: EdgeInsets.all(10),
            child: IconButton(
              onPressed: () {
                Get.back();
              },
              splashRadius: 30,
              icon: Icon(Icons.arrow_back_ios_rounded,
                  size: 20, color: Colors.black),
            ),
          )),
      body: Column(
        children: [
          Expanded(
            child: LayoutBuilder(builder: (context, constraints) {
              return NotificationListener<ScrollNotification>(
                onNotification: (ScrollNotification scrollInfo) {
                  if (scrollInfo.metrics.pixels ==
                      scrollInfo.metrics.minScrollExtent) {
                    // User has scrolled to the top, load more messages
                    // model.loadMoreMessages();
                  }
                  return false;
                },
                child: GroupedListView<dynamic, String>(
                  controller: model.scrollController,
                  elements: model.messages.toList(),
                  groupBy: (element) => element['timestamp'].toString(),
                  groupSeparatorBuilder: (String groupByValue) => Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Visibility(
                      visible: false,
                      child: Center(
                        child: Text(
                          _formatTimestamp(groupByValue),
                          style: TextStyle(color: Colors.grey),
                        ),
                      ),
                    ),
                  ),
                  itemBuilder: (context, element) {
                    var isLastItem = model.messages.last == element;
                    isLastItem = false;
                    return Padding(
                      padding: EdgeInsets.only(bottom: isLastItem ? 8.0 : 0),
                      child: ChatBubble(
                        isSender: element['senderId'] == model.localDB.senderId,
                        message: element['message'],
                        repliedMessage: element['repliedMessage'] ?? {},
                        repeatedSender: false,
                        isRead: element['isRead'] ?? false,
                        isSent: element['isSent'] ?? false,
                        isDelivered: element['isDelivered'] ?? false,
                        isGroup: false,
                        image: 'assets/images/user.png',
                        name: "",
                        timestamp: element['timestamp'],
                      ),
                    );
                  },
                ),
              );
            }),
          ),
          _buildMessageInput(model.messageController),
        ],
      ),
    );
  }

  Widget _buildMessageInput(TextEditingController controller) {
    final hasText = controller.text.isNotEmpty;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 15),
      decoration: BoxDecoration(
        color: Color(0xFFFAFAFA),
        boxShadow: [
          BoxShadow(
            color: Color(0xFFE9EAEB),
            blurRadius: 0.5,
          ),
        ],
      ),
      child: Row(
        spacing: 12,
        children: [
          IconButton(
            onPressed: () {
              model.selectAndUploadImage();
            },
            style: TextButton.styleFrom(
              padding: EdgeInsets.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              minimumSize: Size.zero,
            ),
            icon: Image.asset(
              "assets/png/PlusMath.png",
              height: 20,
            ),
          ),
          Visibility(
            visible: false,
            child: IconButton(
              onPressed: () {},
              style: TextButton.styleFrom(
                padding: EdgeInsets.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                minimumSize: Size.zero,
              ),
              icon: Image.asset(
                "assets/png/AttachGIF.png",
                height: 20,
              ),
            ),
          ),
          Expanded(
            child: Container(
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Color(0xFFFFFFFF),
                borderRadius: const BorderRadius.all(
                  Radius.circular(12),
                ),
              ),
              child: TextField(
                maxLines: null,
                controller: controller,
                decoration: InputDecoration(
                  prefixIconConstraints:
                      BoxConstraints(minWidth: Get.width / 100 * 9.5),
                  border: InputBorder.none,
                  isDense: true,
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 6, horizontal: 8),
                  hintStyle: const TextStyle(
                    fontSize: 14,
                    color: Color(0xFF64748B),
                  ),
                ),
                onSubmitted: (message) {
                  if (message.isNotEmpty) {
                    // model.sendMessage(message);
                    controller.clear();
                  }
                },
                style: TextStyle(fontSize: 13.5, color: Color(0xFF101828)),
              ),
            ),
          ),
          IconButton(
            onPressed: hasText
                ? () {
                    // model.sendMessage(controller.text);
                    controller.clear();
                  }
                : null,
            style: TextButton.styleFrom(
              padding: EdgeInsets.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              minimumSize: Size.zero,
            ),
            icon: Image.asset(
              hasText ? "assets/png/Send.png" : "assets/png/Send.png",
              height: 20,
            ),
          )
        ],
      ),
    );
  }

  String _formatTimestamp(String timestamp) {
    final date = DateTime.fromMillisecondsSinceEpoch(int.parse(timestamp));
    return "${date.hour}:${date.minute}";
  }
}
