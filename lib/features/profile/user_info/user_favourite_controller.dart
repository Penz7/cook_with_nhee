import 'package:cook_with_nhee/commons/widgets/app/app_toast.dart';
import 'package:cook_with_nhee/controller/auth_controller.dart';
import 'package:cook_with_nhee/network/models/login_model.dart';
import 'package:cook_with_nhee/network/provider/api_client.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class UserFavouriteController extends GetxController {
  UserFavouriteController(this.authController, this.apiClient);

  final AuthController authController;
  final ApiClient apiClient;

  late TextEditingController fullNameController;
  late TextEditingController genderController;
  late TextEditingController dateOfBirthController;
  late TextEditingController hobbiesController;
  late TextEditingController activitiesController;
  late TextEditingController dietTypeController;
  late TextEditingController defaultCuisineController;
  late TextEditingController otherCuisinesController;
  late TextEditingController allergiesController;
  late TextEditingController dislikedIngredientsController;

  final RxBool _isSaving = false.obs;
  bool get isSaving => _isSaving.value;
  bool _initialized = false;
  final RxString _genderDisplay = ''.obs;
  String get genderDisplay => _genderDisplay.value;

  User? get currentUser => authController.currentUser;

  @override
  void onInit() {
    super.onInit();
    _initControllers();
  }

  void _initControllers() {
    final user = currentUser;
    if (!_initialized) {
      fullNameController = TextEditingController(text: user?.fullName ?? '');
      final displayGender = _displayGender(user?.gender);
      _genderDisplay.value = displayGender;
      genderController =
          TextEditingController(text: _apiGender(displayGender) ?? '');
      dateOfBirthController = TextEditingController(
        text: _formatDate(user?.dateOfBirth),
      );
      hobbiesController = TextEditingController(
        text: _joinList(user?.hobbies),
      );
      activitiesController = TextEditingController(
        text: _joinList(user?.favoriteActivities),
      );

      final diet = user?.userDietPreference;
      dietTypeController = TextEditingController(text: diet?.dietType ?? '');
      defaultCuisineController =
          TextEditingController(text: diet?.defaultCuisine ?? '');
      otherCuisinesController =
          TextEditingController(text: _joinList(diet?.otherCuisines));
      allergiesController =
          TextEditingController(text: _joinList(diet?.allergies));
      dislikedIngredientsController =
          TextEditingController(text: _joinList(diet?.dislikedIngredients));
      _initialized = true;
      return;
    }

    fullNameController.text = user?.fullName ?? '';
    final displayGender = _displayGender(user?.gender);
    _genderDisplay.value = displayGender;
    genderController.text = _apiGender(displayGender) ?? '';
    dateOfBirthController.text = _formatDate(user?.dateOfBirth);
    hobbiesController.text = _joinList(user?.hobbies);
    activitiesController.text = _joinList(user?.favoriteActivities);

    final diet = user?.userDietPreference;
    dietTypeController.text = diet?.dietType ?? '';
    defaultCuisineController.text = diet?.defaultCuisine ?? '';
    otherCuisinesController.text = _joinList(diet?.otherCuisines);
    allergiesController.text = _joinList(diet?.allergies);
    dislikedIngredientsController.text = _joinList(diet?.dislikedIngredients);
  }

  String _joinList(List<String>? items) {
    return (items ?? []).join(', ');
  }

  List<String> _splitList(String value) {
    return value
        .split(',')
        .map((e) => e.trim())
        .where((element) => element.isNotEmpty)
        .toList();
  }

  Future<void> saveProfileAndDiet() async {
    if (_isSaving.value) return;
    _isSaving.value = true;
    try {
      final profileRes = await apiClient.updateProfile(
        fullName: _nonEmpty(fullNameController.text),
        gender: _apiGender(_genderDisplay.value),
        dateOfBirth: _nonEmpty(dateOfBirthController.text),
        hobbies: _splitList(hobbiesController.text),
        favoriteActivities: _splitList(activitiesController.text),
      );

      if (!_isSuccess(profileRes.status)) {
        throw Exception(profileRes.message ?? 'Cập nhật hồ sơ thất bại');
      }

      final dietRes = await apiClient.updateDietPreferences(
        dietType: _nonEmpty(dietTypeController.text) ?? '',
        defaultCuisine: _nonEmpty(defaultCuisineController.text) ?? '',
        otherCuisines: _splitList(otherCuisinesController.text),
        allergies: _splitList(allergiesController.text),
        dislikedIngredients: _splitList(dislikedIngredientsController.text),
      );

      if (!_isSuccess(dietRes.status)) {
        throw Exception(dietRes.message ?? 'Cập nhật chế độ ăn thất bại');
      }

      await authController.getMe();
      _initControllers();
      AppToast.success('Thành công', 'Đã cập nhật thông tin cá nhân');
    } catch (e) {
      AppToast.error('Lỗi', e.toString());
    } finally {
      _isSaving.value = false;
    }
  }

  String? _nonEmpty(String? value) {
    final trimmed = value?.trim() ?? '';
    if (trimmed.isEmpty) return null;
    return trimmed;
  }

  bool _isSuccess(int? status) {
    if (status == null) return false;
    return status >= 200 && status < 300;
  }

  String _displayGender(String? raw) {
    if (raw == null || raw.isEmpty) return '';
    final lower = raw.toLowerCase();
    if (lower == 'male') return 'Nam';
    if (lower == 'female') return 'Nữ';
    return raw;
  }

  String? _apiGender(String? display) {
    if (display == null || display.isEmpty) return null;
    final lower = display.toLowerCase();
    if (lower == 'nam') return 'male';
    if (lower == 'nữ' || lower == 'nu') return 'female';
    return _nonEmpty(display);
  }

  void setGenderDisplay(String display) {
    _genderDisplay.value = display;
    genderController.text = _apiGender(display) ?? '';
  }

  String _formatDate(String? raw) {
    if (raw == null || raw.isEmpty) return '';
    try {
      final dt = DateTime.parse(raw).toLocal();
      return DateFormat('dd-MM-yyyy').format(dt);
    } catch (_) {
      return raw;
    }
  }

  @override
  void onClose() {
    fullNameController.dispose();
    genderController.dispose();
    dateOfBirthController.dispose();
    hobbiesController.dispose();
    activitiesController.dispose();
    dietTypeController.dispose();
    defaultCuisineController.dispose();
    otherCuisinesController.dispose();
    allergiesController.dispose();
    dislikedIngredientsController.dispose();
    super.onClose();
  }
}

class UserFavouriteBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(
      () => UserFavouriteController(
        Get.find<AuthController>(),
        Get.find<ApiClient>(),
      ),
    );
  }
}

