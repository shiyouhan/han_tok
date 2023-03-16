// ignore_for_file: avoid_print, depend_on_referenced_packages, unnecessary_overrides

import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:get/get.dart';
import 'package:han_tok/app/modules/login/controllers/login_bottom_controller.dart';

import '../../../../main.dart';

class SettingController extends GetxController {
  LoginBottomController loginController = Get.put(LoginBottomController());
  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  //todo:退出登录
  logOut() async {
    await request
        .post('/passport/logout?userId=${loginController.id.value}')
        .then((value) async {
      var prefs = await SharedPreferences.getInstance();
      prefs.remove('id');
      prefs.remove('userToken');
    }).catchError((error) {
      EasyLoading.showError('数据解析异常');
      print(error);
    });
  }
}
