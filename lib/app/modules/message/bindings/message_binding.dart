import 'package:get/get.dart';

import 'package:han_tok/app/modules/message/controllers/message_detail_controller.dart';
import 'package:han_tok/app/modules/message/controllers/message_interact_controller.dart';

import '../controllers/message_controller.dart';

class MessageBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MessageDetailController>(
      () => MessageDetailController(),
    );
    Get.lazyPut<MessageInteractController>(
      () => MessageInteractController(),
    );
    Get.lazyPut<MessageController>(
      () => MessageController(),
    );
  }
}
