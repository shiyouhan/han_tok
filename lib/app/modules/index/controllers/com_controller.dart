// ignore_for_file: depend_on_referenced_packages, unnecessary_overrides, avoid_print

import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../main.dart';
import '../model/FollowList.dart';

class ComController extends GetxController {
  final page = 1.obs;
  final pageSize = 99.obs;
  var friendList = [].obs;

  @override
  void onInit() async {
    friend();
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

  void friend() async => {
        friendList.value = await getVideo(),
        friendList.value =
            friendList.map((element) => FollowList.fromJson(element)).toList(),
      };

  //TODO:获取首页视频列表
  Future<List> getVideo() async {
    var prefs = await SharedPreferences.getInstance();
    String id = prefs.getString('id')!;

    var result = await request.get(
        '/vlog/friendList?page=${page.value}&pageSize=${pageSize.value}&myId=$id');
    print(result);
    return result['rows'];
  }
}
