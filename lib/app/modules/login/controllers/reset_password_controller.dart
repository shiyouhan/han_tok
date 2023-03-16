// ignore_for_file: unnecessary_overrides, avoid_print, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:han_tok/app/modules/login/controllers/login_bottom_controller.dart';
import 'package:han_tok/app/modules/login/views/login_password_view.dart';

import '../../../../main.dart';

class ResetPasswordController extends GetxController {
  LoginBottomController loginController = Get.put(LoginBottomController());
  var codeController = TextEditingController().obs;
  var passwordController = TextEditingController().obs;

  final code = ''.obs;
  final password = ''.obs;
  final isSelected = false.obs;

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

  void radioSelect(value) => isSelected.value = true;
  void codeNumber(value) => code.value = value;
  void passwordNumber(value) => password.value = value;

  //todo:发送验证码
  getVerify() async {
    if (loginController.phoneController1.value.text.isNotEmpty) {
      await request
          .post(
              '/passport/getSMSCode?type=2&mobile=${loginController.phoneController1.value.text}')
          .then((value) {
        print(value);
      }).catchError((error) {
        EasyLoading.showError('数据解析异常');
        print(error);
      });
    }
  }

  //todo:重置密码
  resetPassword() async {
    Map<String, dynamic> data = {
      "mobile": loginController.phoneController1.value.text,
      "password": passwordController.value.text,
      "smsCode": codeController.value.text
    };
    request.post('/passport/restPassword', data: data).then((value) async {
      print(value);
      Get.to(() => LoginPasswordView());
    }).catchError((error) {
      EasyLoading.showError('数据解析异常');
      print(error);
    });
  }
}
