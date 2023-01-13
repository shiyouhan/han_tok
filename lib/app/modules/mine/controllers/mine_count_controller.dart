import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MineCountController extends GetxController
    with GetSingleTickerProviderStateMixin {
  final select = 0.obs;
  final currentIndex = 0.obs;

  final tabs = ['朋友', '关注', '粉丝'];

  late TabController tabController;

  @override
  void onInit() {
    super.onInit();
    tabController = TabController(
        initialIndex: currentIndex.value, length: tabs.length, vsync: this);
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  void friend() => currentIndex.value = 0;
  void follow() => currentIndex.value = 1;
  void fan() => currentIndex.value = 2;
}
