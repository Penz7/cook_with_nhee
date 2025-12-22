import 'dart:convert';
/// id : "6939505de79ae5d813afb876"
/// userId : "69394c15a28895bddff28ba0"
/// dietType : "pescatarian"
/// defaultCuisine : "vietnamese"
/// otherCuisines : ["japanese","korean","thai","chinese"]
/// allergies : ["lobster","fish"]
/// dislikedIngredients : ["mushroom"]
/// createdAt : "2025-12-10T10:50:05.603Z"
/// updatedAt : "2025-12-10T10:51:41.424Z"

UserDietPreferenceModel userDietPreferenceModelFromJson(String str) => UserDietPreferenceModel.fromJson(json.decode(str));
String userDietPreferenceModelToJson(UserDietPreferenceModel data) => json.encode(data.toJson());
class UserDietPreferenceModel {
  UserDietPreferenceModel({
      String? id, 
      String? userId, 
      String? dietType, 
      String? defaultCuisine, 
      List<String>? otherCuisines, 
      List<String>? allergies, 
      List<String>? dislikedIngredients, 
      String? createdAt, 
      String? updatedAt,}){
    _id = id;
    _userId = userId;
    _dietType = dietType;
    _defaultCuisine = defaultCuisine;
    _otherCuisines = otherCuisines;
    _allergies = allergies;
    _dislikedIngredients = dislikedIngredients;
    _createdAt = createdAt;
    _updatedAt = updatedAt;
}

  UserDietPreferenceModel.fromJson(dynamic json) {
    _id = json['id'];
    _userId = json['userId'];
    _dietType = json['dietType'];
    _defaultCuisine = json['defaultCuisine'];
    _otherCuisines = json['otherCuisines'] != null ? json['otherCuisines'].cast<String>() : [];
    _allergies = json['allergies'] != null ? json['allergies'].cast<String>() : [];
    _dislikedIngredients = json['dislikedIngredients'] != null ? json['dislikedIngredients'].cast<String>() : [];
    _createdAt = json['createdAt'];
    _updatedAt = json['updatedAt'];
  }
  String? _id;
  String? _userId;
  String? _dietType;
  String? _defaultCuisine;
  List<String>? _otherCuisines;
  List<String>? _allergies;
  List<String>? _dislikedIngredients;
  String? _createdAt;
  String? _updatedAt;
UserDietPreferenceModel copyWith({  String? id,
  String? userId,
  String? dietType,
  String? defaultCuisine,
  List<String>? otherCuisines,
  List<String>? allergies,
  List<String>? dislikedIngredients,
  String? createdAt,
  String? updatedAt,
}) => UserDietPreferenceModel(  id: id ?? _id,
  userId: userId ?? _userId,
  dietType: dietType ?? _dietType,
  defaultCuisine: defaultCuisine ?? _defaultCuisine,
  otherCuisines: otherCuisines ?? _otherCuisines,
  allergies: allergies ?? _allergies,
  dislikedIngredients: dislikedIngredients ?? _dislikedIngredients,
  createdAt: createdAt ?? _createdAt,
  updatedAt: updatedAt ?? _updatedAt,
);
  String? get id => _id;
  String? get userId => _userId;
  String? get dietType => _dietType;
  String? get defaultCuisine => _defaultCuisine;
  List<String>? get otherCuisines => _otherCuisines;
  List<String>? get allergies => _allergies;
  List<String>? get dislikedIngredients => _dislikedIngredients;
  String? get createdAt => _createdAt;
  String? get updatedAt => _updatedAt;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['userId'] = _userId;
    map['dietType'] = _dietType;
    map['defaultCuisine'] = _defaultCuisine;
    map['otherCuisines'] = _otherCuisines;
    map['allergies'] = _allergies;
    map['dislikedIngredients'] = _dislikedIngredients;
    map['createdAt'] = _createdAt;
    map['updatedAt'] = _updatedAt;
    return map;
  }

}