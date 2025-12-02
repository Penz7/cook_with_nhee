
import 'package:json_annotation/json_annotation.dart';

part 'user_model.g.dart';

@JsonSerializable()
class UserModel {
  final String username;
  final String email;
  final DateTime? dateOfBirth;

  UserModel({required this.username, required this.email, this.dateOfBirth});
}