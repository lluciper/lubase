// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../login_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LoginResponse _$LoginResponseFromJson(Map<String, dynamic> json) =>
    LoginResponse(
      userName: json['userName'] as String?,
      email: json['email'] as String?,
      userPhone: json['userPhone'] as String?,
      createdAt: json['createdAt'] as String?,
    );

Map<String, dynamic> _$LoginResponseToJson(LoginResponse instance) =>
    <String, dynamic>{
      if (instance.userName case final value?) 'userName': value,
      if (instance.email case final value?) 'email': value,
      if (instance.userPhone case final value?) 'userPhone': value,
      if (instance.createdAt case final value?) 'createdAt': value,
    };
