import 'package:cook_with_nhee/features/authentication/login/login_page.dart';
import 'package:cook_with_nhee/features/my_recipes/my_recipes_page.dart';
import 'package:cook_with_nhee/features/profile/profile_page.dart';
import 'package:cook_with_nhee/network/models/login_model.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

import '../../controller/auth_controller.dart';
import '../../features/home/home_page.dart';
import '../../features/splash/splash_page.dart';

class Routes {
  static const splash = RoutePath('/');
  static const intro = RoutePath('/intro');
  static const start = RoutePath('/start');
  static const login = RoutePath('/login');
  static const unauthenticated = RoutePath('/401');
  static const unauthorized = RoutePath('/403');
  static const home = RoutePath('/main');
  static const maintenance = RoutePath('/maintenance');

  /// profile
  static const profile = RoutePath('/profile');
  
  /// my recipes
  static const myRecipes = RoutePath('/my-recipes');
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
  Routes.home,
  Routes.profile,
  Routes.myRecipes,
].map((e) => SpecialRoute(e.p)).toList();

final List<GetPage> getPages = [
  GetPage(
    name: Routes.splash.sp,
    page: () => SplashPage(),
    binding: SplashBinding(),
  ),
  GetPage(name: Routes.unauthorized.sp, page: () => Container()),
  GetPage(name: Routes.home.sp, page: () => HomePage(), binding: HomeBinding()),
  GetPage(
    name: Routes.login.sp,
    page: () => LoginPage(),
    binding: LoginBinding(),
  ),
  GetPage(
    name: Routes.profile.sp,
    page: () => ProfilePage(),
    binding: ProfileBinding(),
  ),
  GetPage(
    name: Routes.myRecipes.sp,
    page: () => MyRecipesPage(),
    binding: MyRecipesBinding(),
  ),
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
  final bool requiredConnected;
  final bool Function(dynamic args, User user)? except;

  SpecialRoute(
    this.route, {
    this.requiredConnected = false,
    this.except,
  });
}

class AuthGuard extends GetMiddleware {
  @override
  int? get priority => 1;

  @override
  RouteSettings? redirect(String? route) {
    debugPrint('Checking auth guard... $route');
    final auth = Get.isRegistered<AuthController>()
        ? Get.find<AuthController>()
        : null;
    if (auth?.isAuth == true || route == Routes.login.p) return null;
    return RouteSettings(
      name: Routes.login.p,
      arguments: {'redirect': route ?? Routes.home.p},
    );
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
