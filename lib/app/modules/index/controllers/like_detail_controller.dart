// ignore_for_file: avoid_print, unnecessary_overrides, depend_on_referenced_packages

import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:get/get.dart';

import '../../../../main.dart';
import '../../../data/video/controller/video_controller.dart';
import '../../mine/controllers/mine_controller.dart';
import '../../mine/model/Vlog.dart';

class LikeDetailController extends GetxController {
  MineController mineController = Get.put(MineController());
  VideoController videoController = Get.put(VideoController());

  final vlogId = ''.obs;
  final vlogerId = ''.obs;
  final vlogerFace = 'http://img.syhan.top/uPic/grey.jpg'.obs;
  final vlogerName = ''.obs;
  final content = ''.obs;
  final url = ''.obs;
  final likeCounts = 0.obs;
  final commentsCounts = 0.obs;
  final doIFollowVloger = false.obs;
  final doILikeThisVlog = false.obs;

  final isMine = false.obs;

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

  //todo:获取视频详情
  getDetail() async {
    var prefs = await SharedPreferences.getInstance();
    String id = prefs.getString('id')!;

    request
        .get('/vlog/detail?userId=$id&vlogId=${vlogId.value}')
        .then((value) async {
      vlogerName.value = Vlog.fromJson(value).vlogerName;
      vlogerFace.value = Vlog.fromJson(value).vlogerFace;
      content.value = Vlog.fromJson(value).content;
      likeCounts.value = Vlog.fromJson(value).likeCounts;
      commentsCounts.value = Vlog.fromJson(value).commentsCounts;
      doIFollowVloger.value = Vlog.fromJson(value).doIFollowVloger;
      doILikeThisVlog.value = Vlog.fromJson(value).doILikeThisVlog;
      print(value);
    }).catchError((error) {
      EasyLoading.showError('数据解析异常');
      print(error);
    });
  }

  //TODO:关注用户
  follow() async {
    var prefs = await SharedPreferences.getInstance();
    String id = prefs.getString('id')!;
    String token = prefs.getString('userToken')!;

    Map<String, dynamic> headers = {
      "headerUserId": id,
      "headerUserToken": token,
    };

    request
        .post('/fans/follow?vlogerId=${vlogerId.value}&myId=$id',
            headers: headers)
        .then((value) async {
      videoController.followed.value = true;
      videoController.renew();
      getDetail();
      print(value);
    }).catchError((error) {
      EasyLoading.showError('数据解析异常');
      print(error);
    });
  }

  //TODO:点赞
  Future<bool> changeData(status) async {
    like();
    return Future.value(!status);
  }

  //TODO:视频点赞
  like() async {
    var prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('userToken')!;
    String id = prefs.getString('id')!;

    Map<String, dynamic> headers = {
      "headerUserId": id,
      "headerUserToken": token,
    };
    request
        .post(
            '/vlog/like?userId=$id&vlogId=${vlogId.value}&vlogerId=${vlogerId.value}',
            headers: headers)
        .then((value) {
      print(value);
      doILikeThisVlog.value = true;
      getDetail();
      mineController.renewLike();
    }).catchError((error) {
      EasyLoading.showError('数据解析异常');
      print(error);
    });
  }

  //TODO:视频取消点赞
  unlike() async {
    var prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('userToken')!;
    String id = prefs.getString('id')!;

    Map<String, dynamic> headers = {
      "headerUserId": id,
      "headerUserToken": token,
    };
    request
        .post(
            '/vlog/unlike?userId=$id&vlogId=${vlogId.value}&vlogerId=${vlogerId.value}',
            headers: headers)
        .then((value) {
      print(value);
      doILikeThisVlog.value = false;
      getDetail();
      mineController.renewLike();
    }).catchError((error) {
      EasyLoading.showError('数据解析异常');
      print(error);
    });
  }
}
