// ignore_for_file: unnecessary_overrides

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FriendController extends GetxController {
  final isShow = false.obs;

  PageController? pageController;
  var currentPage = 0.obs;

  @override
  void onInit() {
    super.onInit();
    pageController = PageController();
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
}
