import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../app/app_image.dart';
import '../recipe_detail/video_player_overlay.dart';

class MediaGrid extends StatelessWidget {
  final List<String> images;
  final List<String> videos;

  const MediaGrid({
    super.key,
    required this.images,
    required this.videos,
  });

  factory MediaGrid.fromDynamic({
    required List<dynamic>? images,
    required List<dynamic>? videos,
  }) {
    return MediaGrid(
      images: _convertDynamicList(images),
      videos: _convertDynamicList(videos),
    );
  }

  static List<String> _convertDynamicList(List<dynamic>? list) {
    if (list == null || list.isEmpty) return [];
    return list
        .map((item) => item?.toString() ?? '')
        .where((url) => url.isNotEmpty)
        .toList();
  }

  static bool _isValidUrl(String? url, {bool isVideo = false}) {
    if (url == null || url.isEmpty) return false;

    try {
      final uri = Uri.parse(url);
      if (!uri.hasScheme || (uri.scheme != 'http' && uri.scheme != 'https')) {
        return false;
      }
      if (uri.host.isEmpty) {
        return false;
      }

      final host = uri.host.toLowerCase();
      if (host == 'localhost' ||
          host.startsWith('127.') ||
          host.startsWith('192.168.') ||
          host.startsWith('10.') ||
          host.startsWith('172.')) {
        return false;
      }

      if (isVideo) {
        final path = uri.path.toLowerCase();
        final validVideoExtensions = [
          '.mp4',
          '.webm',
          '.mov',
          '.m4v',
          '.3gp',
          '.mkv',
          '.avi'
        ];
        final hasValidExtension = validVideoExtensions.any((ext) => path.endsWith(ext));

        if (hasValidExtension) {
          return true;
        }
        if (host.contains('youtube.com') ||
            host.contains('youtu.be') ||
            host.contains('vimeo.com') ||
            host.contains('dailymotion.com') ||
            host.contains('facebook.com') ||
            host.contains('instagram.com')) {
          return true;
        }
        if (path.isEmpty && uri.queryParameters.isEmpty) {
          return false;
        }
        return true;
      }

      return true;
    } catch (e) {
      return false;
    }
  }

  /// Accept all non-empty images
  List<String> get _validImages {
    return images
        .where((url) => url.isNotEmpty)
        .map((url) => url.toString())
        .toList();
  }

  /// Validate only videos
  List<String> get _validVideos {
    return videos
        .where((url) => _isValidUrl(url, isVideo: true))
        .map((url) => url.toString())
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final validImages = _validImages;
    final validVideos = _validVideos;

    if (validImages.isEmpty && validVideos.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (validImages.isNotEmpty) ...[
          _buildSectionTitle('Hình ảnh'),
          const SizedBox(height: 8),
          _buildImageGrid(context, validImages),
          const SizedBox(height: 20),
        ],
        if (validVideos.isNotEmpty) ...[
          _buildSectionTitle('Video'),
          const SizedBox(height: 8),
          _buildVideoGrid(context, validVideos),
        ],
      ],
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: Colors.pink.shade800,
      ),
    );
  }

  Widget _buildImageGrid(BuildContext context, List<String> imageUrls) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
        childAspectRatio: 1.0,
      ),
      itemCount: imageUrls.length,
      itemBuilder: (context, index) {
        return _buildImageItem(context, imageUrls[index]);
      },
    );
  }

  Widget _buildImageItem(BuildContext context, String imageUrl) {
    return AppInternetImage(
      url: imageUrl,
      borderRadius: 12,
      fit: BoxFit.cover,
    );
  }

  Widget _buildVideoGrid(BuildContext context, List<String> videoUrls) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
        childAspectRatio: 1.0,
      ),
      itemCount: videoUrls.length,
      itemBuilder: (context, index) {
        return _buildVideoItem(context, videoUrls[index]);
      },
    );
  }

  Widget _buildVideoItem(BuildContext context, String videoUrl) {
    return GestureDetector(
      onTap: () async {
        final uri = Uri.tryParse(videoUrl);
        if (uri != null) {
          final host = uri.host.toLowerCase();
          final isEmbeddedVideo = host.contains('youtube.com') ||
              host.contains('youtu.be') ||
              host.contains('vimeo.com') ||
              host.contains('dailymotion.com') ||
              host.contains('facebook.com') ||
              host.contains('instagram.com');
          
          if (isEmbeddedVideo) {
            // Open embedded video in external browser
            final url = Uri.parse(videoUrl);
            if (await canLaunchUrl(url)) {
              await launchUrl(url, mode: LaunchMode.externalApplication);
            } else {
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Không thể mở video. Vui lòng thử lại.'),
                  ),
                );
              }
            }
          } else {
            // Show overlay to play video directly
            if (context.mounted) {
              showDialog(
                context: context,
                barrierColor: Colors.black87,
                builder: (context) => VideoPlayerOverlay(videoUrl: videoUrl),
              );
            }
          }
        }
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Thumbnail placeholder; replace with video thumbnail if available
            Container(
              color: Colors.grey.shade800,
              child: Icon(
                Icons.play_circle_filled,
                size: 48,
                color: Colors.white.withOpacity(0.8),
              ),
            ),
            // Play button overlay
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black.withOpacity(0.5),
                    ],
                  ),
                ),
                child: const Center(
                  child: Icon(
                    Icons.play_circle_filled,
                    size: 48,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
