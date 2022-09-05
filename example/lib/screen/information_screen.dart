import 'package:flutter/material.dart';
import 'package:stipop_sdk/stipop_plugin.dart';

class InformationScreen extends StatefulWidget {
  String userId;

  InformationScreen(this.userId, {Key? key}) : super(key: key);

  @override
  State<InformationScreen> createState() => _InformationScreenState(userId);
}

class _InformationScreenState extends State<InformationScreen> {

  String userId;

  Stipop stipop = Stipop();
  String callbackMsg = '';
  String? stickerImg;

  _InformationScreenState(this.userId);

  @override
  void initState() {
    super.initState();
    _spConnect();
  }

  void _spConnect(){
    stipop.connect(
      userId: userId,
      onStickerSingleTapped: (sticker) {
        setState(() {
          callbackMsg = 'onStickerSingleTapped\n${sticker.toJson()}';
          stickerImg = sticker.stickerImg;
        });
      },
      onStickerDoubleTapped: (sticker) {
        setState(() {
          callbackMsg = 'onStickerDoubleTapped\n${sticker.toJson()}';
          stickerImg = sticker.stickerImg;
        });
      },
      onStickerPackSelected: (spPackage) {
        setState(() {
          callbackMsg = 'onStickerPackSelected\n${spPackage.toJson()}';
          stickerImg = null;
        });
      },
    );
  }

  @override
  void dispose() {
    stipop.hide();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: _InformationScreenAppBar(),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              _InformationScreenTextField(),
              const SizedBox(height: 8.0),
              _StipopButton(),
              const SizedBox(height: 8.0),
              if (stickerImg != null) _SPStickerImage(),
              _SpCallbackText(),
            ],
          ),
        )
    );
  }

  PreferredSizeWidget _InformationScreenAppBar(){
    return AppBar(
      title: const Text("Second Screen"),
    );
  }
  Widget _InformationScreenTextField(){
    return const TextField(
      decoration: InputDecoration(
        hintText: 'Sample TextField',
      ),
    );
  }
  Widget _StipopButton(){
    return TextButton(
      onPressed: () {
        stipop.show();
      },
      child: const Text('Click to show Keyboard View'),
    );
  }
  Widget _SPStickerImage(){
      return Image.network(
        stickerImg!,
        width: 100,
        height: 100,
      );
  }
  Widget _SpCallbackText(){
    return Expanded(
      child: Text('Callback : \n$callbackMsg'),
    );
  }
}
