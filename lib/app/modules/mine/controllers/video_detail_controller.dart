// ignore_for_file: depend_on_referenced_packages

import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../main.dart';
import '../model/Video.dart';

class VideoDetailController extends GetxController {
  final vlogId = ''.obs;
  final vlogerFace = 'http://img.syhan.top/uPic/grey.jpg'.obs;
  final vlogerName = ''.obs;
  final content = ''.obs;
  final url = ''.obs;
  final likeCounts = 0.obs;
  final commentsCounts = 0.obs;
  final isPrivate = 0.obs;

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
      vlogId.value = Video.fromJson(value).vlogId;
      vlogerFace.value = Video.fromJson(value).vlogerFace;
      vlogerName.value = Video.fromJson(value).vlogerName;
      content.value = Video.fromJson(value).content;
      likeCounts.value = Video.fromJson(value).likeCounts;
      commentsCounts.value = Video.fromJson(value).commentsCounts;
      isPrivate.value = Video.fromJson(value).isPrivate;
      print(value);
    }).catchError((error) {
      EasyLoading.showError('数据解析异常');
      print(error);
    });
  }
}
