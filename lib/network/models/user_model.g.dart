// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserModel _$UserModelFromJson(Map<String, dynamic> json) => UserModel(
  id: json['id'] as String?,
  email: json['email'] as String?,
  fullName: json['fullName'] as String?,
  avatarUrl: json['avatarUrl'] as String?,
  gender: json['gender'] as String?,
  dateOfBirth: json['dateOfBirth'] as String?,
  hobbies: (json['hobbies'] as List<dynamic>?)
      ?.map((e) => e as String)
      .toList(),
  favoriteActivities: (json['favoriteActivities'] as List<dynamic>?)
      ?.map((e) => e as String)
      .toList(),
  totalRecipesSaved: json['totalRecipesSaved'] as num?,
  totalDaysTracked: json['totalDaysTracked'] as num?,
  streakDays: json['streakDays'] as num?,
  lastLogin: json['lastLogin'] as String?,
  isActive: json['isActive'] as bool?,
  createdAt: json['createdAt'] as String?,
  updatedAt: json['updatedAt'] as String?,
  name: json['name'] as String?,
  avatar: json['avatar'] as String?,
  role: json['role'] as String?,
  recipeQuantity: json['recipeQuantity'] as num?,
);

Map<String, dynamic> _$UserModelToJson(UserModel instance) => <String, dynamic>{
  'id': instance.id,
  'email': instance.email,
  'fullName': instance.fullName,
  'avatarUrl': instance.avatarUrl,
  'gender': instance.gender,
  'dateOfBirth': instance.dateOfBirth,
  'hobbies': instance.hobbies,
  'favoriteActivities': instance.favoriteActivities,
  'totalRecipesSaved': instance.totalRecipesSaved,
  'totalDaysTracked': instance.totalDaysTracked,
  'streakDays': instance.streakDays,
  'lastLogin': instance.lastLogin,
  'isActive': instance.isActive,
  'createdAt': instance.createdAt,
  'updatedAt': instance.updatedAt,
  'name': instance.name,
  'avatar': instance.avatar,
  'role': instance.role,
  'recipeQuantity': instance.recipeQuantity,
};
