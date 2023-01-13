// ignore_for_file: depend_on_referenced_packages, avoid_print, unnecessary_overrides

import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../main.dart';
import '../model/Fan.dart';

class MineFanController extends GetxController {
  var fanList = [].obs;
  final page = 1.obs;
  final pageSize = 99.obs;
  final friend = false.obs;

  @override
  void onInit() async {
    fanList.value = await getFanList();
    fanList.value = fanList.map((element) => Fan.fromJson(element)).toList();
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

  //TODO:获取我的粉丝列表
  Future<List> getFanList() async {
    var prefs = await SharedPreferences.getInstance();
    String id = prefs.getString('id')!;
    var result = await request.get(
        '/fans/queryMyFans?myId=$id&page=${page.value}&pageSize=${pageSize.value}');
    print(result);
    return result['rows'];
  }
}
