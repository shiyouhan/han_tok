// ignore_for_file: depend_on_referenced_packages, unnecessary_overrides, avoid_print

import 'package:get/get.dart';
import 'package:han_tok/app/modules/mine/model/Follow.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../../main.dart';
import '../../../modules/index/controllers/follow_controller.dart';

class VideoController extends GetxController {
  FollowController followController = Get.put(FollowController());

  @override
  void onInit() async {
    followList.value = await getVideo();
    followList.value =
        followList.map((element) => Follow.fromJson(element)).toList();
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

  var followList = [].obs;
  final page = 1.obs;
  final pageSize = 99.obs;

  final followed = false.obs;
  final isMine = false.obs;

  final doILikeThisVlog = false.obs;
  final likeCounts = 0.obs;

  void renew() async {
    followList.value = await getVideo();
    followList.value =
        followList.map((element) => Follow.fromJson(element)).toList();
    followController.follow();
    update();
  }

  Future<List> getVideo() async {
    var prefs = await SharedPreferences.getInstance();
    String id = prefs.getString('id')!;
    var result = await request.get(
        '/fans/queryMyFollows?myId=$id&page=${page.value}&pageSize=${pageSize.value}');
    print(result);
    return result['rows'];
  }
}
