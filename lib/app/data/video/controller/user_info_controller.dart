// ignore_for_file: depend_on_referenced_packages, unnecessary_overrides, avoid_print

import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';

import '../../../../main.dart';
import '../../../modules/index/model/User.dart';
import '../../../modules/mine/model/LikeList.dart';
import '../../../modules/mine/model/PublicList.dart';
import '../../../utils/BirthUtil.dart';

class UserInfoController extends GetxController {
  final vlogerId = ''.obs;
  final followed = false.obs;

  final page = 1.obs;
  final pageSize = 99.obs;
  var publicList = [].obs;
  var likeList = [].obs;

  final id = ''.obs;
  final nickname = ''.obs;
  final hantokNum = ''.obs;
  final avatar = 'http://img.syhan.top/uPic/grey.jpg'.obs;
  final sex = 3.obs;
  final birthday = ''.obs;
  final province = ''.obs;
  final bg = 'http://img.syhan.top/uPic/grey.jpg'.obs;
  final description = ''.obs;

  var year = 2000.obs;
  var month = 12.obs;
  var day = 12.obs;
  var age = ''.obs;

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

  void follow() {
    followed.value = true;
  }

  void cancelFollow() {
    followed.value = false;
  }

  //TODO:获取用户信息
  query() async {
    request.get('/userInfo/query?userId=${vlogerId.value}').then((value) async {
      nickname.value = User.fromJson(value).nickname;
      hantokNum.value = User.fromJson(value).hantokNum;
      avatar.value = User.fromJson(value).avatar;
      sex.value = User.fromJson(value).sex;
      birthday.value = User.fromJson(value).birthday;
      province.value = User.fromJson(value).province;
      description.value = User.fromJson(value).description;
      bg.value = User.fromJson(value).bg;
      year.value = int.parse(birthday.value.substring(0, 4));
      month.value = int.parse(birthday.value.substring(6, 7));
      day.value = int.parse(birthday.value.substring(9, 10));
      late DateTime brt = DateTime(year.value, month.value, day.value);
      age.value = BirthUtil.getAge(brt);
      publicList.value = await getPublic();
      publicList.value =
          publicList.map((element) => PublicList.fromJson(element)).toList();
      likeList.value = await getLike();
      likeList.value =
          likeList.map((element) => LikeList.fromJson(element)).toList();
      print(value);
    }).catchError((error) {
      EasyLoading.showError('数据解析异常');
      print(error);
    });
  }

  //TODO:获取作品列表
  Future<List> getPublic() async {
    var result = await request.get(
        '/vlog/myPublicList?userId=${vlogerId.value}&page=${page.value}&pageSize=${pageSize.value}');
    print(result);
    return result['rows'];
  }

  //TODO:获取喜欢列表
  Future<List> getLike() async {
    var result = await request.get(
        '/vlog/myLikedList?userId=${vlogerId.value}&page=${page.value}&pageSize=${pageSize.value}');
    print(result);
    return result['rows'];
  }
}
