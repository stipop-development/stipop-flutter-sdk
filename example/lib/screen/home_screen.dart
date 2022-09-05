import 'package:flutter/material.dart';
import 'package:stipop_plugin_example/constant/color.dart';
import 'package:stipop_sdk/stipop_plugin.dart';

import '../component/chat_item/chat_item.dart';
import '../model/chat_message_model.dart';
import 'information_screen.dart';

enum MenuEnum { SCREEN }

class HomeScreen extends StatefulWidget {
  String userId;

  HomeScreen(this.userId, {Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState(userId);
}

class _HomeScreenState extends State<HomeScreen> {
  String userId;

  Stipop stipop = Stipop();
  bool isSPShowing = false;

  final txtController = TextEditingController();
  String textString = "";

  List<ChatMessageModel> messages = [
    ChatMessageModel(
        messageContent: "Hello! Try Stipop Flutter Example!",
        messageType: ChatMessageType.TEXT_OTHERS)
  ];

  _HomeScreenState(this.userId);

  @override
  void initState() {
    super.initState();
    _spConnect();
  }

  void _spConnect() {
    stipop.connect(
        userId: userId,
        onStickerSingleTapped: (sticker) {
          setState(() {
            if (sticker.stickerImg != null) {
              _pushMessage(ChatMessageModel(
                  messageContent: sticker.stickerImg!,
                  messageType: ChatMessageType.STICKER_ME));
            }
          });
        },
        onStickerDoubleTapped: (sticker) {},
        onStickerPackSelected: (spPackage) {},
        pickerViewAppear: (spIsViewAppear) {
          bool isAppear = spIsViewAppear.isAppear;
          setState(() {
            isSPShowing = isAppear;
          });
        });
  }

  void hideStipop(bool isWithKeyboard) {
    stipop.hide();
    isSPShowing = false;
    if (isWithKeyboard) {
      hideKeyboard();
    }
  }

  void hideKeyboard() {
    FocusScope.of(context).unfocus();
  }

  @override
  void dispose() {
    hideStipop(true);
    txtController.dispose();
    super.dispose();
  }

  void _pushMessage(chatMessageModel) {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if (controller.hasClients) {
        controller.jumpTo(controller.position.maxScrollExtent);
      }
    });

    setState(() {
      messages.add(chatMessageModel);
    });
  }

  ScrollController controller = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _HomeAppBar(),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 10),
            _ChatList(),
            const SizedBox(height: 10),
            _Footer(context)
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _HomeAppBar() {
    return AppBar(
      toolbarHeight: 48,
      flexibleSpace: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Container(
            color: Color(APP_BAR_BACKGROUND_COLOR),
          ),
          SafeArea(
            child: Container(
              height: 48,
              child: Row(
                children: [
                  SizedBox(width: 12),
                  GestureDetector(
                    onTap: (){
                      Navigator.of(context).pop();
                    },
                    child: Image.asset(
                      'asset/img/ic_back_arrow.png',
                      width: 24,
                      height: 24,
                    ),
                  ),
                  SizedBox(width: 8),
                  Image.asset(
                    'asset/img/ic_person.png',
                    width: 38,
                    height: 38,
                  ),
                  SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Stipop Flutter Developer',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        'Active now',
                        style: TextStyle(
                          color: Color(PERSON_STATUS_COLOR),
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  Expanded(child: Container()),
                  _HomePopupMenuButton(),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _HomePopupMenuButton() {
    return PopupMenuButton(
        icon: Image.asset(
          'asset/img/ic_menu.png',
          width: 24,
          height: 24,
        ),
        itemBuilder: (context) => <PopupMenuEntry>[
              PopupMenuItem(
                  child: Row(children: const [
                    Text('View at Second Screen'),
                  ]),
                  value: MenuEnum.SCREEN),
            ],
        onSelected: (value) async {
          switch (value) {
            case MenuEnum.SCREEN:
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => InformationScreen(userId)));
              break;
          }
        });
  }

  Widget _ChatList() {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          hideStipop(true);
        },
        child: ListView.builder(
          itemCount: messages.length,
          controller: controller,
          itemBuilder: (context, index) {
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              child: Align(
                alignment:
                    (messages[index].messageType == ChatMessageType.TEXT_OTHERS
                        ? Alignment.topLeft
                        : Alignment.topRight),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: (messages[index].messageType ==
                            ChatMessageType.TEXT_OTHERS)
                        ? Color(CHAT_BUBBLE_BACKGROUND_OTHERS)
                        : Color(CHAT_BUBBLE_BACKGROUND_ME),
                  ),
                  padding: const EdgeInsets.all(8),
                  child: ChatItem(messages[index]),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _Footer(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
      height: 60,
      width: MediaQuery.of(context).size.width,
      decoration: const BoxDecoration(
        color: Colors.white,
      ),
      child: Row(
        children: [
          _StipopButton(context),
          const SizedBox(width: 8),
          _TypingView(),
        ],
      ),
    );
  }

  Widget _StipopButton(BuildContext context) {
    return GestureDetector(
        onTap: () {
          stipop.show();
        },
        child: SizedBox(
          width: 32,
          height: 32,
          child: Center(
            child: Image.asset(
              'asset/img/ic_sticker.png',
              width: 22,
              height: 22,
              color: isSPShowing ? Colors.orange : Colors.grey,
            ),
          ),
        ));
  }

  Widget _TypingView() {
    return Expanded(
        child: Container(
      decoration: BoxDecoration(
        border: Border.all(
            color: const Color(0xFFD3D3D3),
            style: BorderStyle.solid,
            width: 1.0),
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: Row(
        children: [
          const SizedBox(width: 12),
          _HomeTextField(),
          const SizedBox(width: 12),
          _SendButton(),
          const SizedBox(width: 12),
        ],
      ),
    ));
  }

  Widget _HomeTextField() {
    return Expanded(
        child: TextField(
      onTap: () {
        hideStipop(false);
      },
      onChanged: (text) {
        setState(() {
          textString = text;
        });
      },
      controller: txtController,
      textAlign: TextAlign.left,
      decoration: const InputDecoration(
          isDense: true,
          border: InputBorder.none,
          hintText: "Type your message"),
      style: const TextStyle(fontSize: 14.0),
      maxLines: 1,
    ));
  }

  Widget _SendButton() {
    return GestureDetector(
      onTap: () {
        if (txtController.text != "") {
          _pushMessage(ChatMessageModel(
              messageContent: txtController.text,
              messageType: ChatMessageType.TEXT_ME));
          txtController.text = "";
          textString = "";
        }
      },
      child: Image.asset(
        'asset/img/ic_send.png',
        height: 24,
        width: 24,
        color: textString != "" ? Colors.orange : Colors.grey,
      ),
    );
  }
}
