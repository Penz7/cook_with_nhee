import 'dart:io';
import 'package:cook_with_nhee/commons/widgets/app/app_image.dart';
import 'package:cook_with_nhee/commons/widgets/app/app_toast.dart';
import 'package:cook_with_nhee/controller/auth_controller.dart';
import 'package:flutter/foundation.dart';
import 'package:cook_with_nhee/network/models/login_model.dart';
import 'package:cook_with_nhee/network/provider/api_client.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class ProfileController extends GetxController {
  final AuthController authController;
  final ApiClient apiClient;

  ProfileController(this.authController, this.apiClient);

  final _isEditMode = false.obs;
  bool get isEditMode => _isEditMode.value;

  late TextEditingController nameController;
  late TextEditingController phoneController;
  late TextEditingController hobbyController;
  late TextEditingController emailController;
  final _isLoading = false.obs;
  bool get isLoading => _isLoading.value;
  final _isUploadingAvatar = false.obs;
  bool get isUploadingAvatar => _isUploadingAvatar.value;
  final _selectedImageFile = Rx<File?>(null);
  File? get selectedImageFile => _selectedImageFile.value;
  final _selectedImageBytes = Rx<Uint8List?>(null);
  Uint8List? get selectedImageBytes => _selectedImageBytes.value;
  final _selectedImagePath = Rx<String?>(null);
  String? get _currentImagePath =>
      _selectedImageFile.value?.path ?? _selectedImagePath.value;
  User? get currentUser => authController.currentUser;

  @override
  void onInit() {
    super.onInit();
    _initializeControllers();
  }

  void _initializeControllers() {
    final user = currentUser;
    nameController = TextEditingController(text: user?.name ?? '');
    phoneController = TextEditingController(text: user?.phone ?? '');
    hobbyController = TextEditingController(text: user?.hobby ?? '');
    emailController = TextEditingController(text: user?.email ?? '');
  }

  @override
  void onClose() {
    nameController.dispose();
    phoneController.dispose();
    hobbyController.dispose();
    emailController.dispose();
    super.onClose();
  }

  void toggleEditMode() {
    _isEditMode.value = !_isEditMode.value;
    if (!_isEditMode.value) {
      _initializeControllers();
      _selectedImageFile.value = null;
    }
  }

  void clearSelectedImage() {
    _selectedImageFile.value = null;
    _selectedImageBytes.value = null;
    _selectedImagePath.value = null;
  }

  Future<void> pickImageFromGallery() async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
        maxWidth: 1024,
        maxHeight: 1024,
      );

      if (image != null) {
        if (kIsWeb) {
          _selectedImageBytes.value = await image.readAsBytes();
          _selectedImagePath.value = image.path;
          _selectedImageFile.value = null;
        } else {
          _selectedImageFile.value = File(image.path);
          _selectedImageBytes.value = null;
          _selectedImagePath.value = image.path;
        }
      }
    } catch (e) {
      AppToast.error(
        'Lỗi',
        'Không thể chọn ảnh từ thư viện: ${e.toString()}',
      );
    }
  }

  Future<void> takePhoto() async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 80,
        maxWidth: 1024,
        maxHeight: 1024,
      );

      if (image != null) {
        if (kIsWeb) {
          _selectedImageBytes.value = await image.readAsBytes();
          _selectedImagePath.value = image.path;
          _selectedImageFile.value = null;
        } else {
          _selectedImageFile.value = File(image.path);
          _selectedImageBytes.value = null;
          _selectedImagePath.value = image.path;
        }
      }
    } catch (e) {
      AppToast.error(
        'Lỗi',
        'Không thể chụp ảnh: ${e.toString()}',
      );
    }
  }

  Future<void> confirmUploadAvatar() async {
    if (_selectedImageFile.value == null && _selectedImageBytes.value == null) {
      return;
    }

    await Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: const Text('Cập nhật avatar'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ClipOval(
              child: Builder(
                builder: (context) {
                  if (kIsWeb && _selectedImageBytes.value != null) {
                    return Image.memory(
                      _selectedImageBytes.value!,
                      width: 120,
                      height: 120,
                      fit: BoxFit.cover,
                    );
                  }
                  if (_selectedImageFile.value != null) {
                    return AppImage.file(
                      file: _selectedImageFile.value!,
                      width: 120,
                      height: 120,
                    );
                  }
                  return const SizedBox(width: 120, height: 120);
                },
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Bạn có chắc muốn dùng ảnh này làm avatar mới?',
              textAlign: TextAlign.center,
            ),
          ],
        ),
        actions: [
          Obx(
            () => TextButton(
              onPressed: isUploadingAvatar
                  ? null
                  : () {
                      clearSelectedImage();
                      Get.back();
                    },
              child: const Text('Hủy'),
            ),
          ),
          Obx(
            () => ElevatedButton(
              onPressed: isUploadingAvatar
                  ? null
                  : () async {
                      final success = await uploadAvatar();
                      if (success) {
                        Get.back();
                        AppToast.success(
                          'Thành công',
                          'Cập nhật avatar thành công',
                        );
                      }
                    },
              child: isUploadingAvatar
                  ? const SizedBox(
                      height: 18,
                      width: 18,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          Colors.white,
                        ),
                      ),
                    )
                  : const Text('Cập nhật'),
            ),
          ),
        ],
      ),
      barrierDismissible: !isUploadingAvatar,
    );
  }

  Future<void> showImagePickerOptions() async {
    Get.bottomSheet(
      Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.photo_library, color: Colors.pink),
                title: const Text('Chọn từ thư viện'),
                onTap: () async {
                  Get.back();
                  await pickImageFromGallery();
                  if (_selectedImageFile.value != null ||
                      _selectedImageBytes.value != null) {
                    await confirmUploadAvatar();
                  }
                },
              ),
              ListTile(
                leading: const Icon(Icons.camera_alt, color: Colors.pink),
                title: const Text('Chụp ảnh'),
                onTap: () async {
                  Get.back();
                  await takePhoto();
                  if (_selectedImageFile.value != null ||
                      _selectedImageBytes.value != null) {
                    await confirmUploadAvatar();
                  }
                },
              ),
              ListTile(
                leading: const Icon(Icons.cancel, color: Colors.grey),
                title: const Text('Hủy'),
                onTap: () => Get.back(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<bool> uploadAvatar() async {
    try {
      _isUploadingAvatar.value = true;
      List<int>? bytes;
      String? fileName = _currentImagePath?.split('/').last;

      if (kIsWeb) {
        if (_selectedImageBytes.value == null) {
          throw Exception('Không tìm thấy dữ liệu ảnh để upload');
        }
        bytes = _selectedImageBytes.value!;
        fileName ??= 'avatar_web.jpg';
      } else {
        final filePath = _currentImagePath;
        if (filePath == null) {
          throw Exception('Không tìm thấy đường dẫn ảnh để upload');
        }
        final file = File(filePath);
        bytes = await file.readAsBytes();
        fileName ??= file.uri.pathSegments.isNotEmpty
            ? file.uri.pathSegments.last
            : 'avatar.jpg';
      }

      final response = await apiClient.uploadAvatar(
        bytes: bytes,
        fileName: fileName,
      );
      
      if (response.status == 200 && response.data != null) {
        await authController.getMe();
        clearSelectedImage();
        return true;
      } else {
        AppToast.error(
          'Lỗi',
          response.message ?? 'Cập nhật avatar thất bại',
        );
        return false;
      }
    } catch (e) {
      AppToast.error(
        'Lỗi',
        'Không thể cập nhật avatar: ${e.toString()}',
      );
      return false;
    } finally {
      _isUploadingAvatar.value = false;
    }
  }

  Future<void> saveProfile() async {
    try {
      _isLoading.value = true;
      final response = await apiClient.updateProfile(
        name: nameController.text.trim().isEmpty ? null : nameController.text.trim(),
        phone: phoneController.text.trim().isEmpty ? null : phoneController.text.trim(),
        hobby: hobbyController.text.trim().isEmpty ? null : hobbyController.text.trim(),
      );

      if (response.status == 200 && response.data != null) {
        await authController.getMe();
        _isEditMode.value = false;
        AppToast.success(
          'Thành công',
          'Cập nhật thông tin thành công',
        );
      } else {
        throw Exception(response.message ?? 'Cập nhật thông tin thất bại');
      }
    } catch (e) {
      AppToast.error(
        'Lỗi',
        'Không thể cập nhật thông tin: ${e.toString()}',
      );
    } finally {
      _isLoading.value = false;
    }
  }
}
