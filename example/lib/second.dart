import 'package:flutter/material.dart';
import 'package:stipop_sdk/stipop_plugin.dart';

class SecondScreen extends StatefulWidget {
  const SecondScreen({Key? key}) : super(key: key);

  @override
  State<SecondScreen> createState() => SecondState();
}

class SecondState extends State<SecondScreen> {
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
    return Scaffold(
        appBar: AppBar(
          title: const Text("Second Screen"),
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
        )
    );
  }
}
