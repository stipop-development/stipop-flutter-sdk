import 'dart:async';

import 'package:flutter/services.dart';
import 'package:stipop_sdk/model/sp_package.dart';
import 'package:stipop_sdk/model/sp_sticker.dart';

class Stipop {
  static const MethodChannel _channel = MethodChannel('stipop_plugin');
  static const String SHOW_KEYBOARD = 'showKeyboard';
  static const String SHOW_SEARCH = 'showSearch';
  static const String HIDE_KEYBOARD = 'hideKeyboard';
  static const String ON_STICKER_PACK_SELECTED = 'canDownload';
  static const String ON_STICKER_SELECTED = 'onStickerSelected';

  final void Function(SPPackage spPackage)? onStickerPackSelected;
  final void Function(SPSticker spSticker)? onStickerSelected;
  bool _isSearch = false;

  Stipop({this.onStickerPackSelected, this.onStickerSelected}) {
    _channel.setMethodCallHandler(
      (call) async {
        switch (call.method) {
          case ON_STICKER_PACK_SELECTED:
            try {
              onStickerPackSelected?.call(SPPackage.fromJson(
                  Map<String, dynamic>.from(call.arguments)));
            } catch (e) {
              throw convertErrorToPlatformException(e);
            }
            break;
          case ON_STICKER_SELECTED:
            if (_isSearch) hideKeyboard();
            try {
              onStickerSelected?.call(SPSticker.fromJson(
                  Map<String, dynamic>.from(call.arguments)));
            } catch (e) {
              throw convertErrorToPlatformException(e);
            }
            break;
          default:
            throw ("method not defined");
        }
      },
    );
  }

  Future showKeyboard() async {
    _isSearch = false;
    return await _channel.invokeMethod(SHOW_KEYBOARD);
  }

  Future showSearch() async {
    _isSearch = true;
    return await _channel.invokeMethod(SHOW_SEARCH);
  }

  Future hideKeyboard() async {
    return await _channel.invokeMethod(HIDE_KEYBOARD);
  }

  PlatformException convertErrorToPlatformException(dynamic error) {
    return PlatformException(
      code: 'Exception',
      message: error.toString(),
    );
  }
}
