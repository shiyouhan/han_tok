// ignore_for_file: depend_on_referenced_packages, avoid_print, unnecessary_overrides

import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../main.dart';
import '../model/PublicList.dart';

class PrivateController extends GetxController {
  var privateList = [].obs;
  final page = 1.obs;
  final pageSize = 99.obs;

  @override
  void onInit() async {
    privateList.value = await getVideo();
    privateList.value =
        privateList.map((element) => PublicList.fromJson(element)).toList();
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

  //TODO:获取私有列表
  Future<List> getVideo() async {
    var prefs = await SharedPreferences.getInstance();
    String id = prefs.getString('id')!;
    var result = await request.get(
        '/vlog/myPrivateList?userId=$id&page=${page.value}&pageSize=${pageSize.value}');
    print(result);
    return result['rows'];
  }
}
