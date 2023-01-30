// ignore_for_file: depend_on_referenced_packages, unnecessary_overrides, avoid_print

import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:han_tok/app/data/video/controller/video_controller.dart';
import 'package:han_tok/app/modules/mine/controllers/mine_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:get/get.dart';

import '../../../../main.dart';
import '../../../modules/index/model/User.dart';
import '../../../modules/mine/model/Fan.dart';
import '../../../modules/mine/model/Follow.dart';
import '../../../modules/mine/model/LikeList.dart';
import '../../../modules/mine/model/PublicList.dart';
import '../../../utils/BirthUtil.dart';

class UserInfoController extends GetxController {
  MineController mineController = Get.put(MineController());
  VideoController videoController = Get.put(VideoController());
  final vlogerId = ''.obs;
  final isMine = false.obs;

  final page = 1.obs;
  final pageSize = 99.obs;
  var publicList = [].obs;
  var likeList = [].obs;
  var fanList = [].obs;
  var followList = [].obs;

  var publicPraised = 0.obs;

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

  void getFollowAndFan() async => {
        fanList.value = await getFanList(),
        fanList.value =
            fanList.map((element) => Fan.fromJson(element)).toList(),
        followList.value = await getFollowList(),
        followList.value =
            followList.map((element) => Follow.fromJson(element)).toList(),
        publicList.value = await getPublic(),
        publicList.value =
            publicList.map((element) => PublicList.fromJson(element)).toList(),
        likeList.value = await getLike(),
        likeList.value =
            likeList.map((element) => LikeList.fromJson(element)).toList(),
      };

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
      for (var element in publicList) {
        publicPraised += element.likeCounts;
      }
      print(publicPraised);
      print(value);
    }).catchError((error) {
      EasyLoading.showError('数据解析异常');
      print(error);
    });
  }

  //TODO:查看是否关注
  queryFollow() async {
    var prefs = await SharedPreferences.getInstance();
    String id = prefs.getString('id')!;

    if (vlogerId.value == id) {
      isMine.value = true;
    } else {
      isMine.value = false;
      request
          .get('/fans/queryDoIFollowVloger?vlogerId=${vlogerId.value}&myId=$id')
          .then((value) async {
        videoController.followed.value = value;
        print(value);
      }).catchError((error) {
        EasyLoading.showError('数据解析异常');
        print(error);
      });
    }
    update();
  }

  //TODO:关注用户
  follow() async {
    var prefs = await SharedPreferences.getInstance();
    String id = prefs.getString('id')!;
    String token = prefs.getString('userToken')!;

    Map<String, dynamic> headers = {
      "headerUserId": id,
      "headerUserToken": token,
    };

    request
        .post('/fans/follow?vlogerId=${vlogerId.value}&myId=$id',
            headers: headers)
        .then((value) async {
      videoController.followed.value = true;
      print(value);
      videoController.renew();
    }).catchError((error) {
      EasyLoading.showError('数据解析异常');
      print(error);
    });
    update();
  }

  //TODO:取关用户
  cancel() async {
    var prefs = await SharedPreferences.getInstance();
    String id = prefs.getString('id')!;
    String token = prefs.getString('userToken')!;

    Map<String, dynamic> headers = {
      "headerUserId": id,
      "headerUserToken": token,
    };

    request
        .post('/fans/cancel?vlogerId=${vlogerId.value}&myId=$id',
            headers: headers)
        .then((value) async {
      videoController.followed.value = false;
      print(value);
      videoController.renew();
    }).catchError((error) {
      EasyLoading.showError('数据解析异常');
      print(error);
    });
    update();
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

  //TODO:获取用户粉丝列表
  Future<List> getFanList() async {
    var result = await request.get(
        '/fans/queryMyFans?myId=${vlogerId.value}&page=${page.value}&pageSize=${pageSize.value}');
    print(result);
    return result['rows'];
  }

  //TODO:获取用户关注列表
  Future<List> getFollowList() async {
    var result = await request.get(
        '/fans/queryMyFollows?myId=${vlogerId.value}&page=${page.value}&pageSize=${pageSize.value}');
    print(result);
    return result['rows'];
  }
}
