import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';

import '../../../../main.dart';
import '../../mine/model/Vlog.dart';

class OpusDetailController extends GetxController {
  final vlogId = ''.obs;
  final vlogerId = ''.obs;
  final vlogerFace = 'http://img.syhan.top/uPic/grey.jpg'.obs;
  final vlogerName = ''.obs;
  final content = ''.obs;
  final url = ''.obs;
  final likeCounts = 0.obs;
  final commentsCounts = 0.obs;
  final province = ''.obs;
  final updatedTime = ''.obs;

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

  //todo:获取视频详情
  getDetail() async {
    request
        .get('/vlog/detail?userId=${vlogerId.value}&vlogId=${vlogId.value}')
        .then((value) async {
      vlogerName.value = Vlog.fromJson(value).vlogerName;
      vlogerFace.value = Vlog.fromJson(value).vlogerFace;
      content.value = Vlog.fromJson(value).content;
      likeCounts.value = Vlog.fromJson(value).likeCounts;
      commentsCounts.value = Vlog.fromJson(value).commentsCounts;
      print(value);
    }).catchError((error) {
      EasyLoading.showError('数据解析异常');
      print(error);
    });
  }

//todo:获取用户信息
// query() async {
//   request.get('/userInfo/query?userId=${vlogerId.value}').then((value) async {
//     vlogerName.value = User.fromJson(value).nickname;
//     vlogerFace.value = User.fromJson(value).avatar;
//     province.value = User.fromJson(value).province;
//     print(value);
//   }).catchError((error) {
//     EasyLoading.showError('数据解析异常');
//     print(error);
//   });
// }
}