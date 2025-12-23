
import 'package:flutter/material.dart';

class AppLifecycleOverlay extends StatefulWidget {
  const AppLifecycleOverlay({super.key});

  @override
  State<AppLifecycleOverlay> createState() => _AppLifecycleOverlayState();
}

class _AppLifecycleOverlayState extends State<AppLifecycleOverlay>
    with WidgetsBindingObserver {
  bool shouldBlur = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    setState(() {
      shouldBlur = state == AppLifecycleState.inactive ||
          state == AppLifecycleState.paused;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 0),
      reverseDuration: const Duration(milliseconds: 500),
      child: Container(
        key: ValueKey(shouldBlur.toString()),
        // child: shouldBlur ? _buildBlur() : const SizedBox.shrink(),
        child: const SizedBox.shrink(),
      ),
    );
  }
}
