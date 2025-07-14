import 'package:get/get.dart';

import '../controllers/home_controller.dart';
import '../services/api_service.dart';
import '../services/token_service.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ApiService>(() => ApiService(), fenix: true);
    Get.lazyPut<TokenService>(() => TokenService(), fenix: true);
    Get.lazyPut<HomeController>(() => HomeController(
      apiService: Get.find<ApiService>(),
      tokenService: Get.find<TokenService>(),
    ), fenix: true);
  }
}