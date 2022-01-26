import 'dart:async';

import 'package:flutter/services.dart';
import 'package:stipop_sdk/model/sp_package.dart';
import 'package:stipop_sdk/model/sp_sticker.dart';

class Stipop {
  static const String channelTag = 'stipop_plugin';
  static const String showKeyboardTag = 'showKeyboard';
  static const String showSearchTag = 'showSearch';
  static const String hideKeyboardTag = 'hideKeyboard';
  static const String onStickerPackSelectedLegacyTag = 'canDownload';
  static const String onStickerPackSelectedTag = 'onStickerPackRequested';
  static const String onStickerSelectedTag = 'onStickerSelected';
  static const MethodChannel _channel = MethodChannel(channelTag);

  final void Function(SPPackage spPackage)? onStickerPackSelected;
  final void Function(SPSticker spSticker)? onStickerSelected;
  final String userId;
  final String? languageCode;
  final String? countryCode;

  Stipop(this.userId,
      {this.languageCode,
      this.countryCode,
      this.onStickerPackSelected,
      this.onStickerSelected})
      : assert(userId.isNotEmpty, 'userID should not be empty'),
        assert((languageCode == null && countryCode == null) || (languageCode != null && countryCode != null), 'languageCode and countryCode should be null or not empty same time');

  Future showKeyboard() async {
    _setHandler();
    return await _channel.invokeMethod(showKeyboardTag, {
      'userID': userId,
      'languageCode': languageCode,
      'countryCode': countryCode
    });
  }

  Future showSearch() async {
    _setHandler();
    return await _channel.invokeMethod(showSearchTag, {
      'userID': userId,
      'languageCode': languageCode,
      'countryCode': countryCode
    });
  }

  Future hideKeyboard() async {
    return await _channel.invokeMethod(hideKeyboardTag);
  }

  PlatformException convertErrorToPlatformException(dynamic error) {
    return PlatformException(
      code: 'Exception',
      message: error.toString(),
    );
  }

  void _setHandler() {
    _channel.setMethodCallHandler(
      (call) async {
        switch (call.method) {
          case onStickerPackSelectedTag:
          case onStickerPackSelectedLegacyTag:
            try {
              onStickerPackSelected?.call(SPPackage.fromJson(
                  Map<String, dynamic>.from(call.arguments)));
            } catch (e) {
              throw convertErrorToPlatformException(e);
            }
            break;
          case onStickerSelectedTag:
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
}
