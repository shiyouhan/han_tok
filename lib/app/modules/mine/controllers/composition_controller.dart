// ignore_for_file: depend_on_referenced_packages, avoid_print, unnecessary_overrides

import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../main.dart';
import '../model/Video.dart';

class CompositionController extends GetxController {
  final vlogId = ''.obs;
  final likeCounts = 0.obs;

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

  //todo:获取视频详情
  getDetail(String vlogId) async {
    var prefs = await SharedPreferences.getInstance();
    String id = prefs.getString('id')!;

    request.get('/vlog/detail?userId=$id&vlogId=$vlogId').then((value) async {
      // videoController.doILikeThisVlog.value =
      //     Video.fromJson(value).doILikeThisVlog;
      likeCounts.value = Video.fromJson(value).likeCounts;
      print(value);
    }).catchError((error) {
      EasyLoading.showError('数据解析异常');
      print(error);
    });
  }
}
