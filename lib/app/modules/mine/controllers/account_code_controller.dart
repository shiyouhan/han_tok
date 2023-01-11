// ignore_for_file: prefer_const_constructors, avoid_print, depend_on_referenced_packages, unnecessary_overrides

import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:get/get.dart';

import '../../../../main.dart';
import '../../login/controllers/login_bottom_controller.dart';
import '../views/setting/account/account_security_view.dart';
import 'account_password_controller.dart';

class AccountCodeController extends GetxController {
  LoginBottomController loginController = Get.put(LoginBottomController());
  AccountPasswordController passController =
      Get.put(AccountPasswordController());
  TextEditingController codeController = TextEditingController();
  final code = ''.obs;
  final number = 0.obs;

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

  void codeStr(value) => {
        number.value = codeController.text.length,
        code.value = value,
      };

  void resetPass() => {
        if (codeController.text == passController.code.value)
          {
            modifyPassword(),
          }
        else
          {
            EasyLoading.showToast('验证码不正确'),
          }
      };

  //TODO:修改密码
  modifyPassword() async {
    var prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('userToken')!;
    String id = prefs.getString('id')!;

    Map<String, dynamic> headers = {
      "headerUserId": id,
      "headerUserToken": token,
    };
    Map<String, dynamic> data = {
      "id": id,
      "password": md5
          .convert(utf8.encode(passController.passwordController.text))
          .toString(),
    };
    request
        .post('/userInfo/modifyUserInfo?type=1', headers: headers, data: data)
        .then((value) {
      print(value);
      loginController.query();
      Get.to(() => AccountSecurityView());
      EasyLoading.showToast('设置成功');
    }).catchError((error) {
      EasyLoading.showError('数据解析异常');
      print(error);
    });
  }
}
