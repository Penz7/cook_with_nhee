// dart format width=80

/// GENERATED CODE - DO NOT MODIFY BY HAND
/// *****************************************************
///  FlutterGen
/// *****************************************************

// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: deprecated_member_use,directives_ordering,implicit_dynamic_list_literal,unnecessary_import

import 'package:flutter/widgets.dart';

class $AssetsIconsGen {
  const $AssetsIconsGen();

  /// File path: assets/icons/ic_apple.png
  AssetGenImage get icApple => const AssetGenImage('assets/icons/ic_apple.png');

  /// File path: assets/icons/ic_body_measurement.png
  AssetGenImage get icBodyMeasurement =>
      const AssetGenImage('assets/icons/ic_body_measurement.png');

  /// File path: assets/icons/ic_diet.png
  AssetGenImage get icDiet => const AssetGenImage('assets/icons/ic_diet.png');

  /// File path: assets/icons/ic_facebook.png
  AssetGenImage get icFacebook =>
      const AssetGenImage('assets/icons/ic_facebook.png');

  /// File path: assets/icons/ic_google.png
  AssetGenImage get icGoogle =>
      const AssetGenImage('assets/icons/ic_google.png');

  /// File path: assets/icons/ic_setting.png
  AssetGenImage get icSetting =>
      const AssetGenImage('assets/icons/ic_setting.png');

  /// File path: assets/icons/ic_target.png
  AssetGenImage get icTarget =>
      const AssetGenImage('assets/icons/ic_target.png');

  /// List of all assets
  List<AssetGenImage> get values => [
    icApple,
    icBodyMeasurement,
    icDiet,
    icFacebook,
    icGoogle,
    icSetting,
    icTarget,
  ];
}

class $AssetsImagesGen {
  const $AssetsImagesGen();

  /// File path: assets/images/app_icon.png
  AssetGenImage get appIcon =>
      const AssetGenImage('assets/images/app_icon.png');

  /// File path: assets/images/app_splash.png
  AssetGenImage get appSplash =>
      const AssetGenImage('assets/images/app_splash.png');

  /// File path: assets/images/img_healthy.png
  AssetGenImage get imgHealthy =>
      const AssetGenImage('assets/images/img_healthy.png');

  /// List of all assets
  List<AssetGenImage> get values => [appIcon, appSplash, imgHealthy];
}

class Assets {
  const Assets._();

  static const $AssetsIconsGen icons = $AssetsIconsGen();
  static const $AssetsImagesGen images = $AssetsImagesGen();
}

class AssetGenImage {
  const AssetGenImage(
    this._assetName, {
    this.size,
    this.flavors = const {},
    this.animation,
  });

  final String _assetName;

  final Size? size;
  final Set<String> flavors;
  final AssetGenImageAnimation? animation;

  Image image({
    Key? key,
    AssetBundle? bundle,
    ImageFrameBuilder? frameBuilder,
    ImageErrorWidgetBuilder? errorBuilder,
    String? semanticLabel,
    bool excludeFromSemantics = false,
    double? scale,
    double? width,
    double? height,
    Color? color,
    Animation<double>? opacity,
    BlendMode? colorBlendMode,
    BoxFit? fit,
    AlignmentGeometry alignment = Alignment.center,
    ImageRepeat repeat = ImageRepeat.noRepeat,
    Rect? centerSlice,
    bool matchTextDirection = false,
    bool gaplessPlayback = true,
    bool isAntiAlias = false,
    String? package,
    FilterQuality filterQuality = FilterQuality.medium,
    int? cacheWidth,
    int? cacheHeight,
  }) {
    return Image.asset(
      _assetName,
      key: key,
      bundle: bundle,
      frameBuilder: frameBuilder,
      errorBuilder: errorBuilder,
      semanticLabel: semanticLabel,
      excludeFromSemantics: excludeFromSemantics,
      scale: scale,
      width: width,
      height: height,
      color: color,
      opacity: opacity,
      colorBlendMode: colorBlendMode,
      fit: fit,
      alignment: alignment,
      repeat: repeat,
      centerSlice: centerSlice,
      matchTextDirection: matchTextDirection,
      gaplessPlayback: gaplessPlayback,
      isAntiAlias: isAntiAlias,
      package: package,
      filterQuality: filterQuality,
      cacheWidth: cacheWidth,
      cacheHeight: cacheHeight,
    );
  }

  ImageProvider provider({AssetBundle? bundle, String? package}) {
    return AssetImage(_assetName, bundle: bundle, package: package);
  }

  String get path => _assetName;

  String get keyName => _assetName;
}

class AssetGenImageAnimation {
  const AssetGenImageAnimation({
    required this.isAnimation,
    required this.duration,
    required this.frames,
  });

  final bool isAnimation;
  final Duration duration;
  final int frames;
}
