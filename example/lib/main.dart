import 'package:flutter/material.dart';
import 'package:stipop_plugin_example/second.dart';
import 'package:stipop_sdk/stipop_plugin.dart';

import 'chat/chatMessageModel.dart';

void main() {
  runApp(const MaterialApp(home: MyApp()));
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late Stipop stipop;
  String callbackMsg = '';
  String? stickerImg;

  final txtController = TextEditingController();

  List<ChatMessage> messages = [
    ChatMessage(
        messageContent: "Hello! Try Stipop Flutter Example!",
        messageType: "receiver")
  ];

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    txtController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    stipop = Stipop(
      'some_user_id',
      languageCode: 'en',
      countryCode: 'US',
      onStickerPackSelected: (spPackage) {
        setState(() {
          callbackMsg = 'onStickerPackSelected\n${spPackage.toJson()}';
          stickerImg = null;
        });
      },
      onStickerSelected: (sticker) {
        setState(() {
          callbackMsg = 'onStickerSelected\n${sticker.toJson()}';
          stickerImg = sticker.stickerImg;
          _pushMessage(
              ChatMessage(messageContent: stickerImg!, messageType: "sticker"));
          controller.jumpTo(controller.position.maxScrollExtent);
        });
      },
    );
  }

  void _pushMessage(chatMessageModel) {
    setState(() {
      messages.add(chatMessageModel);

    });
  }

  ScrollController controller = ScrollController();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
          appBar: AppBar(
            title: const Text('Stipop Plugin Example'),
            elevation: 1,
            actions: [
              PopupMenuButton(
                  itemBuilder: (context) => <PopupMenuEntry>[
                        PopupMenuItem(
                            child: Row(children: const [
                              Icon(Icons.add_to_home_screen,
                                  color: Colors.black54, size: 18),
                              SizedBox(width: 10),
                              Text('View at Second Screen'),
                            ]),
                            value: "screen"),
                      ],
                  onSelected: (value) async {
                    switch (value) {
                      case "screen":
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => const SecondScreen()));
                        break;
                    }
                  })
            ],
          ),
          body: SafeArea(
            child: Stack(
              children: [
                ListView.builder(
                  itemCount: messages.length,
                  shrinkWrap: true,
                  controller: controller,
                  padding: const EdgeInsets.only(top: 10, bottom: 75),
                  physics: const AlwaysScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    return Container(
                      padding: const EdgeInsets.only(
                          left: 8, right: 16, top: 4, bottom: 4),
                      child: Align(
                        alignment: (messages[index].messageType == "receiver"
                            ? Alignment.topLeft
                            : Alignment.topRight),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: (messages[index].messageType == "receiver"
                                ? Colors.blue.shade200
                                : Colors.lightGreen.shade100),
                          ),
                          padding: const EdgeInsets.all(8),
                          child: _chatItem(messages[index]),
                        ),
                      ),
                    );
                  },
                ),
                Align(
                  alignment: Alignment.bottomLeft,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: 12, horizontal: 12),
                    height: 80,
                    width: double.infinity,
                    color: Colors.white,
                    child: Row(
                      children: [
                        GestureDetector(
                            onTap: () {
                              stipop.showKeyboard();
                            },
                            child: Align(
                              alignment: Alignment.centerRight,
                              child: Container(
                                  height: 40,
                                  width: 40,
                                  decoration: BoxDecoration(
                                      color: Colors.blue,
                                      borderRadius: BorderRadius.circular(40)),
                                  child: const Icon(
                                    Icons.keyboard,
                                    color: Colors.white,
                                  )),
                            )),
                        const SizedBox(width: 16),
                        GestureDetector(
                            onTap: () {
                              stipop.showSearch();
                            },
                            child: Align(
                              alignment: Alignment.centerRight,
                              child: Container(
                                  height: 40,
                                  width: 40,
                                  decoration: BoxDecoration(
                                      color: Colors.blue,
                                      borderRadius: BorderRadius.circular(40)),
                                  child: const Icon(
                                    Icons.search,
                                    color: Colors.white,
                                  )),
                            )),
                        const SizedBox(width: 16),
                         Expanded(
                            child: TextField(
                              controller: txtController,
                          textAlign: TextAlign.left,
                          decoration: const InputDecoration(
                              border: InputBorder.none,
                              hintText: "Enter Message..."),
                        )),
                        const SizedBox(width: 16),
                        GestureDetector(
                            onTap: () {
                              _pushMessage(ChatMessage(
                                  messageContent: txtController.text,
                                  messageType: "sender"));
                              _scrollDown();
                              txtController.text = "";

                            },
                            child: Align(
                              alignment: Alignment.centerRight,
                              child: Container(
                                  height: 40,
                                  width: 40,
                                  decoration: BoxDecoration(
                                      color: Colors.blue,
                                      borderRadius: BorderRadius.circular(40)),
                                  child: const Icon(
                                    Icons.send_rounded,
                                    color: Colors.white,
                                  )),
                            )),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          )),
    );
  }

  Widget _chatItem(ChatMessage chatMessageModel) {
    return Padding(
      child: Column(children: [
        chatMessageModel.messageType == "sticker"
            ? Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
                child: Image.network(
                  chatMessageModel.messageContent,
                  width: 85,
                  height: 85,
                ))
            : Container(
                child: Text(chatMessageModel.messageContent),
              ),
      ]),
      padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
    );
  }

  // This is what you're looking for!
  void _scrollDown() {
    controller.animateTo(
      controller.position.maxScrollExtent,
      duration: const Duration(seconds: 2),
      curve: Curves.fastOutSlowIn,
    );
  }
}
