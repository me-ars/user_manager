// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'logged_user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LoggedUser _$LoggedUserFromJson(Map<String, dynamic> json) => LoggedUser(
      token: json['token'] as String,
      username: json['username'] as String,
      password: json['password'] as String,
      image: json['image'] as String?,
    );

Map<String, dynamic> _$LoggedUserToJson(LoggedUser instance) =>
    <String, dynamic>{
      'username': instance.username,
      'password': instance.password,
      'token': instance.token,
      'image': instance.image,
    };
