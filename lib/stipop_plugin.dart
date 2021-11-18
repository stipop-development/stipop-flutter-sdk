import 'dart:async';

import 'package:flutter/services.dart';
import 'package:stipop_sdk/model/sp_package.dart';
import 'package:stipop_sdk/model/sp_sticker.dart';

class Stipop {
  static const MethodChannel _channel = MethodChannel('stipop_plugin');
  static const String SHOW_KEYBOARD = 'showKeyboard';
  static const String SHOW_SEARCH = 'showSearch';
  static const String HIDE_KEYBOARD = 'hideKeyboard';
  static const String CAN_DOWNLOAD = 'canDownload';
  static const String ON_STICKER_SELECTED = 'onStickerSelected';

  final void Function(SPPackage spPackage)? canDownlaod;
  final void Function(SPSticker sticker)? onStickerSelected;

  Stipop({this.canDownlaod, this.onStickerSelected}) {
    _channel.setMethodCallHandler(
      (call) async {
        switch (call.method) {
          case CAN_DOWNLOAD:
            try {
              canDownlaod?.call(SPPackage.fromJson(
                  Map<String, dynamic>.from(call.arguments)));
            } catch (e) {
              throw convertErrorToPlatformException(e);
            }
            break;
          case ON_STICKER_SELECTED:
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
    return await _channel.invokeMethod(SHOW_KEYBOARD);
  }

  Future showSearch() async {
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
