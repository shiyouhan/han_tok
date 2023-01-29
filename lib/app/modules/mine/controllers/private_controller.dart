// ignore_for_file: depend_on_referenced_packages, avoid_print, unnecessary_overrides

import 'package:get/get.dart';

import 'mine_controller.dart';

class PrivateController extends GetxController {
  MineController mineController = Get.put(MineController());

  var privatePraised = 0.obs;

  @override
  void onInit() async {
    for (var element in mineController.privateList) {
      privatePraised += element.likeCounts;
    }
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
}
