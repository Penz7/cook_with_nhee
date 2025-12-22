import 'package:json_annotation/json_annotation.dart';

part 'user_model.g.dart';

@JsonSerializable()
class UserModel {
  final String? id;
  final String? email;
  final String? fullName;
  final String? avatarUrl;
  final String? gender;
  final String? dateOfBirth;
  final List<String>? hobbies;
  final List<String>? favoriteActivities;
  final num? totalRecipesSaved;
  final num? totalDaysTracked;
  final num? streakDays;
  final String? lastLogin;
  final bool? isActive;
  final String? createdAt;
  final String? updatedAt;
  final String? name;
  final String? avatar;
  final String? role;
  final num? recipeQuantity;

  UserModel({
    this.id,
    this.email,
    this.fullName,
    this.avatarUrl,
    this.gender,
    this.dateOfBirth,
    this.hobbies,
    this.favoriteActivities,
    this.totalRecipesSaved,
    this.totalDaysTracked,
    this.streakDays,
    this.lastLogin,
    this.isActive,
    this.createdAt,
    this.updatedAt,
    this.name,
    this.avatar,
    this.role,
    this.recipeQuantity,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => _$UserModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserModelToJson(this);
}
