import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

/// Overlay widget để play video khi click vào video trong grid
class VideoPlayerOverlay extends StatefulWidget {
  final String videoUrl;

  const VideoPlayerOverlay({
    super.key,
    required this.videoUrl,
  });

  @override
  State<VideoPlayerOverlay> createState() => _VideoPlayerOverlayState();
}

class _VideoPlayerOverlayState extends State<VideoPlayerOverlay> {
  VideoPlayerController? _videoPlayerController;
  ChewieController? _chewieController;
  bool _isInitialized = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _initializeVideo();
  }

  Future<void> _initializeVideo() async {
    try {
      // Validate URL trước khi khởi tạo
      final uri = Uri.tryParse(widget.videoUrl);
      if (uri == null || !uri.hasScheme || uri.host.isEmpty) {
        if (mounted) {
          setState(() {
            _errorMessage = 'URL video không hợp lệ';
          });
        }
        return;
      }

      _videoPlayerController = VideoPlayerController.networkUrl(uri);

      // Thêm timeout cho việc initialize
      await _videoPlayerController!.initialize().timeout(
        const Duration(seconds: 30),
        onTimeout: () {
          throw Exception('Timeout khi tải video');
        },
      );

      // Kiểm tra xem video có được load thành công không
      if (!_videoPlayerController!.value.isInitialized) {
        throw Exception('Video không thể khởi tạo');
      }

      if (mounted) {
        _chewieController = ChewieController(
          videoPlayerController: _videoPlayerController!,
          autoPlay: true,
          looping: false,
          aspectRatio: _videoPlayerController!.value.aspectRatio,
          allowFullScreen: true,
          allowMuting: true,
          allowPlaybackSpeedChanging: true,
          errorBuilder: (context, errorMessage) {
            return _buildErrorWidget();
          },
        );

        // Lắng nghe lỗi từ video player
        _videoPlayerController!.addListener(() {
          if (_videoPlayerController!.value.hasError) {
            if (mounted) {
              setState(() {
                _errorMessage = _parseVideoError(
                  _videoPlayerController!.value.errorDescription ?? 'Lỗi không xác định',
                );
              });
            }
          }
        });

        setState(() {
          _isInitialized = true;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = _parseVideoError(e.toString());
        });
      }
    }
  }

  /// Parse và format error message cho dễ đọc hơn
  String _parseVideoError(String error) {
    final errorLower = error.toLowerCase();
    
    if (errorLower.contains('media_err_src_not_supported') ||
        errorLower.contains('format error') ||
        errorLower.contains('not supported')) {
      return 'Định dạng video không được hỗ trợ. Vui lòng sử dụng file video trực tiếp (MP4, WebM).';
    }
    
    if (errorLower.contains('network') || errorLower.contains('connection')) {
      return 'Lỗi kết nối mạng. Vui lòng kiểm tra kết nối và thử lại.';
    }
    
    if (errorLower.contains('timeout')) {
      return 'Hết thời gian chờ khi tải video. Vui lòng thử lại.';
    }
    
    if (errorLower.contains('404') || errorLower.contains('not found')) {
      return 'Không tìm thấy video. URL có thể không còn hợp lệ.';
    }
    
    // Trả về message gốc nếu không match với các pattern trên
    return 'Không thể phát video. Vui lòng thử lại sau.';
  }

  @override
  void dispose() {
    _chewieController?.dispose();
    _videoPlayerController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.zero,
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        color: Colors.black,
        child: Stack(
          children: [
            // Video player hoặc error message
            Center(
              child: _errorMessage != null
                  ? _buildErrorWidget()
                  : _isInitialized && _chewieController != null
                      ? Chewie(controller: _chewieController!)
                      : _buildLoadingWidget(),
            ),
            // Close button
            Positioned(
              top: MediaQuery.of(context).padding.top + 16,
              right: 16,
              child: IconButton(
                icon: const Icon(
                  Icons.close,
                  color: Colors.white,
                  size: 28,
                ),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingWidget() {
    return const Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
        ),
        SizedBox(height: 16),
        Text(
          'Đang tải video...',
          style: TextStyle(color: Colors.white),
        ),
      ],
    );
  }

  Widget _buildErrorWidget() {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.error_outline,
            color: Colors.white,
            size: 64,
          ),
          const SizedBox(height: 16),
          const Text(
            'Không thể phát video',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              _errorMessage ?? 'Đã xảy ra lỗi không xác định',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: Colors.black,
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
            ),
            child: const Text('Đóng'),
          ),
        ],
      ),
    );
  }
}
