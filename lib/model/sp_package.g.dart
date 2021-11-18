// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sp_package.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SPPackage _$SPPackageFromJson(Map<String, dynamic> json) => SPPackage(
      artistName: json['artistName'] as String?,
      download: json['download'] as String?,
      language: json['language'] as String?,
      newThing: json['new'] as String?,
      packageAnimated: json['packageAnimated'] as String?,
      packageCategory: json['packageCategory'] as String?,
      packageId: json['packageId'] as int? ?? -1,
      packageImg: json['packageImg'] as String?,
      packageKeywords: json['packageKeywords'] as String?,
      packageName: json['packageName'] as String?,
      wish: json['wish'] as String?,
      view: json['view'] as String?,
      order: json['order'] as int? ?? -1,
      stickers: (json['stickers'] as List<dynamic>?)
              ?.map((e) => SPSticker.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const <SPSticker>[],
    );

Map<String, dynamic> _$SPPackageToJson(SPPackage instance) => <String, dynamic>{
      'artistName': instance.artistName,
      'download': instance.download,
      'language': instance.language,
      'new': instance.newThing,
      'packageAnimated': instance.packageAnimated,
      'packageCategory': instance.packageCategory,
      'packageId': instance.packageId,
      'packageImg': instance.packageImg,
      'packageKeywords': instance.packageKeywords,
      'packageName': instance.packageName,
      'wish': instance.wish,
      'view': instance.view,
      'order': instance.order,
      'stickers': instance.stickers.map((e) => e.toJson()).toList(),
    };
