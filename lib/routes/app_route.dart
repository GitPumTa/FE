import 'package:get/get.dart';

import '../middlewares/auth_middleware.dart';

import '../views/setting_github_view.dart';
import '../views/group_search_view.dart';
import '../views/home_add_repo_view.dart';
import '../views/group_view.dart';
import '../views/setting_view.dart';
import '../views/sign_up_view.dart';
import '../views/auto_login_view.dart';
import '../views/group_add_view.dart';
import '../views/home_view.dart';
import '../views/login_view.dart';
import '../views/ranking_view.dart';

import '../bindings/ranking_binding.dart';
import '../bindings/group_binding.dart';
import '../bindings/home_binding.dart';
import '../bindings/setting_binding.dart';

class AppRoutes {
  static const String login = '/login';
  static const String signUp = '/sign_up';
  static const String home = '/home';
  static const String group = '/group';
  static const String newGroup = '/new_group';
  static const String searchGroup = '/search_group';
  static const String newRepo = '/new_repo';
  static const String settings = '/settings';
  static const String statics = '/statics';
  static const String github = '/github';
  static const String splash = '/splash';
  static const String ranking = '/ranking';

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
    GetPage(
      name: signUp,
      page: () => SignUpView(),
      transition: Transition.noTransition,
    ),
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
    ),
    GetPage(
    name: ranking,
    binding: RankingBinding(),
    page: () => RankingView(),
    transition: Transition.noTransition,
  ),
    GetPage(
      name: github,
      binding: SettingBinding(),
      page: () => SettingGithubView(),
      middlewares: [AuthMiddleware()],
    ),
  ];
}
