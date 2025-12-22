import 'dart:convert';
import 'package:cook_with_nhee/network/models/login_model.dart';
import 'package:cook_with_nhee/network/models/user_measurement_model.dart';
import 'package:cook_with_nhee/network/models/user_diet_preference_model.dart';
import 'package:cook_with_nhee/network/models/healthy_advice_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import '../commons/routes/route.dart';
import '../commons/widgets/app/app_toast.dart';
import '../network/constants/storage_key.dart';
import '../network/jwt.dart';
import '../network/models/recipe_model.dart';
import '../network/provider/api_client.dart';
import '../network/services/storage_service.dart';

class AuthController extends GetxController {
  final ApiClient _apiClient;
  final StorageService _storageService;
  final RxMap<String, bool> savingRecipes = <String, bool>{}.obs;
  final RxSet<String> savedRecipes = <String>{}.obs;

  AuthController(this._apiClient, this._storageService);


  bool get isAuth => _currentUser.value != null;
  final RxBool isUserDev = false.obs;
  Stream<User?> get currentUserStream => _currentUser.stream;

  final _enableRemember = false.obs;
  bool get enableRemember => _enableRemember.value;

  final _currentUser = Rx<User?>(null);
  User? get currentUser => _currentUser.value;

  final _healthyAdvice = Rx<HealthyAdviceModel?>(null);
  HealthyAdviceModel? get healthyAdvice => _healthyAdvice.value;

  Future<AuthController> init() async {
    try {
      final rememberMe = await _storageService.get(StorageKey.rememberMe);
      _enableRemember.value = rememberMe == 'true';
      final userJson = await _storageService.get(StorageKey.user);
      if (userJson != null) {
        try {
          final userMap = jsonDecode(userJson);
          _currentUser.value = User.fromJson(userMap);
          debugPrint('User loaded from StorageService');
        } catch (e) {
          debugPrint('Error parsing user from storage: $e');
          await _storageService.delete(StorageKey.user);
        }
      }

      final token = await _storageService.get(StorageKey.token);
      if (token != null) {
        try {
          final isExpired = Jwt.isExpired(token);
          if (isExpired) {
            debugPrint('Token expired, clearing auth data');
            _currentUser.value = null;
            await _storageService.delete(StorageKey.token);
            await _storageService.delete(StorageKey.user);
            return this;
          }

          final payload = Jwt.parseJwtPayLoad(token);
          final tokenUserId = payload['sub'] ?? payload['id'];
          
          if (tokenUserId == null) {
            debugPrint('Token does not contain user ID, clearing auth data');
            _currentUser.value = null;
            await _storageService.delete(StorageKey.token);
            await _storageService.delete(StorageKey.user);
            return this;
          }

          final currentUserId = _currentUser.value?.id;
          if (currentUserId != null && tokenUserId != currentUserId) {
            debugPrint('Token user ID mismatch: token=$tokenUserId, current=$currentUserId');
            _currentUser.value = null;
            await _storageService.delete(StorageKey.token);
            await _storageService.delete(StorageKey.user);
            return this;
          }

          try {
            await getMe();
            debugPrint('User data synced from server successfully');
          } catch (e) {
            debugPrint('Error syncing user data from server: $e');
            if (_currentUser.value == null) {
              debugPrint('No user data available, clearing token');
              await _storageService.delete(StorageKey.token);
            } else {
              debugPrint('Keeping user from storage despite sync failure');
            }
          }
        } catch (e) {
          debugPrint('Error validating token: $e');
          _currentUser.value = null;
          await _storageService.delete(StorageKey.token);
          await _storageService.delete(StorageKey.user);
        }
      } else {
        if (_currentUser.value != null) {
          debugPrint('No token but user exists in storage, clearing user');
          _currentUser.value = null;
          await _storageService.delete(StorageKey.user);
        }
      }
    } catch (e) {
      debugPrint('Error in AuthController.init: $e');
      await _storageService.delete(StorageKey.user);
      await _storageService.delete(StorageKey.token);
      _currentUser.value = null;
    }
    return this;
  }

  Future<void> logout() async {
    try {
      _currentUser.value = null;
      await _storageService.delete(StorageKey.token);
      await _storageService.delete(StorageKey.user);
      await clearSavedCredentials();
      _currentUser.refresh();
      await Get.offAllNamed(Routes.auth.p);
    } catch (e) {
      debugPrint("Error during logout: $e");
    }
  }

