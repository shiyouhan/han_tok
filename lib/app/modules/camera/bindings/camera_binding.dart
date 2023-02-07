import 'package:get/get.dart';

import 'package:han_tok/app/modules/camera/controllers/camera_detail_controller.dart';

import '../controllers/camera_controller.dart';

class CameraBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CameraDetailController>(
      () => CameraDetailController(),
    );
    Get.lazyPut<CameraViewController>(
      () => CameraViewController(),
    );
  }
}
