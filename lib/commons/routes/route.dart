import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

import '../../features/home/home_page.dart';
import '../../features/splash/splash_page.dart';

class Routes {
  static const splash = RoutePath('/');
  static const intro = RoutePath('/intro');
  static const start = RoutePath('/start');
  static const unauthenticated = RoutePath('/401');
  static const unauthorized = RoutePath('/403');
  static const main = RoutePath('/main');
  static const maintenance = RoutePath('/maintenance');
}

class RoutePath {
  final String singlePath;
  final RoutePath? parent;

  String get path => parent != null
      ? '${parent != null ? parent!.path : ''}$singlePath'
      : singlePath;

  String get p => path;

  String get sp => singlePath;

  const RoutePath(this.singlePath, {this.parent});

  @override
  String toString() => path;
}

final List<SpecialRoute> privateRoutes = <RoutePath>[
  Routes.main,
].map((e) => SpecialRoute(e.p)).toList();

final List<GetPage> getPages = [
  GetPage(
    name: Routes.splash.sp,
    page: () => SplashPage(),
    binding: SplashBinding(),
  ),
  GetPage(name: Routes.unauthorized.sp, page: () => Container()),
  GetPage(name: Routes.main.sp, page: () => HomePage(), binding: HomeBinding(),),
].map((e) => e.applyMiddleware()).toList();

extension GetPageX on GetPage {
  GetPage applyMiddleware() {
    final auth = privateRoutes.firstWhereOrNull((r) => r.route.endsWith(name));

    if (auth != null) {
      return copy(
        middlewares: [AuthGuard()],
        children: children.map((e) => e.applyMiddleware()).toList(),
      );
    }
    return this;
  }
}

class SpecialRoute {
  final String route;
  final bool requiredSupportedChain;
  final bool requiredConnected;
  final bool Function(dynamic args, dynamic user)? except;

  SpecialRoute(
    this.route, {
    bool requiredSupportedChain = false,
    this.requiredConnected = false,
    this.except,
  }) : requiredSupportedChain = requiredConnected || requiredSupportedChain;
}

class AuthGuard extends GetMiddleware {
  @override
  int? get priority => 1;

  @override
  RouteSettings? redirect(String? route) {
    // print('Checking auth guard... $route');
    // final auth = Get.isRegistered<AuthController>()
    //     ? Get.find<AuthController>()
    //     : null;
    // if (auth?.isAuth == true || route == Routes.login.p) return null;
    // return RouteSettings(
    //   name: Routes.login.p,
    //   arguments: {'redirect': route ?? Routes.main.p},
    // );
    return null;
  }
}

class RouteService extends GetxService {
  static RouteService get to => Get.find();

  final RxString _currentRoute = ''.obs;
  final RxString _previousRoute = ''.obs;

  String get currentRoute => _currentRoute.value;

  String get previousRoute => _previousRoute.value;

  void updateRoute(String newRoute) {
    _previousRoute.value = _currentRoute.value;
    _currentRoute.value = newRoute;
  }
}
