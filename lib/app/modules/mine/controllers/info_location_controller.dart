// ignore_for_file: depend_on_referenced_packages, unnecessary_overrides, avoid_print

import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../main.dart';
import '../../login/controllers/login_bottom_controller.dart';

class InfoLocationController extends GetxController {
  LoginBottomController loginController = Get.put(LoginBottomController());

  final country = ''.obs;
  final province = 'XX省'.obs;
  final city = 'XX市'.obs;
  final district = ''.obs;
  final location = ''.obs;
  final isSet = true.obs;
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

  void cleanLocation() => {
        isSet.value = false,
        loginController.country.value = '',
        loginController.province.value = '',
        loginController.city.value = '',
        loginController.district.value = '',
        loginController.location.value =
            '${loginController.country.value}-${loginController.province.value}-${loginController.city.value}-${loginController.district.value}',
        modifyNull(),
      };

  void nowLocation() => {
        isSet.value = true,
        loginController.location.value =
            '${country.value}-${province.value}-${city.value}-${district.value}',
        modify(),
      };

  //TODO:修改地区-清空地址
  modifyNull() async {
    var prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('userToken')!;
    String id = prefs.getString('id')!;

    Map<String, dynamic> headers = {
      "headerUserId": id,
      "headerUserToken": token,
    };
    Map<String, dynamic> data = {
      "id": id,
      "country": loginController.country.value,
      "province": loginController.province.value,
      "city": loginController.city.value,
      "district": loginController.district.value,
    };
    request
        .post('/userInfo/modifyUserInfo?type=6', headers: headers, data: data)
        .then((value) {
      loginController.location.value =
          '中国-${loginController.province.value}-${loginController.city.value}-${loginController.district.value}';
      print(value);
      Get.back();
      EasyLoading.showToast('设置成功');
    }).catchError((error) {
      EasyLoading.showError('数据解析异常');
      print(error);
    });
  }

  //TODO:修改地区-当前定位
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
      "country": country.value,
      "province": province.value,
      "city": city.value,
      "district": district.value,
    };
    request
        .post('/userInfo/modifyUserInfo?type=6', headers: headers, data: data)
        .then((value) {
      print(value);
      loginController.query();
      Get.back();
      EasyLoading.showToast('设置成功');
    }).catchError((error) {
      EasyLoading.showError('数据解析异常');
      print(error);
    });
  }

  //TODO:修改地区-省市区
  modifyLoc() async {
    isChange.value = true;
    loginController.country.value = '中国';
    var prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('userToken')!;
    String id = prefs.getString('id')!;

    Map<String, dynamic> headers = {
      "headerUserId": id,
      "headerUserToken": token,
    };
    Map<String, dynamic> data = {
      "id": id,
      "country": loginController.country.value,
      "province": loginController.province.value,
      "city": loginController.city.value,
      "district": loginController.district.value,
    };
    request
        .post('/userInfo/modifyUserInfo?type=6', headers: headers, data: data)
        .then((value) {
      loginController.location.value =
          '中国-${loginController.province.value}-${loginController.city.value}-${loginController.district.value}';
      print(value);
      Get.back();
      EasyLoading.showToast('设置成功');
    }).catchError((error) {
      EasyLoading.showError('数据解析异常');
      print(error);
    });
  }
}
