import 'package:json_annotation/json_annotation.dart';

part 'generate_password_response_model.g.dart';

@JsonSerializable()
class PasswordGeneratorResponseModel {
  @JsonKey(name: 'password')
  String password;

  @JsonKey(name: 'time')
  int time;

  PasswordGeneratorResponseModel({
    required this.password,
    required this.time,
  });

  factory PasswordGeneratorResponseModel.fromJson(Map<String, dynamic> json) => _$PasswordGeneratorResponseModelFromJson(json);

  Map<String, dynamic> toJson() => _$PasswordGeneratorResponseModelToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }
}
