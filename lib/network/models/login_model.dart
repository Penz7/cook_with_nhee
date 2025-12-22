import 'dart:convert';
import 'package:cook_with_nhee/network/models/user_measurement_model.dart';
import 'package:cook_with_nhee/network/models/user_diet_preference_model.dart';
LoginModel loginModelFromJson(String str) => LoginModel.fromJson(json.decode(str));
String loginModelToJson(LoginModel data) => json.encode(data.toJson());
class LoginModel {
  LoginModel({
      String? accessToken, 
      User? user,}){
    _accessToken = accessToken;
    _user = user;
}

  LoginModel.fromJson(dynamic json) {
    _accessToken = json['accessToken'];
    _user = json['user'] != null ? User.fromJson(json['user']) : null;
  }
  String? _accessToken;
  User? _user;
LoginModel copyWith({  String? accessToken,
  User? user,
}) => LoginModel(  accessToken: accessToken ?? _accessToken,
  user: user ?? _user,
);
  String? get accessToken => _accessToken;
  User? get user => _user;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['accessToken'] = _accessToken;
    if (_user != null) {
      map['user'] = _user?.toJson();
    }
    return map;
  }

}

User userFromJson(String str) => User.fromJson(json.decode(str));
String userToJson(User data) => json.encode(data.toJson());
class User {
  User({
    String? id,
    String? email,
    String? name,
    String? fullName,
    String? phone,
    String? hobby,
    String? avatar,
    String? avatarUrl,
    String? gender,
    String? dateOfBirth,
    List<String>? hobbies,
    List<String>? favoriteActivities,
    num? totalRecipesSaved,
    num? totalDaysTracked,
    num? streakDays,
    String? lastLogin,
    bool? isActive,
    String? createdAt,
    String? updatedAt,
    String? role,
    num? recipeQuantity,
    UserMeasurementModel? userMeasurement,
    UserDietPreferenceModel? userDietPreference,
  }) {
    _id = id;
    _email = email;
    _name = name;
    _fullName = fullName;
    _phone = phone;
    _hobby = hobby;
    _avatar = avatar;
    _avatarUrl = avatarUrl;
    _gender = gender;
    _dateOfBirth = dateOfBirth;
    _hobbies = hobbies;
    _favoriteActivities = favoriteActivities;
    _totalRecipesSaved = totalRecipesSaved;
    _totalDaysTracked = totalDaysTracked;
    _streakDays = streakDays;
    _lastLogin = lastLogin;
    _isActive = isActive;
    _createdAt = createdAt;
    _updatedAt = updatedAt;
    _role = role;
    _recipeQuantity = recipeQuantity;
    _userMeasurement = userMeasurement;
    _userDietPreference = userDietPreference;
  }

  User.fromJson(dynamic json) {
    _id = json['id'];
    _email = json['email'];
    // Support both 'name' and 'fullName' fields
    _name = json['name'] ?? json['fullName'];
    _fullName = json['fullName'] ?? json['name'];
    _phone = json['phone'];
    _hobby = json['hobby'];
    // Support both 'avatar' and 'avatarUrl' fields
    _avatar = json['avatar'] ?? json['avatarUrl'];
    _avatarUrl = json['avatarUrl'] ?? json['avatar'];
    _gender = json['gender'];
    _dateOfBirth = json['dateOfBirth'];
    // Parse hobbies array
    if (json['hobbies'] != null) {
      _hobbies = [];
      if (json['hobbies'] is List) {
        _hobbies = List<String>.from(json['hobbies'].map((x) => x.toString()));
      } else if (json['hobbies'] is String) {
        // Backward compatibility: parse comma-separated string
        _hobbies = (json['hobbies'] as String).split(',').map((e) => e.trim()).where((e) => e.isNotEmpty).toList();
      }
    }
    // Parse favoriteActivities array
    if (json['favoriteActivities'] != null) {
      _favoriteActivities = [];
      if (json['favoriteActivities'] is List) {
        _favoriteActivities = List<String>.from(json['favoriteActivities'].map((x) => x.toString()));
      }
    }
    _totalRecipesSaved = json['totalRecipesSaved'];
    _totalDaysTracked = json['totalDaysTracked'];
    _streakDays = json['streakDays'];
    _lastLogin = json['lastLogin'];
    _isActive = json['isActive'];
    _createdAt = json['createdAt'];
    _updatedAt = json['updatedAt'];
    _role = json['role'];
    _recipeQuantity = json['recipeQuantity'];
    // Parse userMeasurement
    if (json['userMeasurement'] != null) {
      _userMeasurement = UserMeasurementModel.fromJson(json['userMeasurement']);
    }
    // Parse userDietPreference
    if (json['userDietPreference'] != null) {
      _userDietPreference = UserDietPreferenceModel.fromJson(json['userDietPreference']);
    }
  }