  Future<bool> login(String email, String password) async {
    try {
      final res = await _apiClient.login(email, password);
      if (res.status == 200 && res.data != null) {
        final loginData = res.data!;
        final accessToken = loginData.accessToken ?? '';
        final user = loginData.user;

        if (user == null) {
          debugPrint('Login response missing user data');
          return false;
        }

        if (enableRemember) {
          await saveCredentials(email, password);
        }

        await _loginUser(user, accessToken);
        return true;
      } else {
        debugPrint(res.message ?? 'Login failed');
        return false;
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> register(String email, String password, String fullName) async {
    try {
      final res = await _apiClient.register(email, password, fullName);
      if (res.status == 201 && res.data != null) {
        final registerData = res.data!;
        final accessToken = registerData.accessToken ?? '';
        final user = registerData.user;

        if (user == null) {
          debugPrint('Register response missing user data');
          return false;
        }

        await _loginUser(user, accessToken);
        return true;
      } else {
        debugPrint(res.message ?? 'Register failed');
        return false;
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<User?> getMe() async {
    try {
      final response = await _apiClient.getMe();
      if (response.status == 200 && response.data != null) {
        final apiUser = response.data!;
        UserMeasurementModel? userMeasurement;
        UserDietPreferenceModel? userDietPreference;
        
        try {
          final measurementResponse = await _apiClient.getMeasurements();
          if (measurementResponse.status == 200 && measurementResponse.data != null) {
            userMeasurement = measurementResponse.data!;
          }
        } catch (e) {
          debugPrint('Error fetching user measurement: $e');
        }
        
        try {
          final dietPreferenceResponse = await _apiClient.getDietPreference();
          if (dietPreferenceResponse.status == 200 && dietPreferenceResponse.data != null) {
            userDietPreference = dietPreferenceResponse.data!;
          }
        } catch (e) {
          debugPrint('Error fetching user diet preference: $e');
        }

        final updatedUser = apiUser.copyWith(
          userMeasurement: userMeasurement,
          userDietPreference: userDietPreference,
        );

        if (userMeasurement?.bmi != null && userMeasurement!.bmi! > 0) {
          try {
            final healthyAdviceResponse = await _apiClient.getHealthyAdvice(
              userMeasurement.bmi!.toDouble(),
            );
            final statusCode = healthyAdviceResponse.status;
            if (statusCode != null &&
                statusCode >= 200 &&
                statusCode < 300 &&
                healthyAdviceResponse.data != null) {
              _healthyAdvice.value = healthyAdviceResponse.data!;
              debugPrint('Healthy advice fetched successfully');
            }
          } catch (e) {
            debugPrint('Error fetching healthy advice: $e');
          }
        }

        await _storageService.set(StorageKey.user, jsonEncode(updatedUser.toJson()));
        _currentUser.value = updatedUser;
        return updatedUser;
      }
      return _currentUser.value;
    } catch (e) {
      debugPrint('Error in getMe: $e');
      return _currentUser.value;
    }
  }

  Future _loginUser(User user, String token) async {
    try {
      await _storageService.set(StorageKey.user, jsonEncode(user.toJson()));
      _currentUser.value = user;
      await _storageService.set(StorageKey.token, token);
      debugPrint('User and token saved from login response: ${user.id}');
      try {
        await getMe();
        debugPrint('User data synced from server successfully');
      } catch (e) {
        debugPrint("Error syncing user data from server (keeping login data): $e");
      }
    } catch (e) {
      debugPrint("Error during user login: $e");
      rethrow;
    }
  }

  Future<void> toggleRememberMe() async {
    final newValue = !enableRemember;
    await _storageService.set(StorageKey.rememberMe, newValue ? 'true' : 'false');
    _enableRemember.value = newValue;

    if (!newValue) {
      await clearSavedCredentials();
    }
  }

  Future<void> saveCredentials(String email, String password) async {
    if (enableRemember) {
      await _storageService.set(StorageKey.savedEmail, email);
      await _storageService.set(StorageKey.savedPassword, password);
    }
  }

  Future<void> clearSavedCredentials() async {
    await _storageService.delete(StorageKey.savedEmail);
    await _storageService.delete(StorageKey.savedPassword);
  }

  Future<String?> getSavedEmail() async {
    if (enableRemember) {
      return await _storageService.get(StorageKey.savedEmail);
    }
    return null;
  }

  Future<String?> getSavedPassword() async {
    if (enableRemember) {
      return await _storageService.get(StorageKey.savedPassword);
    }
    return null;
  }

  /// Fetch healthy advice dựa trên BMI hiện tại
  Future<void> fetchHealthyAdvice() async {
    final user = currentUser;
    if (user?.userMeasurement?.bmi != null && user!.userMeasurement!.bmi! > 0) {
      try {
        final response = await _apiClient.getHealthyAdvice(
          user.userMeasurement!.bmi!.toDouble(),
        );
        final statusCode = response.status;
        if (statusCode != null &&
            statusCode >= 200 &&
            statusCode < 300 &&
            response.data != null) {
          _healthyAdvice.value = response.data!;
          debugPrint('Healthy advice fetched successfully');
        }
      } catch (e) {
        debugPrint('Error fetching healthy advice: $e');
      }
    }
  }

  Future<bool> checkAuth() async {
    final token = await _storageService.get(StorageKey.token);
    if (token == null) {
      return false;
    }

    try {
      final isExpired = Jwt.isExpired(token);
      if (isExpired) {
        debugPrint('Token expired');
        await _storageService.delete(StorageKey.token);
        await _storageService.delete(StorageKey.user);
        _currentUser.value = null;
        return false;
      }

      final payload = Jwt.parseJwtPayLoad(token);
      // JWT token có 'sub' chứa user ID, không phải 'id'
      final tokenUserId = payload['sub'] ?? payload['id'];
      
      if (tokenUserId == null) {
        debugPrint('Token does not contain user ID');
        await _storageService.delete(StorageKey.token);
        await _storageService.delete(StorageKey.user);
        _currentUser.value = null;
        return false;
      }

      // Nếu có currentUser, validate user ID match
      final currentUserId = currentUser?.id;
      if (currentUserId != null && tokenUserId != currentUserId) {
        debugPrint('Token user ID mismatch: token=$tokenUserId, current=$currentUserId');
        await _storageService.delete(StorageKey.token);
        await _storageService.delete(StorageKey.user);
        _currentUser.value = null;
        return false;
      }

      // Token hợp lệ (có thể chưa có user trong memory, nhưng token vẫn hợp lệ)
      return true;
    } catch (e) {
      debugPrint('Error checking auth: $e');
      await _storageService.delete(StorageKey.token);
      await _storageService.delete(StorageKey.user);
      _currentUser.value = null;
      return false;
    }
  }

  Future<void> loadSavedRecipes() async {
    try {
      final response = await _apiClient.getMyRecipes();
      final data = response.data;
      if ((response.status == 200 || response.status == 201) && data != null) {
        savedRecipes
          ..clear()
          ..addAll(
            data.map((item) => item.name).whereType<String>(),
          );
      }
    } catch (e) {
      debugPrint('Lỗi tải công thức đã lưu: $e');
    }
  }

  Future<void> saveRecipe(RecipeModel recipe) async {
    final recipeKey = recipe.name ?? '';
    if (recipeKey.isEmpty) return;

    try {
      savingRecipes[recipeKey] = true;
      final response = await _apiClient.saveRecipe(recipe);
      if (response.status == 200 || response.status == 201) {
        savedRecipes.add(recipeKey);
        AppToast.success(
          'Thành công',
          'Đã lưu công thức "${recipe.name}" vào danh sách của bạn',
        );
      }
    } catch (e) {
      debugPrint('Lỗi lưu recipe: $e');
      AppToast.error(
        'Lỗi',
        'Không thể lưu công thức. Vui lòng thử lại.',
      );
    } finally {
      savingRecipes[recipeKey] = false;
    }
  }

  bool isSavingRecipe(RecipeModel recipe) {
    final recipeKey = recipe.name ?? '';
    return savingRecipes[recipeKey] ?? false;
  }

  bool isRecipeSaved(RecipeModel recipe) {
    final recipeKey = recipe.name ?? '';
    return savedRecipes.contains(recipeKey);
  }
}
