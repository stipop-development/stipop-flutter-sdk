import 'dart:async';

import 'package:flutter/services.dart';
import 'package:stipop_sdk/model/sp_is_view_appear.dart';
import 'package:stipop_sdk/model/sp_package.dart';
import 'package:stipop_sdk/model/sp_sticker.dart';

class Stipop {
  static const String channelTag = 'stipop_plugin';
  static const String showTag = 'show';
  static const String connectTag = 'connect';
  static const String hideTag = 'hide';

  static const String onStickerPackSelectedLegacyTag = 'canDownload';
  static const String onStickerPackSelectedTag = 'onStickerPackRequested';
  static const String onStickerSingleTappedTag = 'onStickerSingleTapped';
  static const String onStickerDoubleTappedTag = 'onStickerDoubleTapped';

  static const String pickerViewIsAppearTag = 'pickerViewIsAppear';

  static const MethodChannel _channel = MethodChannel(channelTag);

  String? userId;

  void Function(SPSticker spSticker)? onStickerSingleTapped;
  void Function(SPSticker spSticker)? onStickerDoubleTapped;
  void Function(SPPackage spPackage)? onStickerPackSelected;

  void Function(SPIsViewAppear spIsViewAppear)? pickerViewAppear;

  Future connect({
    userId,
    Function(SPSticker spSticker)? onStickerSingleTapped,
    Function(SPSticker spSticker)? onStickerDoubleTapped,
    Function(SPPackage spPackage)? onStickerPackSelected,
    Function(SPIsViewAppear spIsViewAppear)? pickerViewAppear,
  }) async {
    this.userId = userId;
    this.onStickerSingleTapped = onStickerSingleTapped;
    this.onStickerDoubleTapped = onStickerDoubleTapped;
    this.onStickerPackSelected = onStickerPackSelected;
    this.pickerViewAppear = pickerViewAppear;

    _setHandler();
    return await _channel.invokeMethod(connectTag, {
      'userID': userId
    });
  }

  Future<bool> show() async {
    _setHandler();
    return await _channel.invokeMethod(showTag, {});
  }

  Future hide() async {
    return await _channel.invokeMethod(hideTag);
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
          case onStickerSingleTappedTag:
            try {
              onStickerSingleTapped?.call(SPSticker.fromJson(
                  Map<String, dynamic>.from(call.arguments)));
            } catch (e) {
              throw convertErrorToPlatformException(e);
            }
            break;
          case onStickerDoubleTappedTag:
            try {
              onStickerDoubleTapped?.call(SPSticker.fromJson(
                  Map<String, dynamic>.from(call.arguments)));
            } catch (e) {
              throw convertErrorToPlatformException(e);
            }
            break;

          case pickerViewIsAppearTag:
            try {
              pickerViewAppear?.call(SPIsViewAppear.fromJson(
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
