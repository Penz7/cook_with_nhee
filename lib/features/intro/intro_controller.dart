import 'package:cook_with_nhee/commons/routes/route.dart';
import 'package:cook_with_nhee/commons/widgets/app/app_toast.dart';
import 'package:cook_with_nhee/controller/auth_controller.dart';
import 'package:cook_with_nhee/network/constants/storage_key.dart';
import 'package:cook_with_nhee/network/provider/api_client.dart';
import 'package:cook_with_nhee/network/services/storage_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class IntroController extends GetxController {
  final AuthController authController;
  final ApiClient apiClient;
  final StorageService storageService;

  IntroController(this.authController, this.apiClient, this.storageService);

  late final PageController pageController;
  final currentStep = 0.obs;
  final totalSteps = 3;

  @override
  void onInit() {
    super.onInit();
    pageController = PageController(initialPage: 0);
    
    // Add listeners to update UI when user inputs data
    weightController.addListener(_onBodyStatsChanged);
    heightController.addListener(_onBodyStatsChanged);
    chestController.addListener(_onBodyStatsChanged);
    waistController.addListener(_onBodyStatsChanged);
    hipController.addListener(_onBodyStatsChanged);
    customGoal.addListener(_onGoalChanged);
  }
  
  void _onBodyStatsChanged() {
    // Trigger UI update khi body stats thay đổi
    bodyStatsChanged.value++;
    // Validate các field khi thay đổi
    _validateHeight();
    _validateWeight();
    _validateChest();
    _validateWaist();
    _validateHip();
  }
  
  void _validateHeight() {
    final value = heightController.text.trim();
    if (value.isEmpty) {
      heightError.value = null;
      return;
    }
    final height = int.tryParse(value);
    if (height == null) {
      heightError.value = 'Please enter a valid number';
    } else if (height < 50) {
      heightError.value = 'Height must be at least 50cm';
    } else if (height > 250) {
      heightError.value = 'Height cannot exceed 250cm (2.5m)';
    } else {
      heightError.value = null;
    }
  }
  
  void _validateWeight() {
    final value = weightController.text.trim();
    if (value.isEmpty) {
      weightError.value = null;
      return;
    }
    final weight = int.tryParse(value);
    if (weight == null) {
      weightError.value = 'Vui lòng nhập số hợp lệ';
    } else if (weight < 20) {
      weightError.value = 'Weight must be at least 20kg';
    } else if (weight > 300) {
      weightError.value = 'Weight cannot exceed 300kg';
    } else {
      weightError.value = null;
    }
  }
  
  void _validateChest() {
    final value = chestController.text.trim();
    if (value.isEmpty) {
      chestError.value = null;
      return;
    }
    final chest = int.tryParse(value);
    if (chest == null) {
      chestError.value = 'Vui lòng nhập số hợp lệ';
    } else if (chest < 50) {
      chestError.value = 'Chest must be at least 50cm';
    } else if (chest > 200) {
      chestError.value = 'Chest cannot exceed 200cm';
    } else {
      chestError.value = null;
    }
  }
  
  void _validateWaist() {
    final value = waistController.text.trim();
    if (value.isEmpty) {
      waistError.value = null;
      return;
    }
    final waist = int.tryParse(value);
    if (waist == null) {
      waistError.value = 'Vui lòng nhập số hợp lệ';
    } else if (waist < 30) {
      waistError.value = 'Waist must be at least 30cm';
    } else if (waist > 200) {
      waistError.value = 'Waist cannot exceed 200cm';
    } else {
      waistError.value = null;
    }
  }
  
  void _validateHip() {
    final value = hipController.text.trim();
    if (value.isEmpty) {
      hipError.value = null;
      return;
    }
    final hip = int.tryParse(value);
    if (hip == null) {
      hipError.value = 'Vui lòng nhập số hợp lệ';
    } else if (hip < 50) {
      hipError.value = 'Hip must be at least 50cm';
    } else if (hip > 200) {
      hipError.value = 'Hip cannot exceed 200cm';
    } else {
      hipError.value = null;
    }
  }
  
  void _onGoalChanged() {
    // Trigger UI update khi goal thay đổi
    goalChanged.value++;
  }

  final RxnString selectedGoal = RxnString('');
  final customGoal = TextEditingController();
  final heightController = TextEditingController();
  final weightController = TextEditingController();
  final chestController = TextEditingController();
  final waistController = TextEditingController();
  final hipController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  
  // Error messages for AppTextField
  final heightError = RxnString(null);
  final weightError = RxnString(null);
  final chestError = RxnString(null);
  final waistError = RxnString(null);
  final hipError = RxnString(null);
  final selectedPreferences = <String>[].obs;
  final isLoading = false.obs;
  
  // Observable để trigger UI update khi body stats thay đổi
  final bodyStatsChanged = 0.obs;
  // Observable để trigger UI update khi goal thay đổi
  final goalChanged = 0.obs;

  // Diet preferences state
  final RxnString selectedDietType = RxnString(null);
  final RxnString selectedDefaultCuisine = RxnString(null);
  final selectedOtherCuisines = <String>[].obs;
  final selectedAllergies = <String>[].obs;
  final dislikedIngredientsController = TextEditingController();

  static const List<String> goals = ['Giảm cân', 'Tăng cơ', 'Duy trì'];

  static const List<String> foodPreferences = [
    'Vegan',
    'Keto',
    'Paleo',
    'No Nuts',
    'Gluten Free',
    'None',
  ];

  // Diet types
  static const List<String> dietTypes = [
    'vegetarian',
    'vegan',
    'omnivore',
    'pescatarian',
    'keto',
    'paleo',
  ];

  // Cuisines
  static const List<String> cuisines = [
    'vietnamese',
    'japanese',
    'korean',
    'chinese',
    'thai',
    'italian',
    'french',
    'indian',
    'mexican',
    'american',
  ];

  // Common allergies
  static const List<String> commonAllergies = [
    'shrimp',
    'crab',
    'lobster',
    'fish',
    'egg',
    'milk',
    'peanut',
    'tree-nut',
    'soy',
    'wheat',
    'sesame',
  ];

  void selectGoal(String goal) {
    selectedGoal.value = goal;
    customGoal.clear();
  }

  void setCustomGoal(String goal) {
    selectedGoal.value = null;
    customGoal.text = goal;
  }

  String? get finalGoal {
    if (selectedGoal.value != null && selectedGoal.value!.isNotEmpty) {
      return selectedGoal.value;
    }
    return customGoal.text.trim().isNotEmpty ? customGoal.text.trim() : null;
  }

  void toggleFoodPreference(String preference) {
    if (preference == 'None') {

      selectedPreferences.clear();
      selectedPreferences.add('None');
      } else {
      // Remove "None" if exists
      selectedPreferences.remove('None');
      if (selectedPreferences.contains(preference)) {
        selectedPreferences.remove(preference);
      } else {
        selectedPreferences.add(preference);
      }
    }
  }

  bool isPreferenceSelected(String preference) {
    return selectedPreferences.contains(preference);
  }

  void nextStep() {
    if (!canGoToNextStep()) {
      return;
    }
    
    if (currentStep.value < totalSteps - 1) {
      pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      completeIntro();
    }
  }

  void previousStep() {
    if (currentStep.value > 0) {
      pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void onPageChanged(int index) {
    currentStep.value = index;
  }

  double get progress => (currentStep.value + 1) / totalSteps;
  
  String get stepText => '${currentStep.value + 1}/$totalSteps';

  bool canGoToNextStep() {
    switch (currentStep.value) {
      case 0:
        // Page 1: Goal Selection - must select or enter goal
        // Đọc selectedGoal và goalChanged để trigger reactive update
        selectedGoal.value;
        goalChanged.value;
        return finalGoal != null && finalGoal!.isNotEmpty;
      case 1:
        // Page 2: Body Stats - must enter weight and height (required)
        // Đọc bodyStatsChanged để trigger reactive update
        bodyStatsChanged.value;
        
        final weight = weightController.text.trim();
        final height = heightController.text.trim();
        
        // Check that weight and height are not empty
        if (weight.isEmpty || height.isEmpty) {
          return false;
        }
        
        // Kiểm tra weight và height phải là số hợp lệ
        final weightValue = int.tryParse(weight);
        final heightValue = int.tryParse(height);
        
        if (weightValue == null || heightValue == null) {
          return false;
        }
        
        // Kiểm tra giá trị trong phạm vi hợp lý
        if (weightValue < 20 || weightValue > 300) {
          return false;
        }
        if (heightValue < 50 || heightValue > 250) {
          return false;
        }
        
        // Kiểm tra error state thay vì gọi formKey.validate() để tránh setState trong build
        // Nếu có error thì không cho phép next
        if (heightError.value != null || 
            weightError.value != null || 
            chestError.value != null || 
            waistError.value != null || 
            hipError.value != null) {
          return false;
        }
        
        return true;
      case 2:
        // Page 3: Food Preferences - phải chọn diet type và default cuisine
        return selectedDietType.value != null &&
            selectedDietType.value!.isNotEmpty &&
            selectedDefaultCuisine.value != null &&
            selectedDefaultCuisine.value!.isNotEmpty;
      default:
        return false;
    }
  }

  // Diet preferences methods
  void selectDietType(String dietType) {
    selectedDietType.value = dietType;
  }

  void selectDefaultCuisine(String cuisine) {
    selectedDefaultCuisine.value = cuisine;
  }

  void toggleOtherCuisine(String cuisine) {
    if (selectedOtherCuisines.contains(cuisine)) {
      selectedOtherCuisines.remove(cuisine);
    } else {
      selectedOtherCuisines.add(cuisine);
    }
  }

  bool isOtherCuisineSelected(String cuisine) {
    return selectedOtherCuisines.contains(cuisine);
  }

  void toggleAllergy(String allergy) {
    if (selectedAllergies.contains(allergy)) {
      selectedAllergies.remove(allergy);
    } else {
      selectedAllergies.add(allergy);
    }
  }

  bool isAllergySelected(String allergy) {
    return selectedAllergies.contains(allergy);
  }

  Future<void> completeIntro() async {
    if (finalGoal == null || finalGoal!.isEmpty) {
      AppToast.error('Lỗi', 'Vui lòng chọn hoặc nhập mục tiêu của bạn');
      return;
    }

    if (selectedDietType.value == null || selectedDietType.value!.isEmpty) {
      AppToast.error('Lỗi', 'Vui lòng chọn loại chế độ ăn');
      return;
    }

    if (selectedDefaultCuisine.value == null ||
        selectedDefaultCuisine.value!.isEmpty) {
      AppToast.error('Lỗi', 'Vui lòng chọn món ăn mặc định');
      return;
    }

    // Validate error state before submitting
    // Kiểm tra xem có error nào không
    if (heightError.value != null || 
        weightError.value != null || 
        chestError.value != null || 
        waistError.value != null || 
        hipError.value != null) {
      AppToast.error('Error', 'Vui lòng kiểm tra lại thông tin đã nhập');
      return;
    }

    try {
      isLoading.value = true;

      // Parse body measurements
      final weight = int.tryParse(weightController.text.trim());
      final height = int.tryParse(heightController.text.trim());
      final chest = int.tryParse(chestController.text.trim());
      final waist = int.tryParse(waistController.text.trim());
      final hip = int.tryParse(hipController.text.trim());

      if (weight == null || height == null) {
        AppToast.error('Error', 'Please enter weight and height');
        return;
      }

      // Parse disliked ingredients from text field (split by comma)
      final dislikedIngredientsText = dislikedIngredientsController.text.trim();
      final dislikedIngredients = dislikedIngredientsText.isNotEmpty
          ? dislikedIngredientsText
              .split(',')
              .map((e) => e.trim())
              .where((e) => e.isNotEmpty)
              .toList()
          : <String>[];

      final measurementResponse = await apiClient.updateMeasurement(
        weight: weight,
        height: height,
        chest: chest,
        waist: waist,
        hip: hip,
        healthyGoal: finalGoal,
      );

      if (measurementResponse.status != 200 &&
          measurementResponse.status != 201) {
        throw Exception(
            measurementResponse.message ?? 'Failed to update body measurements');
      }

      // Call API to update diet preferences
      final dietResponse = await apiClient.updateDietPreferences(
        dietType: selectedDietType.value!,
        defaultCuisine: selectedDefaultCuisine.value!,
        otherCuisines: selectedOtherCuisines.toList(),
        allergies: selectedAllergies.toList(),
        dislikedIngredients: dislikedIngredients,
      );

      if (dietResponse.status != 200 && dietResponse.status != 201) {
        throw Exception(
            dietResponse.message ?? 'Failed to update diet preferences');
      }

      await authController.getMe();
      await storageService.set(StorageKey.introCompleted, 'true');
      Get.offAllNamed(Routes.home.p);
      AppToast.success('Thành công', 'Thiết lập hoàn tất!');
    } catch (e) {
      debugPrint('Error completing intro: $e');
      AppToast.error('Lỗi', 'Không thể hoàn tất thiết lập: ${e.toString()}');
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    // Remove listeners
    weightController.removeListener(_onBodyStatsChanged);
    heightController.removeListener(_onBodyStatsChanged);
    chestController.removeListener(_onBodyStatsChanged);
    waistController.removeListener(_onBodyStatsChanged);
    hipController.removeListener(_onBodyStatsChanged);
    customGoal.removeListener(_onGoalChanged);
    
    pageController.dispose();
    customGoal.dispose();
    heightController.dispose();
    weightController.dispose();
    chestController.dispose();
    waistController.dispose();
    hipController.dispose();
    dislikedIngredientsController.dispose();
    super.onClose();
  }
}
