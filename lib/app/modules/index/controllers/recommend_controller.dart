// ignore_for_file: unnecessary_overrides

import 'package:get/get.dart';
import 'package:han_tok/app/modules/index/model/IndexList.dart';

import '../../../../main.dart';

class RecommendController extends GetxController {
  final page = 1.obs;
  final pageSize = 99.obs;
  var videoList = [].obs;

  @override
  void onInit() async {
    videoList.value = await getVideo();
    videoList.value =
        videoList.map((element) => IndexList.fromJson(element)).toList();
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

  //TODO:获取首页视频列表
  Future<List> getVideo() async {
    var result = await request
        .get('/vlog/indexList?page=${page.value}&pageSize=${pageSize.value}');
    videoList.value = result['rows'];
    print(result);
    return result['rows'];
  }
}
