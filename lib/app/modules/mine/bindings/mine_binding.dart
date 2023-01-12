import 'package:get/get.dart';

import 'package:han_tok/app/modules/mine/controllers/account_code_controller.dart';
import 'package:han_tok/app/modules/mine/controllers/account_device_controller.dart';
import 'package:han_tok/app/modules/mine/controllers/account_password_controller.dart';
import 'package:han_tok/app/modules/mine/controllers/composition_controller.dart';
import 'package:han_tok/app/modules/mine/controllers/info_desc_controller.dart';
import 'package:han_tok/app/modules/mine/controllers/info_location_controller.dart';
import 'package:han_tok/app/modules/mine/controllers/info_nickname_controller.dart';
import 'package:han_tok/app/modules/mine/controllers/info_num_controller.dart';
import 'package:han_tok/app/modules/mine/controllers/like_controller.dart';
import 'package:han_tok/app/modules/mine/controllers/mine_info_controller.dart';
import 'package:han_tok/app/modules/mine/controllers/private_controller.dart';
import 'package:han_tok/app/modules/mine/controllers/visit_controller.dart';

import '../controllers/mine_controller.dart';

class MineBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<LikeController>(
      () => LikeController(),
    );
    Get.lazyPut<PrivateController>(
      () => PrivateController(),
    );
    Get.lazyPut<CompositionController>(
      () => CompositionController(),
    );
    Get.lazyPut<AccountDeviceController>(
      () => AccountDeviceController(),
    );
    Get.lazyPut<AccountCodeController>(
      () => AccountCodeController(),
    );
    Get.lazyPut<AccountPasswordController>(
      () => AccountPasswordController(),
    );
    Get.lazyPut<VisitController>(
      () => VisitController(),
    );
    Get.lazyPut<InfoNumController>(
      () => InfoNumController(),
    );
    Get.lazyPut<InfoDescController>(
      () => InfoDescController(),
    );
    Get.lazyPut<InfoNicknameController>(
      () => InfoNicknameController(),
    );
    Get.lazyPut<InfoLocationController>(
      () => InfoLocationController(),
    );
    Get.lazyPut<MineInfoController>(
      () => MineInfoController(),
    );
    Get.lazyPut<MineController>(
      () => MineController(),
    );
  }
}
