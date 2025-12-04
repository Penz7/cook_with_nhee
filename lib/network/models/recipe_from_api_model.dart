import 'dart:convert';
/// id : "1bf5b1dd-9d2c-406b-a890-5077c25fafea"
/// name : "Phở bò"
/// description : "Món phở bò truyền thống Việt Nam"
/// ingredients : [{"id":"thit_bo","name":"Thịt bò","quantity":"300g"},{"id":"banh_pho","name":"Bánh phở","quantity":"200g"}]
/// tags : [{"id":"an_sang","name":"Ăn sáng"},{"id":"mon_nuoc","name":"Món nước"}]
/// steps : ["Sơ chế nguyên liệu","Ninh xương làm nước dùng","Trụng bánh phở và chan nước dùng"]
/// notes : "string"
/// images : ["https://example.com/pho-1.jpg"]
/// videos : ["https://youtube.com/watch?v=..."]
/// created_at : "2025-12-03T10:28:21.150Z"
/// updated_at : "2025-12-03T10:28:21.150Z"
/// created_by : "87804094-a39d-4652-a91e-ccf69dbe320f"

RecipeFromApiModel recipeFromApiModelFromJson(String str) => RecipeFromApiModel.fromJson(json.decode(str));
String recipeFromApiModelToJson(RecipeFromApiModel data) => json.encode(data.toJson());
class RecipeFromApiModel {
  RecipeFromApiModel({
      String? id, 
      String? name, 
      String? description, 
      List<Ingredients>? ingredients, 
      List<Tags>? tags, 
      List<String>? steps, 
      String? notes, 
      List<String>? images, 
      List<String>? videos, 
      String? createdAt, 
      String? updatedAt, 
      String? createdBy,}){
    _id = id;
    _name = name;
    _description = description;
    _ingredients = ingredients;
    _tags = tags;
    _steps = steps;
    _notes = notes;
    _images = images;
    _videos = videos;
    _createdAt = createdAt;
    _updatedAt = updatedAt;
    _createdBy = createdBy;
}

  RecipeFromApiModel.fromJson(dynamic json) {
    _id = json['id'];
    _name = json['name'];
    _description = json['description'];
    if (json['ingredients'] != null) {
      _ingredients = [];
      json['ingredients'].forEach((v) {
        _ingredients?.add(Ingredients.fromJson(v));
      });
    }
    if (json['tags'] != null) {
      _tags = [];
      json['tags'].forEach((v) {
        _tags?.add(Tags.fromJson(v));
      });
    }
    _steps = json['steps'] != null ? json['steps'].cast<String>() : [];
    _notes = json['notes'];
    _images = json['images'] != null ? json['images'].cast<String>() : [];
    _videos = json['videos'] != null ? json['videos'].cast<String>() : [];
    _createdAt = json['created_at'];
    _updatedAt = json['updated_at'];
    _createdBy = json['created_by'];
  }
  String? _id;
  String? _name;
  String? _description;
  List<Ingredients>? _ingredients;
  List<Tags>? _tags;
  List<String>? _steps;
  String? _notes;
  List<String>? _images;
  List<String>? _videos;
  String? _createdAt;
  String? _updatedAt;
  String? _createdBy;
RecipeFromApiModel copyWith({  String? id,
  String? name,
  String? description,
  List<Ingredients>? ingredients,
  List<Tags>? tags,
  List<String>? steps,
  String? notes,
  List<String>? images,
  List<String>? videos,
  String? createdAt,
  String? updatedAt,
  String? createdBy,
}) => RecipeFromApiModel(  id: id ?? _id,
  name: name ?? _name,
  description: description ?? _description,
  ingredients: ingredients ?? _ingredients,
  tags: tags ?? _tags,
  steps: steps ?? _steps,
  notes: notes ?? _notes,
  images: images ?? _images,
  videos: videos ?? _videos,
  createdAt: createdAt ?? _createdAt,
  updatedAt: updatedAt ?? _updatedAt,
  createdBy: createdBy ?? _createdBy,
);
  String? get id => _id;
  String? get name => _name;
  String? get description => _description;
  List<Ingredients>? get ingredients => _ingredients;
  List<Tags>? get tags => _tags;
  List<String>? get steps => _steps;
  String? get notes => _notes;
  List<String>? get images => _images;
  List<String>? get videos => _videos;
  String? get createdAt => _createdAt;
  String? get updatedAt => _updatedAt;
  String? get createdBy => _createdBy;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['name'] = _name;
    map['description'] = _description;
    if (_ingredients != null) {
      map['ingredients'] = _ingredients?.map((v) => v.toJson()).toList();
    }
    if (_tags != null) {
      map['tags'] = _tags?.map((v) => v.toJson()).toList();
    }
    map['steps'] = _steps;
    map['notes'] = _notes;
    map['images'] = _images;
    map['videos'] = _videos;
    map['created_at'] = _createdAt;
    map['updated_at'] = _updatedAt;
    map['created_by'] = _createdBy;
    return map;
  }

}

/// id : "an_sang"
/// name : "Ăn sáng"

Tags tagsFromJson(String str) => Tags.fromJson(json.decode(str));
String tagsToJson(Tags data) => json.encode(data.toJson());
class Tags {
  Tags({
      String? id, 
      String? name,}){
    _id = id;
    _name = name;
}

  Tags.fromJson(dynamic json) {
    _id = json['id'];
    _name = json['name'];
  }
  String? _id;
  String? _name;
Tags copyWith({  String? id,
  String? name,
}) => Tags(  id: id ?? _id,
  name: name ?? _name,
);
  String? get id => _id;
  String? get name => _name;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['name'] = _name;
    return map;
  }

}

/// id : "thit_bo"
/// name : "Thịt bò"
/// quantity : "300g"

Ingredients ingredientsFromJson(String str) => Ingredients.fromJson(json.decode(str));
String ingredientsToJson(Ingredients data) => json.encode(data.toJson());
class Ingredients {
  Ingredients({
      String? id, 
      String? name, 
      String? quantity,}){
    _id = id;
    _name = name;
    _quantity = quantity;
}

  Ingredients.fromJson(dynamic json) {
    _id = json['id'];
    _name = json['name'];
    _quantity = json['quantity'];
  }
  String? _id;
  String? _name;
  String? _quantity;
Ingredients copyWith({  String? id,
  String? name,
  String? quantity,
}) => Ingredients(  id: id ?? _id,
  name: name ?? _name,
  quantity: quantity ?? _quantity,
);
  String? get id => _id;
  String? get name => _name;
  String? get quantity => _quantity;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['name'] = _name;
    map['quantity'] = _quantity;
    return map;
  }

}