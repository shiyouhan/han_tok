// ignore_for_file: avoid_print, depend_on_referenced_packages, unnecessary_overrides

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../main.dart';
import '../../login/controllers/login_bottom_controller.dart';

class InfoDescController extends GetxController {
  LoginBottomController loginController = Get.put(LoginBottomController());
  TextEditingController descController = TextEditingController();

  final isChange = false.obs;

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

  void descStr(value) => {
        loginController.description.value = value,
        if (descController.text.isNotEmpty)
          {
            isChange.value = true,
          }
        else
          isChange.value = false,
      };

  //TODO:修改简介
  modify() async {
    var prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('userToken')!;
    String id = prefs.getString('id')!;

    Map<String, dynamic> headers = {
      "headerUserId": id,
      "headerUserToken": token,
    };
    Map<String, dynamic> data = {
      "id": id,
      "description": descController.text,
    };
    request
        .post('/userInfo/modifyUserInfo?type=7', headers: headers, data: data)
        .then((value) {
      print(value);
      Get.back();
      EasyLoading.showToast('设置成功');
    }).catchError((error) {
      EasyLoading.showError('数据解析异常');
      print(error);
    });
  }
}
