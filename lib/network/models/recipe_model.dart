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
/// 
/// New API structure:
/// difficulty : "Trung bình"
/// target_audience : ["Người có BMI bình thường", "Ăn món Việt"]
/// cooking_time : "30 phút"
/// nutrition : {"calories": 350, "protein": 35, "fat": 10, "carbs": 20, "sodium": 700}
/// media_keywords : "Vietnamese ginger chicken stew with boiled greens"

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
      List<dynamic>? videos,
      // New fields from API
      String? difficulty,
      List<String>? targetAudience,
      String? cookingTime,
      Nutrition? nutrition,
      String? mediaKeywords,
      String? id,}){
    _id = id;
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
    _difficulty = difficulty;
    _targetAudience = targetAudience;
    _cookingTime = cookingTime;
    _nutrition = nutrition;
    _mediaKeywords = mediaKeywords;
}

  RecipeModel.fromJson(dynamic json) {
    _id = json['id'] ?? json['_id'];
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
    // Support both old format (cook_time, prep_time) and new format (cooking_time)
    _cookTime = json['cook_time'] ?? json['cooking_time'];
    _prepTime = json['prep_time'];
    _description = json['description'];
    _images = json['images'] ?? [];
    _videos = json['videos'] ?? [];
    // New fields
    _difficulty = json['difficulty'];
    _targetAudience = json['target_audience']?.cast<String>();
    _cookingTime = json['cooking_time'];
    _nutrition = json['nutrition'] != null ? Nutrition.fromJson(json['nutrition']) : null;
    _mediaKeywords = json['media_keywords'];
  }
  String? _id;
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
  // New fields
  String? _difficulty;
  List<String>? _targetAudience;
  String? _cookingTime;
  Nutrition? _nutrition;
  String? _mediaKeywords;

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
  String? difficulty,
  List<String>? targetAudience,
  String? cookingTime,
  Nutrition? nutrition,
  String? mediaKeywords,
  String? id,
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
  difficulty: difficulty ?? _difficulty,
  targetAudience: targetAudience ?? _targetAudience,
  cookingTime: cookingTime ?? _cookingTime,
  nutrition: nutrition ?? _nutrition,
  mediaKeywords: mediaKeywords ?? _mediaKeywords,
  id: id ?? _id,
);
  String? get id => _id;
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
  // New getters
  String? get difficulty => _difficulty;
  List<String>? get targetAudience => _targetAudience;
  String? get cookingTime => _cookingTime;
  Nutrition? get nutrition => _nutrition;
  String? get mediaKeywords => _mediaKeywords;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
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
    // New fields
    map['difficulty'] = _difficulty;
    map['target_audience'] = _targetAudience;
    map['cooking_time'] = _cookingTime;
    if (_nutrition != null) {
      map['nutrition'] = _nutrition?.toJson();
    }
    map['media_keywords'] = _mediaKeywords;
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

/// id : "bo" (optional in new API)
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
    // id is optional in new API format
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
    if (_id != null) {
      map['id'] = _id;
    }
    map['name'] = _name;
    map['quantity'] = _quantity;
    return map;
  }

}

/// calories : 350
/// protein : 35
/// fat : 10
/// carbs : 20
/// sodium : 700

Nutrition nutritionFromJson(String str) => Nutrition.fromJson(json.decode(str));
String nutritionToJson(Nutrition data) => json.encode(data.toJson());
class Nutrition {
  Nutrition({
      int? calories, 
      int? protein, 
      int? fat, 
      int? carbs, 
      int? sodium,}){
    _calories = calories;
    _protein = protein;
    _fat = fat;
    _carbs = carbs;
    _sodium = sodium;
}

  Nutrition.fromJson(dynamic json) {
    _calories = json['calories'];
    _protein = json['protein'];
    _fat = json['fat'];
    _carbs = json['carbs'];
    _sodium = json['sodium'];
  }
  int? _calories;
  int? _protein;
  int? _fat;
  int? _carbs;
  int? _sodium;

Nutrition copyWith({  int? calories,
  int? protein,
  int? fat,
  int? carbs,
  int? sodium,
}) => Nutrition(  calories: calories ?? _calories,
  protein: protein ?? _protein,
  fat: fat ?? _fat,
  carbs: carbs ?? _carbs,
  sodium: sodium ?? _sodium,
);
  int? get calories => _calories;
  int? get protein => _protein;
  int? get fat => _fat;
  int? get carbs => _carbs;
  int? get sodium => _sodium;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['calories'] = _calories;
    map['protein'] = _protein;
    map['fat'] = _fat;
    map['carbs'] = _carbs;
    map['sodium'] = _sodium;
    return map;
  }

}
