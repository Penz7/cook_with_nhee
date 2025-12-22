import 'dart:convert';
/// id : "69394c88e79ae5d813afb875"
/// userId : "69394c15a28895bddff28ba0"
/// weight : 49
/// height : 155
/// chest : 85
/// waist : 55
/// hip : 95
/// bmi : 20.4
/// healthyGoal : "Giảm cân xuống 45kg"
/// createdAt : "2025-12-10T10:33:44.356Z"
/// updatedAt : "2025-12-10T10:51:39.721Z"

UserMeasurementModel userMeasurementModelFromJson(String str) => UserMeasurementModel.fromJson(json.decode(str));
String userMeasurementModelToJson(UserMeasurementModel data) => json.encode(data.toJson());
class UserMeasurementModel {
  UserMeasurementModel({
      String? id, 
      String? userId, 
      num? weight, 
      num? height, 
      num? chest, 
      num? waist, 
      num? hip, 
      num? bmi, 
      String? healthyGoal, 
      String? createdAt, 
      String? updatedAt,}){
    _id = id;
    _userId = userId;
    _weight = weight;
    _height = height;
    _chest = chest;
    _waist = waist;
    _hip = hip;
    _bmi = bmi;
    _healthyGoal = healthyGoal;
    _createdAt = createdAt;
    _updatedAt = updatedAt;
}

  UserMeasurementModel.fromJson(dynamic json) {
    _id = json['id'];
    _userId = json['userId'];
    _weight = json['weight'];
    _height = json['height'];
    _chest = json['chest'];
    _waist = json['waist'];
    _hip = json['hip'];
    _bmi = json['bmi'];
    _healthyGoal = json['healthyGoal'];
    _createdAt = json['createdAt'];
    _updatedAt = json['updatedAt'];
  }
  String? _id;
  String? _userId;
  num? _weight;
  num? _height;
  num? _chest;
  num? _waist;
  num? _hip;
  num? _bmi;
  String? _healthyGoal;
  String? _createdAt;
  String? _updatedAt;
UserMeasurementModel copyWith({  String? id,
  String? userId,
  num? weight,
  num? height,
  num? chest,
  num? waist,
  num? hip,
  num? bmi,
  String? healthyGoal,
  String? createdAt,
  String? updatedAt,
}) => UserMeasurementModel(  id: id ?? _id,
  userId: userId ?? _userId,
  weight: weight ?? _weight,
  height: height ?? _height,
  chest: chest ?? _chest,
  waist: waist ?? _waist,
  hip: hip ?? _hip,
  bmi: bmi ?? _bmi,
  healthyGoal: healthyGoal ?? _healthyGoal,
  createdAt: createdAt ?? _createdAt,
  updatedAt: updatedAt ?? _updatedAt,
);
  String? get id => _id;
  String? get userId => _userId;
  num? get weight => _weight;
  num? get height => _height;
  num? get chest => _chest;
  num? get waist => _waist;
  num? get hip => _hip;
  num? get bmi => _bmi;
  String? get healthyGoal => _healthyGoal;
  String? get createdAt => _createdAt;
  String? get updatedAt => _updatedAt;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['userId'] = _userId;
    map['weight'] = _weight;
    map['height'] = _height;
    map['chest'] = _chest;
    map['waist'] = _waist;
    map['hip'] = _hip;
    map['bmi'] = _bmi;
    map['healthyGoal'] = _healthyGoal;
    map['createdAt'] = _createdAt;
    map['updatedAt'] = _updatedAt;
    return map;
  }

}