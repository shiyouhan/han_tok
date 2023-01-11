// ignore_for_file: unnecessary_overrides

import 'package:get/get.dart';

class VisitController extends GetxController {
  var isShow = false.obs;

  @override
  void onInit() {
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

  void visitSwitch() {
    if (isShow.value) {
      isShow.value = !isShow.value;
      // isShow.value = true;
    } else {
      isShow.value = !isShow.value;
      // isShow.value = false;
    }
  }
}
