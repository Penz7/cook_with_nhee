import 'package:cook_with_nhee/commons/extensions/color_extension.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';

import 'app_config.dart';
import 'commons/routes/route.dart';
import 'commons/widgets/app_life_cycle_overlay.dart';
import 'controller/system_controller.dart';
import 'env.dart';
import 'generated/l10n.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // await Firebase.initializeApp();
  debugPrint('Handling a background message: ${message.messageId}');
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Env().getRemoteConfig();
  await initConfig();

  if (!kIsWeb) {
    FirebaseMessaging.onBackgroundMessage(
      _firebaseMessagingBackgroundHandler,
    );
  }

  try {
    final fcmToken = await FirebaseMessaging.instance.getToken();
    debugPrint('FCM Token:\n$fcmToken\n');
  } catch (e) {
    debugPrint('Error getting FCM token: $e');
  }


  final systemController = Get.find<SystemController>();
  WidgetsBinding.instance.addObserver(
    LifecycleEventHandler(
      resumeCallBack: () async => systemController.onAppForeground(),
      suspendingCallBack: () async => systemController.onAppBackground(),
    ),
  );
  runApp(const App());
}

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  final _navigatorKey = GlobalKey<NavigatorState>();
  static const double _webMaxContentWidth = 480;

  final ColorScheme lightScheme = ColorScheme.fromSeed(
    seedColor: Colors.blue,
    brightness: Brightness.light,
    surface: const Color(0xFFFAFAFA),
    onSurface: const Color(0xFF1C1B1F),
  );

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      key: _navigatorKey,
      routingCallback: (routing) {
        if (routing != null) {
          RouteService.to.updateRoute(routing.current);
        }
      },
      smartManagement: SmartManagement.full,
      onGenerateTitle: (context) => Env().appName,
      debugShowCheckedModeBanner: false,
      title: Env().appName,
      theme: ThemeData(
        colorScheme: lightScheme,
        scaffoldBackgroundColor: lightScheme.surface,
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        cardTheme: CardThemeData(
          color: lightScheme.surface,
        ),
      ),
      enableLog: kDebugMode,
      popGesture: !kIsWeb,
      defaultTransition: kIsWeb ? Transition.fadeIn : Transition.cupertino,
      getPages: getPages,
      initialRoute: Routes.splash.p,
      locale: Locale('en'),
      builder: (context, c) {
        final theme = Theme.of(context);
        final content = Overlay(
          initialEntries: [
            OverlayEntry(
              builder: (overlayContext) => c!,
            ),
            OverlayEntry(builder: (context) => AppLifecycleOverlay()),
          ],
        );
        if (!kIsWeb) return content;

        return Container(
          color: Colors.pink.opacityColor(0.2),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                maxWidth: _webMaxContentWidth,
              ),
              child: content,
            ),
          ),
        );
      },
      localizationsDelegates: [
        S.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: S.delegate.supportedLocales,
    );
  }
}


class LifecycleEventHandler extends WidgetsBindingObserver {
  final AsyncCallback resumeCallBack;
  final AsyncCallback suspendingCallBack;

  LifecycleEventHandler({
    required this.resumeCallBack,
    required this.suspendingCallBack,
  });

  @override
  Future<void> didChangeAppLifecycleState(AppLifecycleState state) async {
    switch (state) {
      case AppLifecycleState.resumed:
        await resumeCallBack();
        break;
      case AppLifecycleState.paused:
      case AppLifecycleState.detached:
        await suspendingCallBack();
        break;
      case AppLifecycleState.inactive:
      default:
        break;
    }
  }
}
