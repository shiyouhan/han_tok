// ignore_for_file: depend_on_referenced_packages, unnecessary_overrides, avoid_print

import 'package:get/get.dart';

class MineFollowController extends GetxController {
  final followed = true.obs;

  @override
  void onInit() async {
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

  void follow() => followed.value == true;
  void unFollow() => followed.value == false;
}
