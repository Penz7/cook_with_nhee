import 'dart:convert';
/// name : "Bò cháy tỏi"
/// ingredients : [{"id":"bo","name":"Thịt bò","quantity":"500 gr"},{"id":"trung_ga","name":"Trứng gà","quantity":"1 quả"},{"id":"toi","name":"Tỏi","quantity":"4 tép"},{"id":"hanh_tim","name":"Hành tím","quantity":"4 củ"},{"id":"ot","name":"Ớt","quantity":"1 ít"}]
/// tags : [{"id":"an_toi","name":"Ăn tối"},{"id":"mon_nhau","name":"Món nhậu"}]
/// steps : ["Bước 1: Thịt bò rửa sạch, thái lát mỏng rồi ướp với gia vị cơ bản (muối, tiêu, bột ngọt).","Bước 2: Đánh tan trứng gà, chuẩn bị bột bắp để tạo lớp áo cho bò.","Bước 3: Hành tím và tỏi bóc vỏ, băm nhỏ.Ớt thái nhỏ hoặc để nguyên tùy thích.","Bước 4: Đun nóng dầu, phi thơm tỏi và hành tím đến khi vàng thơm.","Bước 5: Áo thịt bò qua bột bắp và trứng, chiên nhanh trên chảo nóng cùng tỏi phi.","Bước 6: Nêm nếm lại cho vừa ăn, thêm ớt để món ăn có vị cay nhẹ."]
/// notes : "Có thể dùng thêm gừng để tăng hương vị nếu thích."
/// cook_time : "15 phút"
/// prep_time : "15 phút"
/// description : "Món bò cháy tỏi thơm lừng với thịt bò mềm, tỏi phi giòn và vị cay nồng của ớt, thích hợp làm món ăn chính hoặc nhậu."
/// images : []
/// videos : []

RecipeModel recipeModelFromJson(String str) => RecipeModel.fromJson(json.decode(str));
String recipeModelToJson(RecipeModel data) => json.encode(data.toJson());
class RecipeModel {
  RecipeModel({
      String? name, 
      List<Ingredients>? ingredients, 
      List<Tags>? tags, 
      List<String>? steps, 
      String? notes, 
      String? cookTime, 
      String? prepTime, 
      String? description, 
      List<dynamic>? images, 
      List<dynamic>? videos,}){
    _name = name;
    _ingredients = ingredients;
    _tags = tags;
    _steps = steps;
    _notes = notes;
    _cookTime = cookTime;
    _prepTime = prepTime;
    _description = description;
    _images = images;
    _videos = videos;
}

  RecipeModel.fromJson(dynamic json) {
    _name = json['name'];
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
    _cookTime = json['cook_time'];
    _prepTime = json['prep_time'];
    _description = json['description'];
    _images = json['images'] ?? [];
    _videos = json['videos'] ?? [];
  }
  String? _name;
  List<Ingredients>? _ingredients;
  List<Tags>? _tags;
  List<String>? _steps;
  String? _notes;
  String? _cookTime;
  String? _prepTime;
  String? _description;
  List<dynamic>? _images;
  List<dynamic>? _videos;
RecipeModel copyWith({  String? name,
  List<Ingredients>? ingredients,
  List<Tags>? tags,
  List<String>? steps,
  String? notes,
  String? cookTime,
  String? prepTime,
  String? description,
  List<dynamic>? images,
  List<dynamic>? videos,
}) => RecipeModel(  name: name ?? _name,
  ingredients: ingredients ?? _ingredients,
  tags: tags ?? _tags,
  steps: steps ?? _steps,
  notes: notes ?? _notes,
  cookTime: cookTime ?? _cookTime,
  prepTime: prepTime ?? _prepTime,
  description: description ?? _description,
  images: images ?? _images,
  videos: videos ?? _videos,
);
  String? get name => _name;
  List<Ingredients>? get ingredients => _ingredients;
  List<Tags>? get tags => _tags;
  List<String>? get steps => _steps;
  String? get notes => _notes;
  String? get cookTime => _cookTime;
  String? get prepTime => _prepTime;
  String? get description => _description;
  List<dynamic>? get images => _images;
  List<dynamic>? get videos => _videos;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['name'] = _name;
    if (_ingredients != null) {
      map['ingredients'] = _ingredients?.map((v) => v.toJson()).toList();
    }
    if (_tags != null) {
      map['tags'] = _tags?.map((v) => v.toJson()).toList();
    }
    map['steps'] = _steps;
    map['notes'] = _notes;
    map['cook_time'] = _cookTime;
    map['prep_time'] = _prepTime;
    map['description'] = _description;
    if (_images != null) {
      map['images'] = _images?.map((v) => v.toJson()).toList();
    }
    if (_videos != null) {
      map['videos'] = _videos?.map((v) => v.toJson()).toList();
    }
    return map;
  }

}

/// id : "an_toi"
/// name : "Ăn tối"

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

/// id : "bo"
/// name : "Thịt bò"
/// quantity : "500 gr"

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