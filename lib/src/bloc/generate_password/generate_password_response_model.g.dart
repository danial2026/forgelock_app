// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'generate_password_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PasswordGeneratorResponseModel _$PasswordGeneratorResponseModelFromJson(
        Map<String, dynamic> json) =>
    PasswordGeneratorResponseModel(
      password: json['password'] as String,
      time: json['time'] as int,
    );

Map<String, dynamic> _$PasswordGeneratorResponseModelToJson(
        PasswordGeneratorResponseModel instance) =>
    <String, dynamic>{
      'password': instance.password,
      'time': instance.time,
    };
