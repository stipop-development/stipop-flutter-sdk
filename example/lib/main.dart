import 'package:flutter/material.dart';
import 'package:stipop_plugin/stipop_plugin.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late Stipop stipop;
  String callbackMsg = '';
  String? stickerImg = null;
  @override
  void initState() {
    super.initState();
    stipop = Stipop(
      canDownlaod: (spPackage) {
        setState(() {
          callbackMsg = 'canDownlaod\n${spPackage.toJson()}';
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
            title: const Text('Plugin example app'),
          ),
          body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextButton(
                    onPressed: () {
                      stipop.showKeyboard();
                    },
                    child: Text('Show Keyboard'),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextButton(
                    onPressed: () {
                      stipop.showSearch();
                    },
                    child: Text('Show Search'),
                  ),
                ),
                if (stickerImg != null)
                  Image.network(
                    stickerImg!,
                    width: 100,
                    height: 100,
                  ),
                Expanded(
                  child: Text('Stipop Callback\n$callbackMsg'),
                ),
              ],
            ),
          )),
    );
  }
}
