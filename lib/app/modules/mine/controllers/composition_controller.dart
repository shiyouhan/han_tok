// ignore_for_file: depend_on_referenced_packages, avoid_print, unnecessary_overrides

import 'package:get/get.dart';
import 'package:han_tok/app/modules/mine/controllers/mine_controller.dart';
import 'package:han_tok/app/modules/mine/controllers/private_controller.dart';

class CompositionController extends GetxController {
  MineController mineController = Get.put(MineController());
  PrivateController privateController = Get.put(PrivateController());

  var publicPraised = 0.obs;
  var praised = 0.obs;

  @override
  void onInit() async {
    for (var element in mineController.publicList) {
      publicPraised += element.likeCounts;
    }
    praised = privateController.privatePraised + publicPraised.toInt();
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
