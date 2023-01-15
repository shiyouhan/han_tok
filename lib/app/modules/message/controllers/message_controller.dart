// ignore_for_file: depend_on_referenced_packages, avoid_print, unnecessary_overrides

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../main.dart';
import '../../mine/model/Follow.dart';

class MessageController extends GetxController {
  var followList = [].obs;
  final page = 1.obs;
  final pageSize = 99.obs;
  final isShow = false.obs;

  PageController? pageController;
  var currentPage = 0.obs;

  @override
  void onInit() async {
    followList.value = await getFollowList();
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

  void show() => isShow.value = true;
  void leave() => isShow.value = false;
  void change(index) => currentPage.value = index;

  //TODO:获取我的关注列表
  Future<List> getFollowList() async {
    var prefs = await SharedPreferences.getInstance();
    String id = prefs.getString('id')!;
    var result = await request.get(
        '/fans/queryMyFollows?myId=$id&page=${page.value}&pageSize=${pageSize.value}');
    print(result);
    return result['rows'];
  }
}
