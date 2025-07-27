import 'package:json_annotation/json_annotation.dart';

part 'logged_user.g.dart';

@JsonSerializable()
class LoggedUser {
  final String username, password;
final String? image;
  LoggedUser( {required this.username, required this.password,this.image,});

  factory LoggedUser.fromJson(Map<String, dynamic> json) => _$LoggedUserFromJson(json);

  Map<String, dynamic> toJson() => _$LoggedUserToJson(this);
}