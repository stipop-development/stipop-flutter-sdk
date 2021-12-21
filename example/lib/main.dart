import 'package:flutter/material.dart';
import 'package:stipop_sdk/stipop_plugin.dart';

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
          ),
          body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const TextField(
                  decoration: InputDecoration(
                    hintText: 'Sample TextField',
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextButton(
                    onPressed: () {
                      stipop.showKeyboard();
                    },
                    child: const Text('Click to show Keyboard View'),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextButton(
                    onPressed: () {
                      stipop.showSearch();
                    },
                    child: const Text('Click to show Search View'),
                  ),
                ),
                if (stickerImg != null)
                  Image.network(
                    stickerImg!,
                    width: 100,
                    height: 100,
                  ),
                Expanded(
                  child: Text('Callback : \n$callbackMsg'),
                ),
              ],
            ),
          )),
    );
  }
}
