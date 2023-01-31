// ignore_for_file: avoid_print, unnecessary_overrides, depend_on_referenced_packages

import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../main.dart';
import '../model/FollowList.dart';

class FollowController extends GetxController {
  final page = 1.obs;
  final pageSize = 99.obs;
  var followList = [].obs;

  @override
  void onInit() async {
    follow();
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

  void follow() async => {
        followList.value = await getVideo(),
        followList.value =
            followList.map((element) => FollowList.fromJson(element)).toList(),
      };

  //TODO:获取首页视频列表
  Future<List> getVideo() async {
    var prefs = await SharedPreferences.getInstance();
    String id = prefs.getString('id')!;

    var result = await request.get(
        '/vlog/followList?page=${page.value}&pageSize=${pageSize.value}&myId=$id');
    print(result);
    return result['rows'];
  }
}
