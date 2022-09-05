enum ChatMessageType {
  TEXT_OTHERS, TEXT_ME, STICKER_ME
}

class ChatMessageModel{
  String messageContent;
  ChatMessageType messageType;
  ChatMessageModel({ required this.messageContent,  required this.messageType});
}
