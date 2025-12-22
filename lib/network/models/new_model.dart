import 'dart:convert';
/// title : "Warm up to tasty and nutritious winter squash"
/// link : "https://www.heart.org/en/news/2025/11/17/warm-up-to-tasty-and-nutritious-winter-squash"
/// date : "Nov 17, 2025"
/// teaser : "Categories:                                \nHealthy Living News                                    |\nTags:                                \nFood & Nutrition News, Eat It or Leave It"
/// subtitle : "Whether it’s butternut, acorn, buttercup, kabocha, delicata or something else, winter squash delivers big on flavor and health benefits."
/// imageUrl : "https://www.heart.org/-/media/Images/News/2025/November-2025/EIOLI_Squash.jpg?h=533&w=800&sc_lang=en&hash=CB957593F1CF9CC1AAE3626DB3FD65BA"

NewModel newModelFromJson(String str) => NewModel.fromJson(json.decode(str));
String newModelToJson(NewModel data) => json.encode(data.toJson());
class NewModel {
  NewModel({
      String? title, 
      String? link, 
      String? date, 
      String? teaser, 
      String? subtitle, 
      String? imageUrl,}){
    _title = title;
    _link = link;
    _date = date;
    _teaser = teaser;
    _subtitle = subtitle;
    _imageUrl = imageUrl;
}

  NewModel.fromJson(dynamic json) {
    _title = json['title'];
    _link = json['link'];
    _date = json['date'];
    _teaser = json['teaser'];
    _subtitle = json['subtitle'];
    _imageUrl = json['imageUrl'];
  }
  String? _title;
  String? _link;
  String? _date;
  String? _teaser;
  String? _subtitle;
  String? _imageUrl;
NewModel copyWith({  String? title,
  String? link,
  String? date,
  String? teaser,
  String? subtitle,
  String? imageUrl,
}) => NewModel(  title: title ?? _title,
  link: link ?? _link,
  date: date ?? _date,
  teaser: teaser ?? _teaser,
  subtitle: subtitle ?? _subtitle,
  imageUrl: imageUrl ?? _imageUrl,
);
  String? get title => _title;
  String? get link => _link;
  String? get date => _date;
  String? get teaser => _teaser;
  String? get subtitle => _subtitle;
  String? get imageUrl => _imageUrl;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['title'] = _title;
    map['link'] = _link;
    map['date'] = _date;
    map['teaser'] = _teaser;
    map['subtitle'] = _subtitle;
    map['imageUrl'] = _imageUrl;
    return map;
  }

}