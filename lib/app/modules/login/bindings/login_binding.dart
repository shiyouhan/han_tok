import 'package:get/get.dart';

import 'package:han_tok/app/modules/login/controllers/login_bottom_controller.dart';

import '../controllers/login_controller.dart';

class LoginBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<LoginBottomController>(
      () => LoginBottomController(),
    );
    Get.lazyPut<LoginController>(
      () => LoginController(),
    );
  }
}
