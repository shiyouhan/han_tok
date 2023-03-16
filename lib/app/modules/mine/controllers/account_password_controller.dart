// ignore_for_file: unnecessary_overrides, prefer_const_constructors, avoid_print

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';

import '../../../../main.dart';
import '../../login/controllers/login_bottom_controller.dart';
import '../views/setting/account/account_code_view.dart';

class AccountPasswordController extends GetxController {
  LoginBottomController loginController = Get.put(LoginBottomController());
  TextEditingController passwordController = TextEditingController();
  final number = 0.obs;
  final code = ''.obs;

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

  void passwordStr(value) => {
        number.value = passwordController.text.length,
        loginController.password.value = value,
      };

  //TODO:发送验证码
  getVerify() async {
    if (passwordController.value.text.isNotEmpty) {
      await request
          .post('/passport/getSMSCode?type=2&mobile=${loginController.mobile.value}')
          .then((value) {
        code.value = value;
        print(value);
        Get.to(() => AccountCodeView());
      }).catchError((error) {
        EasyLoading.showError('数据解析异常');
        print(error);
      });
    }
  }
}
