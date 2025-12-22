import 'package:cook_with_nhee/commons/extensions/color_extension.dart';
import 'package:cook_with_nhee/commons/extensions/number_extension.dart';
import 'package:cook_with_nhee/commons/style/colors.dart';
import 'package:cook_with_nhee/commons/style/font_sizes.dart';
import 'package:cook_with_nhee/commons/widgets/app/app_image.dart';
import 'package:cook_with_nhee/commons/widgets/app/app_text.dart';
import 'package:cook_with_nhee/commons/widgets/app/app_shimmer.dart';
import 'package:cook_with_nhee/commons/widgets/app/primary_scaffold.dart';
import 'package:cook_with_nhee/features/news_detail/news_detail_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../network/models/new_detail_model.dart';

class NewsDetailPage extends GetView<NewsDetailController> {
  const NewsDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    return PrimaryScaffold(
      extendBodyBehindAppBar: true,
      floatingActionButton: Obx(() {
        final isVisible = controller.showScrollToTop.value;
        if (!isVisible) return const SizedBox.shrink();
        return FloatingActionButton.small(
          onPressed: controller.scrollToTop,
          backgroundColor: UIColors.pink,
          child: const Icon(Icons.keyboard_arrow_up, color: Colors.white),
        );
      }),
      body: Obx(() {
        if (controller.isLoading.value) {
          return _buildLoadingState();
        }

        if (controller.errorMessage.value.isNotEmpty) {
          return _buildErrorState();
        }

        final news = controller.newsDetail.value;
        if (news == null) {
          return _buildEmptyState();
        }

        return _buildContent(context, news);
      }),
    );
  }

  Widget _buildLoadingState() {
    return SingleChildScrollView(
      child: Column(
        children: [
          const AppShimmer.rectangular(
            width: double.infinity,
            height: 250,
            borderRadius: 15,
          ),
          Transform.translate(
            offset: const Offset(0, -30),
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: UIColors.creamy,
                borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const AppShimmer.rectangular(
                    width: 120,
                    height: 28,
                    borderRadius: 8,
                  ),
                  16.height,
                  const AppShimmer.rectangular(
                    width: double.infinity,
                    height: 32,
                    borderRadius: 4,
                  ),
                  12.height,
                  const AppShimmer.rectangular(
                    width: 250,
                    height: 32,
                    borderRadius: 4,
                  ),
                  20.height,
                  const AppShimmer.rectangular(
                    width: 200,
                    height: 20,
                    borderRadius: 4,
                  ),
                  20.height,
                  const AppShimmer.rectangular(
                    width: double.infinity,
                    height: 16,
                    borderRadius: 4,
                  ),
                  8.height,
                  const AppShimmer.rectangular(
                    width: double.infinity,
                    height: 16,
                    borderRadius: 4,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.grey),
            20.height,
            AppText.regular(
              controller.errorMessage.value,
              textAlign: TextAlign.center,
              fontSize: FontSizes.small,
              color: Colors.grey.shade700,
            ),
            20.height,
            ElevatedButton(
              onPressed: () => Get.back(),
              child: const Text('Quay lại'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisSize: .min,
        children: [
          Icon(Icons.error_outline_sharp, color: UIColors.pink, size: 40),
          10.height,
          AppText.bold('Hiện tại dữ liệu đang bị lỗi. Hãy quay lại sau!'),
          16.height,
          ElevatedButton(
            style: ButtonStyle(
              backgroundColor: WidgetStatePropertyAll(UIColors.pinkLight),
              elevation: WidgetStatePropertyAll(2),
              maximumSize: WidgetStatePropertyAll(Size.fromWidth(150)),
            ),
            onPressed: () {
              Get.back();
            },
            child: AppText.regular(
              'Quay lại',
              fontSize: FontSizes.small,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContent(BuildContext context, NewDetailModel news) {
    final imageUrl = news.imageUrl ?? '';
    final title = news.title ?? '';
    final author = news.author ?? 'Unknown Author';
    final content = news.content ?? '';

    return Stack(
      children: [
        SingleChildScrollView(
          controller: controller.scrollController,
          child: Column(
            children: [
              Stack(
                children: [
                  SizedBox(
                    width: double.infinity,
                    height: 250,
                    child: AppInternetImage(
                      url: imageUrl.trim(),
                      fit: BoxFit.cover,
                      enablePreview: true,
                    ),
                  ),
                  Positioned(
                    top: 16,
                    left: 16,
                    child: IconButton.filled(
                      color: UIColors.pink,
                      style: ButtonStyle(
                        backgroundColor: WidgetStatePropertyAll(UIColors.pink),
                      ),
                      onPressed: () {
                        Get.back();
                      },
                      icon: Icon(
                        Icons.arrow_back_sharp,
                        size: 20,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
              Transform.translate(
                offset: const Offset(0, -30),
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: UIColors.creamy,
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(30)),
                  ),
                  child: Column(
                    crossAxisAlignment: .start,
                    children: [
                      AppText.bold(
                        title,
                        fontSize: FontSizes.medium,
                        maxLines: 5,
                      ),
                      16.height,
                      _buildAuthorInfo(author),
                      24.height,
                      Text(
                        content,
                        textAlign: TextAlign.justify,
                        style: TextStyle(fontSize: FontSizes.small),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        Obx(() {
          if (!controller.showScrollToTop.value) {
            return const SizedBox.shrink();
          }
          return Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 250),
              transitionBuilder: (child, animation) {
                final slideAnimation = Tween<Offset>(
                  begin: const Offset(0, -0.1),
                  end: Offset.zero,
                ).animate(CurvedAnimation(
                  parent: animation,
                  curve: Curves.easeOut,
                ));
                return FadeTransition(
                  opacity: CurvedAnimation(
                    parent: animation,
                    curve: Curves.easeOut,
                  ),
                  child: SlideTransition(
                    position: slideAnimation,
                    child: child,
                  ),
                );
              },
              child: Container(
                key: const ValueKey('stickyTitle'),
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: UIColors.creamy,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.opacityColor(0.08),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () => Get.back(),
                      icon: const Icon(Icons.arrow_back_sharp, size: 25,),
                      color: UIColors.pink,
                    ),
                    8.width,
                    Expanded(
                      child: AppText.bold(
                        title,
                        maxLines: 3,
                        fontSize: FontSizes.small,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }),
      ],
    );
  }

  Widget _buildAuthorInfo(String author) {
    return Row(
      children: [
        CircleAvatar(
          radius: 20,
          backgroundColor: UIColors.pink.opacityColor(0.3),
          child: AppText.bold(
            author.isNotEmpty ? author[0].toUpperCase() : 'A',
            fontSize: FontSizes.small,
            color: UIColors.pink,
          ),
        ),
        12.width,
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppText.medium(
                author,
                fontSize: FontSizes.small,
                color: Colors.black87,
              ),
              4.height,
              Row(
                children: [
                  AppText.regular(
                    'Oct 24, 2023',
                    fontSize: FontSizes.extraSmall,
                    color: Colors.grey.shade600,
                  ),
                  8.width,
                  Container(
                    width: 4,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade400,
                      shape: BoxShape.circle,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
