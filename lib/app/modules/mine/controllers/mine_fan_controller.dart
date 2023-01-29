// ignore_for_file: depend_on_referenced_packages, avoid_print, unnecessary_overrides

import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:han_tok/app/data/video/controller/video_controller.dart';
import 'package:han_tok/app/modules/mine/controllers/mine_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../main.dart';

class MineFanController extends GetxController {
  MineController mineController = Get.put(MineController());
  VideoController videoController = Get.put(VideoController());

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

  //TODO:关注用户
  follow(String fanId) async {
    var prefs = await SharedPreferences.getInstance();
    String id = prefs.getString('id')!;
    String token = prefs.getString('userToken')!;

    Map<String, dynamic> headers = {
      "headerUserId": id,
      "headerUserToken": token,
    };

    request
        .post('/fans/follow?vlogerId=$fanId&myId=$id', headers: headers)
        .then((value) async {
      print(value);
      mineController.renewFans();
      videoController.renew();
    }).catchError((error) {
      EasyLoading.showError('数据解析异常');
      print(error);
    });
  }

  //TODO:取关用户
  cancel(String fanId) async {
    var prefs = await SharedPreferences.getInstance();
    String id = prefs.getString('id')!;
    String token = prefs.getString('userToken')!;

    Map<String, dynamic> headers = {
      "headerUserId": id,
      "headerUserToken": token,
    };

    request
        .post('/fans/cancel?vlogerId=$fanId&myId=$id', headers: headers)
        .then((value) async {
      print(value);
      mineController.renewFans();
      videoController.renew();
    }).catchError((error) {
      EasyLoading.showError('数据解析异常');
      print(error);
    });
  }
}
