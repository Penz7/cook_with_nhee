import 'dart:convert';
import 'package:cook_with_nhee/network/models/login_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import '../commons/routes/route.dart';
import '../network/constants/storage_key.dart';
import '../network/jwt.dart';
import '../network/provider/api_client.dart';
import '../network/services/storage_service.dart';

class AuthController extends GetxController {
  final ApiClient _apiClient;
  final StorageService _storageService;
  AuthController(this._apiClient, this._storageService);

  bool get isAuth => _currentUser.value != null;
  final RxBool isUserDev = false.obs;
  Stream<User?> get currentUserStream => _currentUser.stream;

  final _enableRemember = false.obs;
  bool get enableRemember => _enableRemember.value;

  final _currentUser = Rx<User?>(null);
  User? get currentUser => _currentUser.value;

  Future<AuthController> init() async {
    try {
      final userJson = await _storageService.get(StorageKey.user);
      if (userJson != null) {
        try {
          final userMap = jsonDecode(userJson);
          _currentUser.value = User.fromJson(userMap);
          print('User loaded from StorageService: ${_currentUser.value}');
        } catch (e) {
          print('Error parsing user from storage: $e');
        }
      }

      final token = await _storageService.get(StorageKey.token);
      if (token != null && !Jwt.isExpired(token)) {
        try {
          await getMe();
        } catch (e) {
          print('Error syncing user data from server: $e');
        }
      }

      final rememberMe = await _storageService.get(StorageKey.rememberMe);
      _enableRemember.value = rememberMe == 'true';
    } catch (e) {
      print(e);
      // Clear corrupted user data
      await _storageService.delete(StorageKey.user);
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
      await Get.offAllNamed(Routes.login.p);
    } catch (e) {
      debugPrint("Error during logout: $e");
    }
  }

  Future<bool> login(String email, String password) async {
    try {
      final res = await _apiClient.login(email, password);
      if (res.status == 200 && res.data != null) {
        final user = User(
          id: res.data?.user?.id,
          email: res.data?.user?.email,
        );

        if (enableRemember) {
          await saveCredentials(email, password);
        }

        await _loginUser(user, res.data?.accessToken ?? '');
        return true;
      } else {
        debugPrint(res.message);
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
        final apiUser = response.data;
        final updatedUser = User(
          id: apiUser?.id,
          name: apiUser?.name,
          phone: apiUser?.phone,
          hobby: apiUser?.hobby,
          role: apiUser?.role,
          recipeQuantity: apiUser?.recipeQuantity,
          createdAt: apiUser?.createdAt,
          avatar: apiUser?.avatar,
          email: apiUser?.email,
        );

        // Lưu vào StorageService
        await _storageService.set(StorageKey.user, jsonEncode(updatedUser.toJson()));
        _currentUser.value = updatedUser;
        return updatedUser;
      }
      return _currentUser.value;
    } catch (e) {
      print('Error in getMe: $e');
      return _currentUser.value;
    }
  }

  Future _loginUser(User user, String token) async {
    try {
      await _storageService.set(StorageKey.user, jsonEncode(user.toJson()));
      _currentUser.value = user;
      await _storageService.set(StorageKey.token, token);
      await getMe();
      debugPrint('Logging in user: ${user.id}');
    } catch (e) {
      debugPrint("Error during user login: $e");
      await _storageService.set(StorageKey.user, jsonEncode(user.toJson()));
      _currentUser.value = user;
      await _storageService.set(StorageKey.token, token);
      await getMe();
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

  Future<bool> checkAuth() async {
    final token = await _storageService.get(StorageKey.token);
    if (token != null) {
      final isExpired = Jwt.isExpired(token);
      final payload = Jwt.parseJwtPayLoad(token);
      if (isExpired || payload['id'] != currentUser?.id) {
        await _storageService.delete(StorageKey.token);
        return false;
      }
      return true;
    }
    return false;
  }
}
