import 'package:get/get.dart';

import '../controllers/auth_controller.dart';
import '../services/auth_service.dart';
import '../services/token_service.dart';

class AuthBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => AuthService());
    Get.lazyPut(() => TokenService());
    Get.put(() => AuthController(authService: Get.find(), tokenService: Get.find()), permanent: true);
  }
}