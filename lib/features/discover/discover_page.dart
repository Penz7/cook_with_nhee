import 'package:cook_with_nhee/commons/extensions/color_extension.dart';
import 'package:cook_with_nhee/commons/extensions/number_extension.dart';
import 'package:cook_with_nhee/commons/routes/route.dart';
import 'package:cook_with_nhee/commons/style/colors.dart';
import 'package:cook_with_nhee/commons/style/font_sizes.dart';
import 'package:cook_with_nhee/commons/widgets/app/app_filter.dart';
import 'package:cook_with_nhee/commons/widgets/app/app_text.dart';
import 'package:cook_with_nhee/commons/widgets/app/app_toast.dart';
import 'package:cook_with_nhee/commons/widgets/app/primary_scaffold.dart';
import 'package:cook_with_nhee/generated/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../network/provider/api_client.dart';
import 'components/discover_card.dart';
import 'components/discover_shimmer.dart';
import 'components/featured_article_card.dart';
import 'discover_controller.dart';

class DiscoverBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => DiscoverController(Get.find(), Get.find<ApiClient>()));
  }
}

class DiscoverPage extends GetView<DiscoverController> {
  const DiscoverPage({super.key});

  @override
  Widget build(BuildContext context) {
    return PrimaryScaffold(
      backgroundColor: const BoxDecoration(color: UIColors.creamy),
      body: Obx(() {
        final featured = controller.featuredNews.value;
        final items = controller.news;

        return RefreshIndicator(
          onRefresh: controller.refreshNews,
          color: UIColors.pink,
          child: CustomScrollView(
            slivers: [
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              sliver: SliverToBoxAdapter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    20.height,
                    Row(
                      mainAxisAlignment: .spaceBetween,
                      children: [
                        AppText.bold(
                          'Sức khoẻ \n& Đời sống',
                          fontSize: FontSizes.extra,
                          textAlign: TextAlign.left,
                        ),
                        Assets.images.imgHealthy.image(
                          width: 100,
                          height: 100,
                          fit: BoxFit.contain,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            SliverPersistentHeader(
              delegate: AppFilter(
                filters:
                    DiscoverController.filters.map((e) => e['key']!).toList(),
                selectedFilter: controller.categoryKey,
                onFilterChanged: (label) {
                  final map = DiscoverController.filters.firstWhere(
                    (e) => e['key'] == label,
                  );
                  controller.changeCategory(map['value']!);
                },
              ),
              pinned: true,
            ),
            // Featured article (first item) - không shimmer khi loading
            if (controller.isLoading.value)
              const SliverToBoxAdapter(child: SizedBox.shrink())
            else if (featured != null)
              SliverToBoxAdapter(
                child: _buildFeaturedArticle(featured, controller),
              ),
            // Latest Articles header
            if (!controller.isLoading.value && items.isNotEmpty)
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
                sliver: SliverToBoxAdapter(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      AppText.bold(
                        'Bài viết mới nhất',
                        fontSize: FontSizes.medium,
                        color: Colors.black87,
                      ),
                      _buildPaginator(controller),
                    ],
                  ),
                ),
              ),
            // List of remaining articles
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              sliver: controller.isLoading.value
                  ? SliverList(
                      delegate: SliverChildBuilderDelegate((
                        context,
                        index,
                      ) {
                        return const DiscoverShimmerCard();
                      }, childCount: 5),
                    )
                  : controller.isPaging.value
                      ? SliverList(
                          delegate: SliverChildBuilderDelegate((
                            context,
                            index,
                          ) {
                            return const DiscoverShimmerCard();
                          }, childCount: 5),
                        )
                      : SliverList(
                          delegate: SliverChildBuilderDelegate(
                            (context, index) {
                              if (index >= items.length) {
                                return const SizedBox.shrink();
                              }
                              final item = items[index];
                              String category = 'HEALTH';
                              if (controller.category.value != 'All') {
                                final filter =
                                    DiscoverController.filters.firstWhere(
                                  (e) => e['value'] == controller.category.value,
                                  orElse: () => DiscoverController.filters[0],
                                );
                                category = filter['key']!.toUpperCase();
                              }

                              return DiscoverCard(
                                title: item.title ?? '',
                                subtitle: item.subtitle ?? '',
                                category: category,
                                timeAgo: item.date ?? '',
                                imageUrl: item.imageUrl ?? '',
                                onTap: () => _navigateToNewsDetail(item.link),
                              );
                            },
                            childCount: items.length > 1 ? items.length - 1 : 0,
                          ),
                        ),
            ),
            if (items.isEmpty && !controller.isLoading.value)
              const SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 32,
                  ),
                  child: Center(
                    child: Text(
                      'Không tìm thấy bài viết cho bộ lọc này.',
                      style: TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                  ),
                ),
              ),
            const SliverToBoxAdapter(child: SizedBox(height: 100)),
          ],
        ),
        );
      }),
    );
  }

  Widget _buildFeaturedArticle(dynamic item, DiscoverController controller) {
    String category = 'RESEARCH';
    if (controller.category.value != 'All') {
      final filter = DiscoverController.filters.firstWhere(
        (e) => e['value'] == controller.category.value,
        orElse: () => DiscoverController.filters[0],
      );
      category = filter['key']!.toUpperCase();
    }

    return FeaturedArticleCard(
      title: item.title ?? '',
      subtitle: item.subtitle ?? '',
      category: category,
      timeAgo: item.date ?? '',
      imageUrl: item.imageUrl ?? '',
      onTap: () => _navigateToNewsDetail(item.link),
    );
  }

  void _navigateToNewsDetail(String? link) {
    if (link == null || link.isEmpty) {
      AppToast.info('Info', 'Không có link bài viết');
      return;
    }

    Get.toNamed(Routes.newsDetail.p, arguments: {'link': link});
  }

  Widget _buildPaginator(DiscoverController controller) {
    return Obx(() {
      final isBusy = controller.isLoading.value;
      final canPrev = controller.page.value > 1 && !isBusy;
      final canNext = controller.hasMore.value && !isBusy;

      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          InkWell(
            onTap: canPrev ? controller.previousPage : null,
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: UIColors.pinkLight,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.opacityColor(0.2),
                    spreadRadius: 2,
                    blurRadius: 10
                  ),
                ]
              ),
              child: Icon(
                Icons.chevron_left, color: Colors.white,
              ),
            ),
          ),
          12.width,
          InkWell(
            onTap: canNext ? controller.nextPage : null,
            child: Container(
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: UIColors.pinkLight,
                  boxShadow: [
                    BoxShadow(
                        color: Colors.grey.opacityColor(0.2),
                        spreadRadius: 2,
                        blurRadius: 10
                    ),
                  ]
              ),
              child: Icon(
                Icons.chevron_right, color: Colors.white,
              ),
            ),
          ),
        ],
      );
    });
  }
}
