import 'dart:convert';
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

/// id : "87804094-a39d-4652-a91e-ccf69dbe320f"
/// email : "nhee@gmail.com"
/// name : "Ngọc Nhi"
/// phone : "0338777404"
/// hobby : "Đọc truyện, Xem phim, Ăn vặt, Bim bim, Trà sữa"
/// avatar : "https://okiywfwddpavqjwxdizz.supabase.co/storage/v1/object/public/cook-with-nhee/avatars/87804094-a39d-4652-a91e-ccf69dbe320f/1764757648083.jpeg"
/// createdAt : "2025-12-03T10:26:16.855Z"
/// role : "user"
/// recipeQuantity : 0

User userFromJson(String str) => User.fromJson(json.decode(str));
String userToJson(User data) => json.encode(data.toJson());
class User {
  User({
      String? id, 
      String? email, 
      String? name, 
      String? phone, 
      String? hobby, 
      String? avatar, 
      String? createdAt, 
      String? role, 
      num? recipeQuantity,}){
    _id = id;
    _email = email;
    _name = name;
    _phone = phone;
    _hobby = hobby;
    _avatar = avatar;
    _createdAt = createdAt;
    _role = role;
    _recipeQuantity = recipeQuantity;
}

  User.fromJson(dynamic json) {
    _id = json['id'];
    _email = json['email'];
    _name = json['name'];
    _phone = json['phone'];
    _hobby = json['hobby'];
    _avatar = json['avatar'];
    _createdAt = json['createdAt'];
    _role = json['role'];
    _recipeQuantity = json['recipeQuantity'];
  }
  String? _id;
  String? _email;
  String? _name;
  String? _phone;
  String? _hobby;
  String? _avatar;
  String? _createdAt;
  String? _role;
  num? _recipeQuantity;
User copyWith({  String? id,
  String? email,
  String? name,
  String? phone,
  String? hobby,
  String? avatar,
  String? createdAt,
  String? role,
  num? recipeQuantity,
}) => User(  id: id ?? _id,
  email: email ?? _email,
  name: name ?? _name,
  phone: phone ?? _phone,
  hobby: hobby ?? _hobby,
  avatar: avatar ?? _avatar,
  createdAt: createdAt ?? _createdAt,
  role: role ?? _role,
  recipeQuantity: recipeQuantity ?? _recipeQuantity,
);
  String? get id => _id;
  String? get email => _email;
  String? get name => _name;
  String? get phone => _phone;
  String? get hobby => _hobby;
  String? get avatar => _avatar;
  String? get createdAt => _createdAt;
  String? get role => _role;
  num? get recipeQuantity => _recipeQuantity;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['email'] = _email;
    map['name'] = _name;
    map['phone'] = _phone;
    map['hobby'] = _hobby;
    map['avatar'] = _avatar;
    map['createdAt'] = _createdAt;
    map['role'] = _role;
    map['recipeQuantity'] = _recipeQuantity;
    return map;
  }

}