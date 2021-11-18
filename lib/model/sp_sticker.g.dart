// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sp_sticker.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SPSticker _$SPStickerFromJson(Map<String, dynamic> json) => SPSticker(
      packageId: json['packageId'] as int? ?? -1,
      stickerId: json['stickerId'] as int? ?? -1,
      stickerImg: json['stickerImg'] as String?,
      stickerImgLocalFilePath: json['stickerImgLocalFilePath'] as String?,
      favoriteYN: json['favoriteYN'] as String? ?? "",
      keyword: json['keyword'] as String? ?? "",
    );

Map<String, dynamic> _$SPStickerToJson(SPSticker instance) => <String, dynamic>{
      'packageId': instance.packageId,
      'stickerId': instance.stickerId,
      'stickerImg': instance.stickerImg,
      'stickerImgLocalFilePath': instance.stickerImgLocalFilePath,
      'favoriteYN': instance.favoriteYN,
      'keyword': instance.keyword,
    };
