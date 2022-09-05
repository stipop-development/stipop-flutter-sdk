import 'package:flutter/material.dart';
import 'package:stipop_plugin_example/constant/color.dart';
import 'package:stipop_plugin_example/model/chat_message_model.dart';

Widget ChatText(ChatMessageModel chatMessage) {
  return Text(chatMessage.messageContent,
  style: TextStyle(
    color: (chatMessage.messageType ==
        ChatMessageType.TEXT_OTHERS)
        ? Color(CHAT_BUBBLE_TEXT_OTHERS)
        : Color(CHAT_BUBBLE_TEXT_ME),
  ),);
}