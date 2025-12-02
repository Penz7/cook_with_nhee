import 'dart:convert';

import 'package:cook_with_nhee/network/models/recipe_model.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../http_interface.dart';

abstract class IApiClient {
  final IHttpClient _api;

  IApiClient(this._api);

  @protected
  Future<dynamic> request(
    ApiMethod method,
    String url, {
    Map<String, String>? headers,
    Map<String, String>? query,
    dynamic body,
    String? contentType,
    Function(double percent)? uploadProgress,
  }) async {
    return _api.request(
      method,
      url,
      headers: {...?headers},
      query: query,
      body: body,
      uploadProgress: uploadProgress,
      contentType: contentType,
    );
  }
}

/// ApiClient cụ thể dùng chung: cung cấp helper parse JSON
class ApiClient extends IApiClient {
  ApiClient(super.api);

  Future<String> getExternalIp() async {
    final res = await request(ApiMethod.get, 'https://wtfismyip.com/text');
    return res.toString().trim();
  }


  Future<List<RecipeModel>> getMagicRecipes(String ingredients) async {
    final res = await request(
      ApiMethod.post,
      '/perplexity',
      body: {
        'question': ingredients,
      },
    );
    return await parseJson(res, (dynamic json) {
      final list = json as List<dynamic>;
      return list.map((item) => RecipeModel.fromJson(item as Map<String, Object?>)).toList();
    });
  }
}


Future<T> parseJson<T>(
    dynamic json,
    T Function(dynamic json) fromJson,
    ) async {
  if (json == null) {
    return fromJson([]);
  }
  final res = await compute((dynamic json) {
    var decoded = json is String ? jsonDecode(json) : json;
    return fromJson(decoded);
  }, json);
  return res;
}

