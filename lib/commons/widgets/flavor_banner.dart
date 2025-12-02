import 'package:flutter/material.dart';

import '../../../env.dart';

class FlavorBanner extends StatelessWidget {
  final Widget child;
  final bool enable;

  const FlavorBanner({super.key, required this.child, this.enable = true});

  @override
  Widget build(BuildContext context) {
    return enable
        ? Stack(
      children: <Widget>[
        child,
        if (Env().flavor != Flavor.production) _buildBanner(context),
      ],
    )
        : child;
  }

  BannerConfig _getDefaultBanner() {
    return BannerConfig(
      bannerName: Env().flavor != Flavor.production ? 'Test' : '',
      bannerColor: Colors.red,
    );
  }

  Widget _buildBanner(BuildContext context) {
    final bannerConfig = _getDefaultBanner();
    return Positioned(
      top: 0,
      right: 0,
      child: SizedBox(
        width: 50,
        height: 50,
        child: CustomPaint(
          painter: BannerPainter(
            message: bannerConfig.bannerName,
            textDirection: Directionality.of(context),
            layoutDirection: Directionality.of(context),
            location: BannerLocation.topEnd,
            color: bannerConfig.bannerColor,
          ),
        ),
      ),
    );
  }
}

class BannerConfig {
  final String bannerName;
  final Color bannerColor;

  BannerConfig({required this.bannerName, required this.bannerColor});
}
