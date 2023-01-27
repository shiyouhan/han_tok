// ignore_for_file: depend_on_referenced_packages, unnecessary_overrides, avoid_print

import 'package:get/get.dart';
import 'package:han_tok/app/modules/mine/model/Follow.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../../main.dart';

class VideoController extends GetxController {
  @override
  void onInit() async {
    fansList.value = await getVideo();
    fansList.value =
        fansList.map((element) => Follow.fromJson(element)).toList();
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

  var fansList = [].obs;
  final page = 1.obs;
  final pageSize = 99.obs;

  final followed = false.obs;
  final isMine = false.obs;

  Future<List> getVideo() async {
    var prefs = await SharedPreferences.getInstance();
    String id = prefs.getString('id')!;
    var result = await request.get(
        '/fans/queryMyFollows?myId=$id&page=${page.value}&pageSize=${pageSize.value}');
    fansList.value = result['rows'];
    print(result);
    return result['rows'];
  }
}
