import 'dart:convert';

import 'package:cook_with_nhee/commons/widgets/app/app_toast.dart';
import 'package:cook_with_nhee/network/models/login_model.dart';
import 'package:cook_with_nhee/network/models/recipe_from_api_model.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get_connect/http/src/multipart/form_data.dart';
import 'package:get/get_connect/http/src/multipart/multipart_file.dart';

import '../http_interface.dart';
import '../models/api_response_model.dart';
import '../models/recipe_model.dart';

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
      '/recipes/create-magic-recipes',
      body: {'question': ingredients},
    );
    
    return await parseJson(res, (dynamic json) {
      if (json is Map<String, dynamic> && json.containsKey('message')) {
        final message = json['message'] as String? ?? 
            'Hành vi của bạn là nghiêm cấm khi sử dụng. Danh sách nguyên liệu chứa yếu tố nguy hiểm hoặc bị cấm theo quy tắc an toàn thực phẩm.';
        AppToast.error('Cảnh báo', message);
        return <RecipeModel>[];
      }
      final list = json as List<dynamic>;
      return list
          .map((item) => RecipeModel.fromJson(item as Map<String, Object?>))
          .toList();
    });
  }

  Future<ApiResponseEntity<LoginModel>> login(
    String email,
    String password,
  ) async {
    try {
      final res = await request(
        ApiMethod.post,
        '/auth/login',
        body: {'email': email, 'password': password},
      );

      final entity = await parseJson(
        res,
        (dynamic json) => ApiResponseEntity.fromJson(
          json,
          (dynamic data) => LoginModel.fromJson(data),
        ),
      );
      return entity;
    } catch (e) {
      rethrow;
    }
  }

  Future<ApiResponseEntity<User>> getMe() async {
    try {
      final res = await request(ApiMethod.get, '/auth/profile');
      final entity = await parseJson(
        res,
        (dynamic json) => ApiResponseEntity.fromJson(
          json,
          (dynamic data) => User.fromJson(data),
        ),
      );
      return entity;
    } catch (e) {
      rethrow;
    }
  }

  Future<ApiResponseEntity<User>> updateProfile({
    String? name,
    String? phone,
    String? hobby,
  }) async {
    try {
      final body = <String, dynamic>{};
      if (name != null) body['name'] = name;
      if (phone != null) body['phone'] = phone;
      if (hobby != null) body['hobby'] = hobby;

      final res = await request(ApiMethod.put, '/auth/profile', body: body);
      final entity = await parseJson(
        res,
        (dynamic json) => ApiResponseEntity.fromJson(
          json,
          (dynamic data) => User.fromJson(data),
        ),
      );
      return entity;
    } catch (e) {
      rethrow;
    }
  }

  Future<ApiResponseEntity<User>> uploadAvatar({
    required List<int> bytes,
    required String fileName,
  }) async {
    try {
      final formData = FormData({});

      formData.files.add(
        MapEntry(
          'avatar',
          MultipartFile(
            bytes,
            filename: fileName,
            contentType: 'image/jpeg',
          ),
        ),
      );

      final res = await request(
        ApiMethod.put,
        '/auth/profile/avatar',
        contentType: 'multipart/form-data',
        body: formData,
      );
      final entity = await parseJson(
        res,
        (dynamic json) => ApiResponseEntity.fromJson(
          json,
          (dynamic data) => User.fromJson(data),
        ),
      );
      return entity;
    } catch (e) {
      rethrow;
    }
  }

  Future<ApiResponseEntity<List<RecipeFromApiModel>>> getMyRecipes() async {
    try {
      final res = await request(ApiMethod.get, '/recipes');
      return await parseJson(res, (dynamic json) {
        return ApiResponseEntity.fromJson(json, (dynamic data) {
          final list = data as List<dynamic>;
          return list
              .map(
                (item) =>
                    RecipeFromApiModel.fromJson(item as Map<String, Object?>),
              )
              .toList();
        });
      });
    } catch (e) {
      rethrow;
    }
  }

  Future<ApiResponseEntity<RecipeFromApiModel>> saveRecipe(
    RecipeFromApiModel recipe,
  ) async {
    try {
      final body = <String, dynamic>{};
      if (recipe.name != null) body['name'] = recipe.name;
      if (recipe.description != null) body['description'] = recipe.description;
      if (recipe.ingredients != null) {
        body['ingredients'] = recipe.ingredients!
            .map((v) => v.toJson())
            .toList();
      }
      if (recipe.tags != null) {
        body['tags'] = recipe.tags!.map((v) => v.toJson()).toList();
      }
      if (recipe.steps != null) body['steps'] = recipe.steps;
      if (recipe.notes != null) body['notes'] = recipe.notes;
      if (recipe.images != null && recipe.images!.isNotEmpty) {
        body['images'] = recipe.images;
      }
      if (recipe.videos != null && recipe.videos!.isNotEmpty) {
        body['videos'] = recipe.videos;
      }

      final res = await request(ApiMethod.post, '/recipes', body: body);
      final entity = await parseJson(
        res,
        (dynamic json) => ApiResponseEntity.fromJson(
          json,
          (dynamic data) => RecipeFromApiModel.fromJson(data),
        ),
      );
      return entity;
    } catch (e) {
      rethrow;
    }
  }
}

Future<T> parseJson<T>(dynamic json, T Function(dynamic json) fromJson) async {
  if (json == null) {
    return fromJson([]);
  }
  final res = await compute((dynamic json) {
    var decoded = json is String ? jsonDecode(json) : json;
    return fromJson(decoded);
  }, json);
  return res;
}
