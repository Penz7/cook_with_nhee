import 'dart:convert';

NewDetailModel newDetailModelFromJson(String str) => NewDetailModel.fromJson(json.decode(str));
String newDetailModelToJson(NewDetailModel data) => json.encode(data.toJson());
class NewDetailModel {
  NewDetailModel({
      String? title, 
      String? content, 
      String? link, 
      String? subtitle, 
      String? author, 
      String? imageUrl, 
      String? excerpt,}){
    _title = title;
    _content = content;
    _link = link;
    _subtitle = subtitle;
    _author = author;
    _imageUrl = imageUrl;
    _excerpt = excerpt;
}

  NewDetailModel.fromJson(dynamic json) {
    _title = json['title'];
    _content = json['content'];
    _link = json['link'];
    _subtitle = json['subtitle'];
    _author = json['author'];
    _imageUrl = json['imageUrl'];
    _excerpt = json['excerpt'];
  }
  String? _title;
  String? _content;
  String? _link;
  String? _subtitle;
  String? _author;
  String? _imageUrl;
  String? _excerpt;
NewDetailModel copyWith({  String? title,
  String? content,
  String? link,
  String? subtitle,
  String? author,
  String? imageUrl,
  String? excerpt,
}) => NewDetailModel(  title: title ?? _title,
  content: content ?? _content,
  link: link ?? _link,
  subtitle: subtitle ?? _subtitle,
  author: author ?? _author,
  imageUrl: imageUrl ?? _imageUrl,
  excerpt: excerpt ?? _excerpt,
);
  String? get title => _title;
  String? get content => _content;
  String? get link => _link;
  String? get subtitle => _subtitle;
  String? get author => _author;
  String? get imageUrl => _imageUrl;
  String? get excerpt => _excerpt;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['title'] = _title;
    map['content'] = _content;
    map['link'] = _link;
    map['subtitle'] = _subtitle;
    map['author'] = _author;
    map['imageUrl'] = _imageUrl;
    map['excerpt'] = _excerpt;
    return map;
  }

}