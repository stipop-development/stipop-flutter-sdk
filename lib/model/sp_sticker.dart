import 'package:json_annotation/json_annotation.dart';

part 'sp_sticker.g.dart';

@JsonSerializable(explicitToJson: true)
class SPSticker {
  @JsonKey(name: 'packageId')
  final int packageId;
  @JsonKey(name: 'stickerId')
  final int stickerId;
  @JsonKey(name: 'stickerImg')
  final String? stickerImg;
  @JsonKey(name: 'stickerImgLocalFilePath')
  final String? stickerImgLocalFilePath;
  @JsonKey(name: 'favoriteYN')
  final String favoriteYN;
  @JsonKey(name: 'keyword')
  final String keyword;

  SPSticker({
    this.packageId = -1,
    this.stickerId = -1,
    this.stickerImg,
    this.stickerImgLocalFilePath,
    this.favoriteYN = "",
    this.keyword = "",
  });

  factory SPSticker.fromJson(Map<String, dynamic> json) =>
      _$SPStickerFromJson(json);

  Map<String, dynamic> toJson() => _$SPStickerToJson(this);
}
