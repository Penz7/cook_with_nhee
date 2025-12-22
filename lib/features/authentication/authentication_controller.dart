import 'dart:async';
import 'package:cook_with_nhee/commons/widgets/app/app_toast.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AuthenticationController extends GetxController {
  final PageController pageController = PageController(initialPage: 1000);
  final RxInt currentPageIndex = 0.obs;
  Timer? _autoSlideTimer;

  final List<Map<String, String>> slides = [
    {
      'title': 'Đánh Thức Phiên Bản Hoàn Hảo Từ Bữa Ăn Đầu Tiên',
      'description':
          'Không chỉ là công thức, AI thiết kế lộ trình dinh dưỡng chuẩn xác để bạn "lột xác" mỗi ngày.',
      'image':
          'https://lh3.googleusercontent.com/aida-public/AB6AXuBVq7tZayUd7OeOII5YsJEHxVTj0CJu9R1MjAd9HtV8pOh2cP9uKyyRfFUwUAGyu6R91zf_WN1c_-egsZYPQf9_7mOvxN0PJGQLsVXkFEynekB7JtyRWbulNRbsNt1p7kSjjvTETfJggoNR-5Ca-pMKpR5T7RgLYMwthECxb1hETIedPk2sG7BC0oOX-gKkEnn5mHarSzP_soYw4Du2t_Ln_HaZ1tKd9NULcbLjES-pDZGUvNGAQo6YUJEG0keuXEb8Q9nB61lHBIxd', // TODO: Add onboarding images
    },
    {
      'title': 'Thấu Hiểu Cơ Thể - Kiến Tạo Vóc Dáng',
      'description':
          'Tạm biệt chế độ ăn kiêng hà khắc. AI giúp bạn thưởng thức món ngon mà vẫn đạt mục tiêu sức khỏe.',
      'image':
          'https://lh3.googleusercontent.com/aida-public/AB6AXuCuKEEcmdpxmAyMHk_98SjyYhB2magA78T8M4QspGgkvKFozVgWxJ45d1oXv5RSnPNYyed4fwYc16PgG8gjTBZBxOw5N3j5CjRWR2GBt5URF8TXlrRHxqBaYMQYYiYlOJltBj2vLHnhCrr05SYlQ6b8cFZu9py0gH12kEbYhDX8pwREoEcpDHSUXdduy5xFBcRoiI8fUEk7dCMcjp6R0UNGNAkxY-W5-lGXKjk0J81mG7f5n22eAmIFJ6uKT6-5Y8KkX-icHnr5JrfO', // TODO: Add onboarding images
    },
    {
      'title': 'Khởi Đầu Kỷ Nguyên Ăn Uống Thông Minh',
      'description': 'Một chạm để có thực đơn độc bản. Biến dữ liệu cơ thể thành những bữa ăn đầy cảm hứng ngay hôm nay.',
      'image':
          'https://lh3.googleusercontent.com/aida-public/AB6AXuAyC2CMhqSqZZU0mrs56AA6h2PjYtpxXf7VFNaDLY5VhHf4dY-riMtQy4jxE_bg5qQMc2ZnpLxHMv-NuzD8cF79eGJ-9F6jB9pA6rfyF07ScdPGaOjAuO67Gzfcc6g4IEEpqCEqy8CGhuNSaqV9cYsSk__RNwJfi1vIqkT_nhGXul3hIj8RYCGtuEGniMgTamtFJE0I2KTBTMF3l2V1688E8wbn5du4zcSqrA2CitcwvrSmDwfYVcutl6o5brzddHiP3olQ70HSvcoB', // TODO: Add onboarding images
    },
    {
      'title': 'Bắt Đầu Hành Trình',
      'description': 'Chỉ vài giây để có bữa ăn lý tưởng cho sức khỏe của bạn.',
      'image':
          'https://lh3.googleusercontent.com/aida-public/AB6AXuAieiTR6dsUDdz12gHgUeMRz_0H_iDI5JYgWxjNqeR8xO30unxaTnytZAZ-8PzA3ZAF0nTks93PZdGPIJLuOxgkquDIMZ2fN9ECw_Nk8m7pwb0PtmDWdWiSD3BU4QQmorDRtlVK0hw27JTFZjcYvXZBQaueRejVNk_4WgS69q3_OkD2MbNxesIAcSRYTDWZ9RdUD3w9u5kvExRXZChHeuaa-ad1IKPinJYFu_eJ3WW6jk7dRTX1cou2VWwM-Is8xmA_wt3LOj1Pb4g6', // TODO: Add onboarding images
    },
  ];

  @override
  void onInit() {
    super.onInit();
    pageController.addListener(_onPageChanged);
    _startAutoSlide();
  }

  void _onPageChanged() {
    if (pageController.page != null) {
      final page = pageController.page!.round();
      currentPageIndex.value = page % slides.length;
    }
  }

  void onPageChanged(int index) {
    currentPageIndex.value = index % slides.length;
    _resetAutoSlide();
  }

  void _startAutoSlide() {
    _autoSlideTimer?.cancel();
    _autoSlideTimer = Timer.periodic(const Duration(seconds: 5), (timer) {
      if (pageController.hasClients) {
        final currentPage = pageController.page?.round() ?? 1000;
        final nextPage = currentPage + 1;
        pageController.animateToPage(
          nextPage,
          duration: const Duration(milliseconds: 1500),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  void _resetAutoSlide() {
    _autoSlideTimer?.cancel();
    _startAutoSlide();
  }

  void handleGoogleLogin() {
    AppToast.info('Sắp ra mắt', 'Tính năng đăng nhập Google sắp ra mắt.');
  }

  void handleAppleLogin() {
    AppToast.info('Sắp ra mắt', 'Tính năng đăng nhập Apple sắp ra mắt.');
  }

  void handleFacebookLogin() {
    AppToast.info('Sắp ra mắt', 'Tính năng đăng nhập Facebook sắp ra mắt.');
  }

  @override
  void onClose() {
    _autoSlideTimer?.cancel();
    pageController.removeListener(_onPageChanged);
    pageController.dispose();
    super.onClose();
  }
}
