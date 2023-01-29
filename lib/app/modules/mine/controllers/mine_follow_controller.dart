// ignore_for_file: depend_on_referenced_packages, unnecessary_overrides, avoid_print

import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:han_tok/app/data/video/controller/video_controller.dart';

import '../../../../main.dart';
import 'mine_controller.dart';

class MineFollowController extends GetxController {
  VideoController videoController = Get.put(VideoController());
  MineController mineController = Get.put(MineController());

  final followed = true.obs;

  @override
  void onInit() async {
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

  //TODO:取关用户
  cancel(String vlogerId) async {
    var prefs = await SharedPreferences.getInstance();
    String id = prefs.getString('id')!;
    String token = prefs.getString('userToken')!;

    Map<String, dynamic> headers = {
      "headerUserId": id,
      "headerUserToken": token,
    };

    request
        .post('/fans/cancel?vlogerId=$vlogerId&myId=$id', headers: headers)
        .then((value) async {
      print(value);
      videoController.renew();
      mineController.renewFans();
    }).catchError((error) {
      EasyLoading.showError('数据解析异常');
      print(error);
    });
  }

  //TODO:关注用户
  follow(String vlogerId) async {
    var prefs = await SharedPreferences.getInstance();
    String id = prefs.getString('id')!;
    String token = prefs.getString('userToken')!;

    Map<String, dynamic> headers = {
      "headerUserId": id,
      "headerUserToken": token,
    };

    request
        .post('/fans/follow?vlogerId=$vlogerId&myId=$id', headers: headers)
        .then((value) async {
      print(value);
      queryFollow(vlogerId);
    }).catchError((error) {
      EasyLoading.showError('数据解析异常');
      print(error);
    });
  }

  //TODO:查看是否关注
  Future<bool> queryFollow(String vlogerId) async {
    var prefs = await SharedPreferences.getInstance();
    String id = prefs.getString('id')!;

    request
        .get('/fans/queryDoIFollowVloger?vlogerId=$vlogerId&myId=$id')
        .then((value) async {
      followed.value = value;
      print(value);
    }).catchError((error) {
      EasyLoading.showError('数据解析异常');
      print(error);
    });
    return followed.value;
  }
}
