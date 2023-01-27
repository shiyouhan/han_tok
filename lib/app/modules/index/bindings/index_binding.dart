import 'package:get/get.dart';

import 'package:han_tok/app/modules/index/controllers/follow_controller.dart';
import 'package:han_tok/app/modules/index/controllers/info_like_controller.dart';
import 'package:han_tok/app/modules/index/controllers/info_opus_controller.dart';
import 'package:han_tok/app/modules/index/controllers/like_detail_controller.dart';
import 'package:han_tok/app/modules/index/controllers/opus_detail_controller.dart';
import 'package:han_tok/app/modules/index/controllers/recommend_controller.dart';

import '../controllers/index_controller.dart';

class IndexBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<FollowController>(
      () => FollowController(),
    );
    Get.lazyPut<LikeDetailController>(
      () => LikeDetailController(),
    );
    Get.lazyPut<OpusDetailController>(
      () => OpusDetailController(),
    );
    Get.lazyPut<InfoOpusController>(
      () => InfoOpusController(),
    );
    Get.lazyPut<InfoLikeController>(
      () => InfoLikeController(),
    );
    Get.lazyPut<RecommendController>(
      () => RecommendController(),
    );
    Get.lazyPut<IndexController>(
      () => IndexController(),
    );
  }
}
