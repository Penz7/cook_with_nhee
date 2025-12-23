import 'dart:io';
import 'dart:math';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cook_with_nhee/commons/extensions/color_extension.dart';
import 'package:flutter/material.dart';

class AppInternetImage extends StatelessWidget {
  const AppInternetImage({
    super.key,
    required this.url,
    this.width = 0,
    this.height = 0,
    this.fit = BoxFit.cover,
    this.borderRadius = 0,
    this.placeHolder,
    this.isBlur = false,
    this.isFood = false,
    this.enablePreview = false,
  });

  final String url;
  final double width;
  final double height;
  final double borderRadius;
  final BoxFit fit;
  final String? placeHolder;
  final bool isBlur; // thêm
  final bool isFood;
  final bool enablePreview;

  static final List<String> _foodImageUrls = [
    'https://images.unsplash.com/photo-1504674900247-0877df9cc836?q=80&w=2340&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
    'https://images.unsplash.com/photo-1512621776951-a57141f2eefd?q=80&w=2340&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
    'https://images.unsplash.com/photo-1565958011703-44f9829ba187?q=80&w=1365&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
    'https://images.unsplash.com/photo-1511690656952-34342bb7c2f2?q=80&w=1364&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
    'https://images.unsplash.com/photo-1467003909585-2f8a72700288?q=80&w=987&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
    'https://images.unsplash.com/photo-1504754524776-8f4f37790ca0?q=80&w=2340&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
    'https://images.unsplash.com/photo-1540189549336-e6e99c3679fe?q=80&w=987&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
  ];

  static const Map<String, String> _browserHeaders = {
    'User-Agent':
        'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36',
  };

  static String _getRandomFoodImageUrl() {
    final random = Random();
    return _foodImageUrls[random.nextInt(_foodImageUrls.length)];
  }

  @override
  Widget build(BuildContext context) {
    final normalizedUrl = _normalizeUrl(url);
    final String imageUrl = normalizedUrl.isEmpty && isFood 
        ? _getRandomFoodImageUrl() 
        : normalizedUrl;
    
    if (imageUrl.isEmpty) return _buildErrorImage;

    final image = CachedNetworkImage(
      imageUrl: imageUrl,
      width: width,
      height: height,
      fit: fit,
      httpHeaders: _browserHeaders,
      errorWidget: (_, _, _) => _buildErrorImage,
      placeholder: (BuildContext context, String url) {
        return const SizedBox();
      },
    );

    Widget content = ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: Stack(
        fit: StackFit.expand,
        children: [
          image,
          if (isBlur)
            Container(
              color: Colors.black.opacityColor(0.5),
            ),
        ],
      ),
    );

    if (width > 0 && height > 0) {
      return SizedBox(
        width: width,
        height: height,
        child: _maybeWrapPreview(context, content, imageUrl),
      );
    }

    return _maybeWrapPreview(context, content, imageUrl);
  }

  String _normalizeUrl(String rawUrl) {
    if (rawUrl.isEmpty) return '';

    var url = rawUrl.trim();

    if (url.startsWith('//')) {
      url = 'https:$url';
    }

    final uri = Uri.tryParse(url);
    if (uri == null || (!uri.hasScheme && !url.startsWith('http'))) {
      return '';
    }

    return Uri.encodeFull(url);
  }

  Widget _maybeWrapPreview(BuildContext context, Widget child, String imageUrl) {
    if (!enablePreview || imageUrl.isEmpty) return child;

    return GestureDetector(
      onTap: () => _openPreview(context, imageUrl),
      child: child,
    );
  }

  void _openPreview(BuildContext context, String imageUrl) {
    showDialog(
      context: context,
      barrierColor: Colors.black87,
      builder: (_) {
        return GestureDetector(
          onTap: () => Navigator.of(context).pop(),
          child: Container(
            color: Colors.black87,
            alignment: Alignment.center,
            child: InteractiveViewer(
              child: CachedNetworkImage(
                imageUrl: imageUrl,
                fit: BoxFit.contain,
                httpHeaders: _browserHeaders,
                errorWidget: (_, _, _) => Image.asset(
                  "assets/images/app_icon.png",
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget get _buildErrorImage {
    if (isFood) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: CachedNetworkImage(
          imageUrl: _getRandomFoodImageUrl(),
          width: width > 0 ? width : null,
          height: height > 0 ? height : null,
          fit: fit,
          httpHeaders: _browserHeaders,
          errorWidget: (_, _, _) => Image.asset(
            "assets/images/app_icon.png",
            width: width > 0 ? 2 * width / 3 : null,
            fit: BoxFit.fitWidth,
          ),
          placeholder: (BuildContext context, String url) {
            return Container(
              width: width > 0 ? width : null,
              height: height > 0 ? height : null,
              color: Colors.grey[200],
            );
          },
        ),
      );
    }

    return Image.asset(
      "assets/images/app_icon.png",
      width: width > 0 ? 2 * width / 3 : null,
      fit: BoxFit.fitWidth,
    );
  }
}

class AppImage extends Image {
  AppImage.file({
    super.key,
    required File file,
    super.width,
    super.height,
    super.color,
    BoxFit boxFit = BoxFit.cover,
  }) : super(
    image: ResizeImage.resizeIfNeeded(
      null,
      null,
      FileImage(file),
    ),
    fit: boxFit,
  );
}
