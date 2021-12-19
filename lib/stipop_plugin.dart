import 'dart:async';

import 'package:flutter/services.dart';
import 'package:stipop_sdk/model/sp_package.dart';
import 'package:stipop_sdk/model/sp_sticker.dart';

class Stipop {
  static const String CHANNEL = 'stipop_plugin';
  static const String SHOW_KEYBOARD = 'showKeyboard';
  static const String SHOW_SEARCH = 'showSearch';
  static const String HIDE_KEYBOARD = 'hideKeyboard';
  static const String ON_STICKER_PACK_SELECTED_LEGACY = 'canDownload';
  static const String ON_STICKER_PACK_SELECTED = 'onStickerPackRequested';
  static const String ON_STICKER_SELECTED = 'onStickerSelected';
  static const MethodChannel _channel = MethodChannel(CHANNEL);

  final void Function(SPPackage spPackage)? onStickerPackSelected;
  final void Function(SPSticker spSticker)? onStickerSelected;
  final String userId;
  final String? languageCode;

  bool _isSearch = false;

  Stipop(this.userId,
      {this.languageCode, this.onStickerPackSelected, this.onStickerSelected})
      : assert(userId.isNotEmpty, 'userID should not be empty') {
    _channel.setMethodCallHandler(
      (call) async {
        switch (call.method) {
          case ON_STICKER_PACK_SELECTED:
          case ON_STICKER_PACK_SELECTED_LEGACY:
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
    return await _channel.invokeMethod(
        SHOW_KEYBOARD, {'userID': userId, 'locale': languageCode});
  }

  Future showSearch() async {
    _isSearch = true;
    return await _channel
        .invokeMethod(SHOW_SEARCH, {'userID': userId, 'locale': languageCode});
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
