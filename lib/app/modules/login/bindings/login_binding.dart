import 'package:get/get.dart';

import 'package:han_tok/app/modules/login/controllers/login_bottom_controller.dart';
import 'package:han_tok/app/modules/login/controllers/reset_password_controller.dart';
import '../controllers/login_controller.dart';

class LoginBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ResetPasswordController>(
      () => ResetPasswordController(),
    );
    Get.lazyPut<LoginBottomController>(
      () => LoginBottomController(),
    );
    Get.lazyPut<LoginController>(
      () => LoginController(),
    );
  }
}
