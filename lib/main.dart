import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gitpumta/routes/app_route.dart';

import '../services/auth_service.dart';
import '../services/token_service.dart';

import 'bindings/auth_binding.dart';
import 'controllers/auth_controller.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  Get.put(TokenService(), permanent: true);
  Get.put(AuthService(), permanent: true);
  Get.put(AuthController(authService: Get.find(), tokenService: Get.find()), permanent: true);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: AppRoutes.splash,
      getPages: AppRoutes.routes,
      initialBinding: AuthBinding(),
    );
  }
}
