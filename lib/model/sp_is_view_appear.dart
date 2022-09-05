import 'package:json_annotation/json_annotation.dart';

part 'sp_is_view_appear.g.dart';

@JsonSerializable(explicitToJson: true)
class SPIsViewAppear {
  @JsonKey(name: 'isAppear')
  final bool isAppear;

  SPIsViewAppear({
    this.isAppear = false
  });

  factory SPIsViewAppear.fromJson(Map<String, dynamic> json) =>
      _$SPIsViewAppearFromJson(json);

  Map<String, dynamic> toJson() => _$SPIsViewAppearToJson(this);
}
