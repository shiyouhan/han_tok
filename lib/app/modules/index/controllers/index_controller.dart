import 'package:flutter/material.dart';
import 'package:get/get.dart';

class IndexController extends GetxController
    with GetSingleTickerProviderStateMixin {
  final select = 0.obs;
  final currentIndex = 2.obs;

  final tabs = ['粉丝', '关注', '推荐'];

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
}