  String? _id;
  String? _email;
  String? _name;
  String? _fullName;
  String? _phone;
  String? _hobby;
  String? _avatar;
  String? _avatarUrl;
  String? _gender;
  String? _dateOfBirth;
  List<String>? _hobbies;
  List<String>? _favoriteActivities;
  num? _totalRecipesSaved;
  num? _totalDaysTracked;
  num? _streakDays;
  String? _lastLogin;
  bool? _isActive;
  String? _createdAt;
  String? _updatedAt;
  String? _role;
  num? _recipeQuantity;
  UserMeasurementModel? _userMeasurement;
  UserDietPreferenceModel? _userDietPreference;

  User copyWith({
    String? id,
    String? email,
    String? name,
    String? fullName,
    String? phone,
    String? hobby,
    String? avatar,
    String? avatarUrl,
    String? gender,
    String? dateOfBirth,
    List<String>? hobbies,
    List<String>? favoriteActivities,
    num? totalRecipesSaved,
    num? totalDaysTracked,
    num? streakDays,
    String? lastLogin,
    bool? isActive,
    String? createdAt,
    String? updatedAt,
    String? role,
    num? recipeQuantity,
    UserMeasurementModel? userMeasurement,
    UserDietPreferenceModel? userDietPreference,
  }) =>
      User(
        id: id ?? _id,
        email: email ?? _email,
        name: name ?? _name,
        fullName: fullName ?? _fullName,
        phone: phone ?? _phone,
        hobby: hobby ?? _hobby,
        avatar: avatar ?? _avatar,
        avatarUrl: avatarUrl ?? _avatarUrl,
        gender: gender ?? _gender,
        dateOfBirth: dateOfBirth ?? _dateOfBirth,
        hobbies: hobbies ?? _hobbies,
        favoriteActivities: favoriteActivities ?? _favoriteActivities,
        totalRecipesSaved: totalRecipesSaved ?? _totalRecipesSaved,
        totalDaysTracked: totalDaysTracked ?? _totalDaysTracked,
        streakDays: streakDays ?? _streakDays,
        lastLogin: lastLogin ?? _lastLogin,
        isActive: isActive ?? _isActive,
        createdAt: createdAt ?? _createdAt,
        updatedAt: updatedAt ?? _updatedAt,
        role: role ?? _role,
        recipeQuantity: recipeQuantity ?? _recipeQuantity,
        userMeasurement: userMeasurement ?? _userMeasurement,
        userDietPreference: userDietPreference ?? _userDietPreference,
      );

  String? get id => _id;
  String? get email => _email;
  String? get name => _name ?? _fullName;
  String? get fullName => _fullName ?? _name;
  String? get phone => _phone;
  String? get hobby => _hobby;
  String? get avatar => _avatar ?? _avatarUrl;
  String? get avatarUrl => _avatarUrl ?? _avatar;
  String? get gender => _gender;
  String? get dateOfBirth => _dateOfBirth;
  List<String>? get hobbies => _hobbies;
  List<String>? get favoriteActivities => _favoriteActivities;
  num? get totalRecipesSaved => _totalRecipesSaved;
  num? get totalDaysTracked => _totalDaysTracked;
  num? get streakDays => _streakDays;
  String? get lastLogin => _lastLogin;
  bool? get isActive => _isActive;
  String? get createdAt => _createdAt;
  String? get updatedAt => _updatedAt;
  String? get role => _role;
  num? get recipeQuantity => _recipeQuantity;
  UserMeasurementModel? get userMeasurement => _userMeasurement;
  UserDietPreferenceModel? get userDietPreference => _userDietPreference;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['email'] = _email;
    map['name'] = _name ?? _fullName;
    map['fullName'] = _fullName ?? _name;
    map['phone'] = _phone;
    map['hobby'] = _hobby;
    map['avatar'] = _avatar ?? _avatarUrl;
    map['avatarUrl'] = _avatarUrl ?? _avatar;
    map['gender'] = _gender;
    map['dateOfBirth'] = _dateOfBirth;
    map['hobbies'] = _hobbies;
    map['favoriteActivities'] = _favoriteActivities;
    map['totalRecipesSaved'] = _totalRecipesSaved;
    map['totalDaysTracked'] = _totalDaysTracked;
    map['streakDays'] = _streakDays;
    map['lastLogin'] = _lastLogin;
    map['isActive'] = _isActive;
    map['createdAt'] = _createdAt;
    map['updatedAt'] = _updatedAt;
    map['role'] = _role;
    map['recipeQuantity'] = _recipeQuantity;
    if (_userMeasurement != null) {
      map['userMeasurement'] = _userMeasurement?.toJson();
    }
    if (_userDietPreference != null) {
      map['userDietPreference'] = _userDietPreference?.toJson();
    }
    return map;
  }
}