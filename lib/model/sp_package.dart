import 'package:json_annotation/json_annotation.dart';
import 'package:stipop_sdk/model/sp_sticker.dart';

part 'sp_package.g.dart';

@JsonSerializable(explicitToJson: true)
class SPPackage {
  @JsonKey(name: 'artistName')
  final String? artistName;
  @JsonKey(name: 'download')
  final String? download;
  @JsonKey(name: 'language')
  final String? language;
  @JsonKey(name: 'new')
  final String? newThing;
  @JsonKey(name: 'packageAnimated')
  final String? packageAnimated;
  @JsonKey(name: 'packageCategory')
  final String? packageCategory;
  @JsonKey(name: 'packageId')
  final int packageId;
  @JsonKey(name: 'packageImg')
  final String? packageImg;
  @JsonKey(name: 'packageKeywords')
  final String? packageKeywords;
  @JsonKey(name: 'packageName')
  final String? packageName;
  @JsonKey(name: 'wish')
  final String? wish;
  @JsonKey(name: 'view')
  final String? view;
  @JsonKey(name: 'order')
  final int order;
  @JsonKey(name: 'stickers')
  List<SPSticker> stickers;

  SPPackage({
    this.artistName,
    this.download,
    this.language,
    this.newThing,
    this.packageAnimated,
    this.packageCategory,
    this.packageId = -1,
    this.packageImg,
    this.packageKeywords,
    this.packageName,
    this.wish,
    this.view,
    this.order = -1,
    this.stickers = const <SPSticker>[],
  });

  factory SPPackage.fromJson(Map<String, dynamic> json) =>
      _$SPPackageFromJson(json);

  Map<String, dynamic> toJson() => _$SPPackageToJson(this);

  @JsonKey(ignore: true)
  bool get isDownload => download == 'Y';

  @JsonKey(ignore: true)
  bool get isView => view == 'Y';
}
