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
import 'package:han_tok/app/modules/mine/controllers/mine_count_controller.dart';
import 'package:han_tok/app/modules/mine/controllers/mine_fan_controller.dart';
import 'package:han_tok/app/modules/mine/controllers/mine_follow_controller.dart';
import 'package:han_tok/app/modules/mine/controllers/mine_info_controller.dart';
import 'package:han_tok/app/modules/mine/controllers/privacy_policy_controller.dart';
import 'package:han_tok/app/modules/mine/controllers/private_controller.dart';
import 'package:han_tok/app/modules/mine/controllers/setting_controller.dart';
import 'package:han_tok/app/modules/mine/controllers/user_agree_controller.dart';
import 'package:han_tok/app/modules/mine/controllers/video_detail_controller.dart';
import 'package:han_tok/app/modules/mine/controllers/visit_controller.dart';
import 'package:han_tok/app/modules/mine/controllers/vlog_detail_controller.dart';

import '../controllers/mine_controller.dart';

class MineBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<UserAgreeController>(
      () => UserAgreeController(),
    );
    Get.lazyPut<PrivacyPolicyController>(
      () => PrivacyPolicyController(),
    );
    Get.lazyPut<SettingController>(
      () => SettingController(),
    );
    Get.lazyPut<VlogDetailController>(
      () => VlogDetailController(),
    );
    Get.lazyPut<VideoDetailController>(
      () => VideoDetailController(),
    );
    Get.lazyPut<MineFanController>(
      () => MineFanController(),
    );
    Get.lazyPut<MineFollowController>(
      () => MineFollowController(),
    );
    Get.lazyPut<MineCountController>(
      () => MineCountController(),
    );
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
