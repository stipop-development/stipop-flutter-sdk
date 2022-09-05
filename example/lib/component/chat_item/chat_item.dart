import 'package:flutter/material.dart';

import '../../model/chat_message_model.dart';
import 'chat_sticker.dart';
import 'chat_text.dart';

Widget ChatItem(ChatMessageModel chatMessageModel) {
  return Padding(
    child: Column(children: [
      chatMessageModel.messageType == ChatMessageType.STICKER_ME
          ? ChatSticker(chatMessageModel.messageContent)
          : ChatText(chatMessageModel)
    ]),
    padding: const EdgeInsets.all(0),
  );
}