// ignore_for_file: unnecessary_overrides, depend_on_referenced_packages, avoid_print

import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../main.dart';
import '../../login/controllers/login_bottom_controller.dart';

class MineInfoController extends GetxController {
  LoginBottomController loginController = Get.put(LoginBottomController());

  final avatar = 'http://img.syhan.top/uPic/avatar.JPG'.obs;
  final bg = 'http://img.syhan.top/uPic/youhua.jpeg'.obs;
  final sex = 3.obs;
  final birth = ''.obs;
  final age = ''.obs;

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

  void selectM() => {loginController.sex.value = 1, modifySex()};
  void selectF() => {loginController.sex.value = 0, modifySex()};
  void selectS() => {loginController.sex.value = 2, modifySex()};

  //TODO:修改性别
  modifySex() async {
    var prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('userToken')!;
    String id = prefs.getString('id')!;

    Map<String, dynamic> headers = {
      "headerUserId": id,
      "headerUserToken": token,
    };
    Map<String, dynamic> data = {
      "id": id,
      "sex": loginController.sex.value,
    };
    request
        .post('/userInfo/modifyUserInfo?type=4', headers: headers, data: data)
        .then((value) {
      print(value);
      Get.back();
      EasyLoading.showToast('设置成功');
    }).catchError((error) {
      EasyLoading.showError('数据解析异常');
      print(error);
    });
  }

  //TODO:修改生日
  modifyBirth() async {
    var prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('userToken')!;
    String id = prefs.getString('id')!;

    Map<String, dynamic> headers = {
      "headerUserId": id,
      "headerUserToken": token,
    };
    Map<String, dynamic> data = {
      "id": id,
      "birthday": loginController.birthday.value,
    };
    request
        .post('/userInfo/modifyUserInfo?type=5', headers: headers, data: data)
        .then((value) {
      print(value);
      EasyLoading.showToast('设置成功');
    }).catchError((error) {
      EasyLoading.showError('数据解析异常');
      print(error);
    });
  }
}
