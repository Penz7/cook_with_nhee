import 'dart:convert';

ApiResponseEntity<T> apiResponseEntityFromJson<T>(
    String str,
    T Function(dynamic) fromJsonT,
    ) =>
    ApiResponseEntity<T>.fromJson(json.decode(str), fromJsonT);

String apiResponseEntityToJson<T>(ApiResponseEntity<T> data) =>
    json.encode(data.toJson());

class ApiResponseEntity<T> {
  ApiResponseEntity({
    int? status,
    T? data,
    String? message,
  }) {
    _status = status;
    _data = data;
    _message = message;
  }

  ApiResponseEntity.fromJson(dynamic json, T Function(dynamic) fromJsonT) {
    _status = json['status'];
    _data = json['data'] != null ? fromJsonT(json['data']) : null;
    _message = json['message'];
  }

  int? _status;
  T? _data;
  String? _message;

  ApiResponseEntity<T> copyWith({
    int? status,
    T? data,
    String? message,
  }) =>
      ApiResponseEntity<T>(
        status: status ?? _status,
        data: data ?? _data,
        message: message ?? _message,
      );

  int? get status => _status;
  T? get data => _data;
  String? get message => _message;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = _status;
    map['data'] = _data is Map
        ? (_data as Map).map((key, value) => MapEntry(key.toString(), value))
        : _data;
    map['message'] = _message;
    return map;
  }
}
