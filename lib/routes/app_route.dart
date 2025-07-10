import 'package:get/get.dart';
import 'package:gitpumta/middlewares/auth_middleware.dart';
import 'package:gitpumta/views/group_search_view.dart';
import 'package:gitpumta/views/home_add_repo_view.dart';

import 'package:gitpumta/views/setting_view.dart';
import 'package:gitpumta/views/sign_up_view.dart';

import '../bindings/group_binding.dart';
import '../bindings/home_binding.dart';
import '../bindings/setting_binding.dart';
import '../views/auto_login_view.dart';
import '../views/group_add_view.dart';
import '../views/group_view.dart';
import '../views/home_view.dart';
import '../views/login_view.dart';

class AppRoutes {
  static const String login = '/login';
  static const String signUp = '/sign_up';
  static const String home = '/home';
  static const String group = '/group';
  static const String newGroup = '/new_group';
  static const String searchGroup = '/search_group';
  static const String newRepo = '/new_repo';
  static const String settings = '/settings';
  static const String splash = '/splash';

  static final routes = [
    GetPage(
      name: splash,
      page: () => SplashPage(),
      transition: Transition.noTransition,
    ),
    GetPage(
      name: login,
      page: () => LoginView(),
      transition: Transition.noTransition,
    ),
    GetPage(name: signUp, page: () => SignUpView(), transition: Transition.noTransition),
    GetPage(
      name: home,
      binding: HomeBinding(),
      page: () => HomeView(),
      middlewares: [AuthMiddleware()],
      transition: Transition.noTransition,
    ),
    GetPage(
      name: group,
      binding: GroupBinding(),
      page: () => GroupView(),
      middlewares: [AuthMiddleware()],
      transition: Transition.noTransition,
    ),
    GetPage(
      name: settings,
      binding: SettingBinding(),
      page: () => SettingView(),
      middlewares: [AuthMiddleware()],
      transition: Transition.noTransition,
    ),
    GetPage(
      name: newGroup,
      binding: GroupBinding(),
      page: () => GroupAddView(),
      middlewares: [AuthMiddleware()],
      transition: Transition.noTransition,
    ),
    GetPage(
      name: searchGroup,
      binding: GroupBinding(),
      page: () => GroupSearchView(),
      middlewares: [AuthMiddleware()],
      transition: Transition.noTransition,
    ),
    GetPage(
      name: newRepo,
      binding: HomeBinding(),
      page: () => HomeAddRepoView(),
      middlewares: [AuthMiddleware()],
    )
  ];
}
