import 'package:flutter/material.dart';
import 'package:stipop_plugin_example/second.dart';
import 'package:stipop_sdk/stipop_plugin.dart';

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
        });
      },
    );
  }

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
                        Navigator.of(context).push(MaterialPageRoute(builder: (context) => const SecondScreen()));
                        break;
                    }
                  })
            ],
          ),
          body: SafeArea(
            child: Stack(
              children: [
                Padding(
                  child: Column(children: [
                    stickerImg != null
                        ? Padding(
                            padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
                            child: Image.network(
                              stickerImg!,
                              width: 150,
                              height: 150,
                            ))
                        : Container(),
                    Text(callbackMsg)
                  ]),
                  padding: const EdgeInsets.fromLTRB(0, 0, 0, 70),
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
                        const Expanded(
                            child: TextField(
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: "TextField Sample"),
                        )),
                        const SizedBox(width: 16),
                        GestureDetector(
                            onTap: () {
                              //
                            },
                            child: Align(
                              alignment: Alignment.centerRight,
                              child: Container(
                                  height: 40,
                                  width: 40,
                                  decoration: BoxDecoration(
                                      color: Colors.grey,
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
}
