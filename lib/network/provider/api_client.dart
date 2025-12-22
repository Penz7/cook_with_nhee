import 'dart:convert';

import 'package:cook_with_nhee/commons/widgets/app/app_toast.dart';
import 'package:cook_with_nhee/network/models/healthy_advice_model.dart';
import 'package:cook_with_nhee/network/models/login_model.dart';
import 'package:cook_with_nhee/network/models/new_detail_model.dart';
import 'package:cook_with_nhee/network/models/new_model.dart';
import 'package:cook_with_nhee/network/models/user_diet_preference_model.dart';
import 'package:cook_with_nhee/network/models/user_measurement_model.dart';
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
    Map<String, dynamic>? query,
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
      if (json is Map<String, dynamic>) {
        final status = json['status'] as String?;
        final errorCode = json['error_code'];
        final message = json['message'] as String?;
        final data = json['data'];

        if (status != 'success' || errorCode != null) {
          final errorMsg = message ?? 'Không thể tìm kiếm công thức';
          AppToast.error('Lỗi', errorMsg);
          return <RecipeModel>[];
        }

        if (data != null && data is List) {
          return data
              .map((item) => RecipeModel.fromJson(item as Map<String, Object?>))
              .toList();
        }

        return <RecipeModel>[];
      }

      // Nếu response là List trực tiếp
      if (json is List) {
        return json
            .map((item) => RecipeModel.fromJson(item as Map<String, Object?>))
            .toList();
      }

      return <RecipeModel>[];
    });
  }

  Future<List<RecipeModel>> getRecipeOfDay() async {
    try {
      final res = await request(ApiMethod.get, '/recipes/get-recipe-of-day');

      return await parseJson(res, (dynamic json) {
        if (json is Map<String, dynamic>) {
          final status = json['status'] as String?;
          final errorCode = json['error_code'];
          final message = json['message'] as String?;
          final data = json['data'];

          if (status != 'success' || errorCode != null) {
            final errorMsg = message ?? 'Không thể lấy công thức của ngày';
            AppToast.error('Lỗi', errorMsg);
            return <RecipeModel>[];
          }

          if (data != null && data is List) {
            return data
                .map(
                  (item) => RecipeModel.fromJson(item as Map<String, Object?>),
                )
                .toList();
          }

          return <RecipeModel>[];
        }

        return <RecipeModel>[];
      });
    } catch (e) {
      debugPrint('Lỗi gọi API getRecipeOfDay: $e');
      rethrow;
    }
  }

  Future<List<RecipeModel>> getRecommendationRecipes() async {
    try {
      final res = await request(
        ApiMethod.get,
        '/recipes/get-recommendation-recipe',
      );

      return await parseJson(res, (dynamic json) {
        if (json is Map<String, dynamic>) {
          final status = json['status'] as String?;
          final errorCode = json['error_code'];
          final message = json['message'] as String?;
          final data = json['data'];

          if (status != 'success' || errorCode != null) {
            final errorMsg =
                message ?? 'Không thể lấy danh sách công thức đề xuất';
            AppToast.error('Lỗi', errorMsg);
            return <RecipeModel>[];
          }

          if (data != null && data is List) {
            return data
                .map(
                  (item) => RecipeModel.fromJson(item as Map<String, Object?>),
                )
                .toList();
          }

          return <RecipeModel>[];
        }

        // Nếu response là List trực tiếp
        if (json is List) {
          return json
              .map((item) => RecipeModel.fromJson(item as Map<String, Object?>))
              .toList();
        }

        return <RecipeModel>[];
      });
    } catch (e) {
      debugPrint('Lỗi gọi API getRecommendationRecipes: $e');
      rethrow;
    }
  }

  Future<List<RecipeModel>> searchRecipes(String query, double bmi) async {
    try {
      final res = await request(
        ApiMethod.post,
        '/recipes/suggest-smart-search-recipes',
        body: {"query": query, "bmi": bmi},
      );

      return await parseJson(res, (dynamic json) {
        if (json is Map<String, dynamic>) {
          final status = json['status'] as String?;
          final errorCode = json['error_code'];
          final message = json['message'] as String?;
          final data = json['data'];

          if (status != 'success' || errorCode != null) {
            final errorMsg = message ?? 'Không thể tìm kiếm công thức';
            AppToast.error('Lỗi', errorMsg);
            return <RecipeModel>[];
          }

          if (data != null && data is List) {
            return data
                .map(
                  (item) => RecipeModel.fromJson(item as Map<String, Object?>),
                )
                .toList();
          }

          return <RecipeModel>[];
        }

        // Nếu response là List trực tiếp
        if (json is List) {
          return json
              .map((item) => RecipeModel.fromJson(item as Map<String, Object?>))
              .toList();
        }

        return <RecipeModel>[];
      });
    } catch (e) {
      debugPrint('Lỗi gọi API searchRecipes: $e');
      rethrow;
    }
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

  Future<ApiResponseEntity<LoginModel>> register(
    String email,
    String password,
    String fullName,
  ) async {
    try {
      final res = await request(
        ApiMethod.post,
        '/auth/register',
        body: {'email': email, 'password': password, 'fullName': fullName},
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
      final res = await request(ApiMethod.get, '/users/me');
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
    String? fullName,
    String? gender,
    String? dateOfBirth,
    List<String>? hobbies,
    List<String>? favoriteActivities,
  }) async {
    try {
      final body = <String, dynamic>{};
      if (name != null) body['name'] = name;
      if (phone != null) body['phone'] = phone;
      if (hobby != null) body['hobby'] = hobby;
      if (fullName != null) body['fullName'] = fullName;
      if (gender != null) body['gender'] = gender;
      if (dateOfBirth != null) body['dateOfBirth'] = dateOfBirth;
      if (hobbies != null) body['hobbies'] = hobbies;
      if (favoriteActivities != null) {
        body['favoriteActivities'] = favoriteActivities;
      }

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
          MultipartFile(bytes, filename: fileName, contentType: 'image/jpeg'),
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

  Future<ApiResponseEntity<List<RecipeModel>>> getMyRecipes({String? name}) async {
    try {
      final query = <String, String>{};
      if (name != null && name.isNotEmpty) {
        query['name'] = name;
      }
      final res = await request(
        ApiMethod.get,
        '/recipes',
        query: query.isNotEmpty ? query : null,
      );
      return await parseJson(res, (dynamic json) {
        return ApiResponseEntity.fromJson(json, (dynamic data) {
          final list = data as List<dynamic>;
          return list
              .map(
                (item) =>
                    RecipeModel.fromJson(item as Map<String, Object?>),
              )
              .toList();
        });
      });
    } catch (e) {
      rethrow;
    }
  }

  Future<ApiResponseEntity<bool>> deleteRecipe(String id) async {
    try {
      final res = await request(ApiMethod.delete, '/recipes/$id');
      return await parseJson(res, (dynamic json) {
        return ApiResponseEntity.fromJson(json, (dynamic data) {
          return true;
        });
      });
    } catch (e) {
      rethrow;
    }
  }

  Future<ApiResponseEntity<RecipeModel>> saveRecipe(
      RecipeModel recipe,
  ) async {
    try {
      final body = <String, dynamic>{};
      
      // Basic fields
      if (recipe.name != null) body['name'] = recipe.name;
      if (recipe.description != null) body['description'] = recipe.description;
      if (recipe.notes != null) body['notes'] = recipe.notes;
      
      // Ingredients
      if (recipe.ingredients != null) {
        body['ingredients'] = recipe.ingredients!
            .map((v) => v.toJson())
            .toList();
      }
      
      // Tags
      if (recipe.tags != null) {
        body['tags'] = recipe.tags!.map((v) => v.toJson()).toList();
      }
      
      // Steps
      if (recipe.steps != null) body['steps'] = recipe.steps;
      
      // Media
      if (recipe.images != null && recipe.images!.isNotEmpty) {
        body['images'] = recipe.images;
      }
      if (recipe.videos != null && recipe.videos!.isNotEmpty) {
        body['videos'] = recipe.videos;
      }
      
      // Time fields
      if (recipe.cookTime != null) body['cook_time'] = recipe.cookTime;
      if (recipe.prepTime != null) body['prep_time'] = recipe.prepTime;
      if (recipe.cookingTime != null) body['cooking_time'] = recipe.cookingTime;
      
      // Difficulty and target audience
      if (recipe.difficulty != null) body['difficulty'] = recipe.difficulty;
      if (recipe.targetAudience != null && recipe.targetAudience!.isNotEmpty) {
        body['target_audience'] = recipe.targetAudience;
      }
      
      // Nutrition - important field
      if (recipe.nutrition != null) {
        body['nutrition'] = recipe.nutrition!.toJson();
      }
      
      // Media keywords
      if (recipe.mediaKeywords != null) {
        body['media_keywords'] = recipe.mediaKeywords;
      }

      final res = await request(ApiMethod.post, '/recipes', body: body);
      final entity = await parseJson(
        res,
        (dynamic json) => ApiResponseEntity.fromJson(
          json,
          (dynamic data) => RecipeModel.fromJson(data),
        ),
      );
      return entity;
    } catch (e) {
      rethrow;
    }
  }

  Future<ApiResponseEntity<UserMeasurementModel>> getMeasurements() async {
    try {
      final res = await request(ApiMethod.get, '/users/me/measurements');
      final entity = await parseJson(
        res,
        (dynamic json) => ApiResponseEntity.fromJson(
          json,
          (dynamic data) => UserMeasurementModel.fromJson(data),
        ),
      );
      return entity;
    } catch (e) {
      rethrow;
    }
  }

  Future<ApiResponseEntity<UserDietPreferenceModel>> getDietPreference() async {
    try {
      final res = await request(ApiMethod.get, '/users/me/diet-preferences');
      final entity = await parseJson(
        res,
        (dynamic json) => ApiResponseEntity.fromJson(
          json,
          (dynamic data) => UserDietPreferenceModel.fromJson(data),
        ),
      );
      return entity;
    } catch (e) {
      rethrow;
    }
  }

  Future<ApiResponseEntity<Map<String, dynamic>>> updateDietPreferences({
    required String dietType,
    required String defaultCuisine,
    List<String>? otherCuisines,
    List<String>? allergies,
    List<String>? dislikedIngredients,
  }) async {
    try {
      final body = <String, dynamic>{
        'dietType': dietType,
        'defaultCuisine': defaultCuisine,
        'otherCuisines': otherCuisines ?? <String>[],
        'allergies': allergies ?? <String>[],
        'dislikedIngredients': dislikedIngredients ?? <String>[],
      };

      final res = await request(
        ApiMethod.post,
        '/users/me/diet-preferences',
        body: body,
      );

      final entity = await parseJson(
        res,
        (dynamic json) => ApiResponseEntity.fromJson(
          json,
          (dynamic data) =>
              data is Map<String, dynamic> ? data : <String, dynamic>{},
        ),
      );

      return entity;
    } catch (e) {
      rethrow;
    }
  }

  Future<ApiResponseEntity<Map<String, dynamic>>> updateMeasurement({
    required int weight,
    required int height,
    int? chest,
    int? waist,
    int? hip,
    String? healthyGoal,
  }) async {
    try {
      final body = <String, dynamic>{'weight': weight, 'height': height};
      if (chest != null) body['chest'] = chest;
      if (waist != null) body['waist'] = waist;
      if (hip != null) body['hip'] = hip;
      if (healthyGoal != null && healthyGoal.isNotEmpty) {
        body['healthyGoal'] = healthyGoal;
      }

      final res = await request(
        ApiMethod.post,
        '/users/me/measurements',
        body: body,
      );

      final entity = await parseJson(
        res,
        (dynamic json) => ApiResponseEntity.fromJson(
          json,
          (dynamic data) =>
              data is Map<String, dynamic> ? data : <String, dynamic>{},
        ),
      );

      return entity;
    } catch (e) {
      rethrow;
    }
  }

  Future<ApiResponseEntity<HealthyAdviceModel>> getHealthyAdvice(
    double bmi,
  ) async {
    try {
      final res = await request(
        ApiMethod.post,
        '/healthy-advice/evaluate-bmi',
        body: {"bmi": bmi},
      );
      final entity = await parseJson(
        res,
        (dynamic json) => ApiResponseEntity.fromJson(
          json,
          (dynamic data) => HealthyAdviceModel.fromJson(data),
        ),
      );
      return entity;
    } catch (e) {
      rethrow;
    }
  }

  /// News
  Future<ApiResponseEntity<List<NewModel>>> getNews(int page) async {
    try {
      final res = await request(
        ApiMethod.get,
        '/news/food-nutrition',
        query: {"page": page.toString()},
      );
      return await parseJson(res, (dynamic json) {
        return ApiResponseEntity.fromJson(json, (dynamic data) {
          final list = data as List<dynamic>;
          return list
              .map((item) => NewModel.fromJson(item as Map<String, Object?>))
              .toList();
        });
      });
    } catch (e) {
      rethrow;
    }
  }

  Future<ApiResponseEntity<List<NewModel>>> getNewsByCategory(
    String category,
    int page,
  ) async {
    try {
      final res = await request(
        ApiMethod.get,
        '/news/$category',
        query: {"page": page.toString()},
      );
      return await parseJson(res, (dynamic json) {
        return ApiResponseEntity.fromJson(json, (dynamic data) {
          final list = data as List<dynamic>;
          return list
              .map((item) => NewModel.fromJson(item as Map<String, Object?>))
              .toList();
        });
      });
    } catch (e) {
      rethrow;
    }
  }

  Future<ApiResponseEntity<NewDetailModel>> getNewsDetail(String link) async {
    try {
      final res = await request(ApiMethod.get, '/news/detail/$link');
      final entity = await parseJson(
        res,
        (dynamic json) => ApiResponseEntity.fromJson(
          json,
          (dynamic data) => NewDetailModel.fromJson(data),
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
