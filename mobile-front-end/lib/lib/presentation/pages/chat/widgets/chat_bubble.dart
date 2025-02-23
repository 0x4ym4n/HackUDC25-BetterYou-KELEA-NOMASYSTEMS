import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'chat_bubble_painter.dart';

class ChatBubble extends StatelessWidget {
  final bool isSender;
  final String message;
  final String image;
  final String name;
  final bool repeatedSender;
  final bool isRead;
  final bool isSent;
  final bool isDelivered;
  final bool isGroup;
  final Map<dynamic, dynamic> repliedMessage;
  final int timestamp; // Add timestamp

  const ChatBubble({
    super.key,
    required this.isSender,
    required this.message,
    required this.repliedMessage,
    required this.repeatedSender,
    required this.isRead,
    required this.isSent,
    required this.isDelivered,
    this.isGroup = false,
    required this.image,
    required this.name,
    required this.timestamp, // Add timestamp
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isSender ? Alignment.centerRight : Alignment.centerLeft,
      child: Stack(
        children: [
          if (isGroup && !repeatedSender && !isSender)
            Positioned(
              bottom: 10,
              child: Image.asset(
                image,
                height: 25,
              ),
            ),
          Padding(
            padding: EdgeInsets.only(top: 5, bottom: 5, left: isGroup ? 20 : 0),
            child: CustomPaint(
              painter: ChatBubblePainter(
                color: isSender ? Color(0xFFECFDF3) : Color(0xFFF5F5F5),
                alignment: isSender ? Alignment.topRight : Alignment.topLeft,
                tail: repeatedSender ? false : true,
              ),
              child: Container(
                constraints: BoxConstraints(
                  maxWidth: Get.width * .77,
                ),
                padding: EdgeInsets.fromLTRB(
                  isSender ? 10 : 20,
                  10,
                  isSender ? 20 : 10,
                  10,
                ),
                child: Column(
                  spacing: 5,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    if (repliedMessage.isNotEmpty)
                      ClipPath(
                        clipper: ShapeBorderClipper(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Container(
                          padding: const EdgeInsets.all(8.0),
                          decoration: BoxDecoration(
                            color: Color(0xFF000000).withOpacity(0.05),
                            border: Border(
                              left: BorderSide(
                                color: Color(0xFF12B76A),
                                width: 4,
                              ),
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            spacing: 4,
                            children: [
                              Text(
                                repliedMessage["sender"],
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                  fontSize: 13.5,
                                  color: Color(0xFF12B76A),
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Text(
                                repliedMessage["massage"],
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Color(0xFF101828),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        spacing: 4,
                        children: [
                          if (isGroup && repeatedSender && !isSender)
                            Text(
                              name,
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                fontSize: 13.5,
                                color: Color(0xFF12B76A),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          message.toLowerCase().startsWith('http') &&
                                  (message.toLowerCase().endsWith('.jpg') ||
                                      message.toLowerCase().endsWith('.jpeg') ||
                                      message.toLowerCase().endsWith('.png'))
                              ? CachedNetworkImage(
                                  imageUrl: message,
                                  fit: BoxFit.cover,
                                  height: 200,
                                  width: 200,
                                  errorWidget: (context, url, error) => Text(
                                    message,
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                      fontSize: 13.5,
                                      color: Color(0xFF101828),
                                    ),
                                  ),
                                )
                              : Text(
                                  message,
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                    fontSize: 13.5,
                                    color: Color(0xFF101828),
                                  ),
                                ),
                        ],
                      ),
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      spacing: 5,
                      children: [
                        Text(
                          _formatTimestamp(timestamp), // Use the timestamp
                          style: TextStyle(
                            color: Color(0xFF010101).withAlpha(45),
                          ),
                        ),
                        if (isSender && !isSent) ...{
                          Icon(
                            Icons.timer_sharp,
                            size: 12,
                            color: Colors.grey,
                          )
                        },
                        if (isSender && isSent && !isDelivered) ...{
                          Icon(
                            Icons.check,
                            size: 12,
                            color: Colors.grey,
                          )
                        },
                        if (isSender && isDelivered) ...{
                          Image.asset(
                            "assets/svg/icon_double-check.png",
                            height: 15,
                            color:
                                isRead ? Color(0xFF32D583) : Color(0xFFA4A7AE),
                          ),
                        },
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Helper function to format the timestamp
  String _formatTimestamp(int timestamp) {
    final date = DateTime.fromMillisecondsSinceEpoch(timestamp);
    final hour = date.hour.toString().padLeft(2, '0');
    final minute = date.minute.toString().padLeft(2, '0');
    return "$hour:$minute";
  }
}
