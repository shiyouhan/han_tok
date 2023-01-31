// ignore_for_file: unnecessary_overrides, depend_on_referenced_packages, avoid_print

import 'package:get/get.dart';
import 'package:han_tok/app/data/video/controller/video_controller.dart';
import 'package:han_tok/app/modules/index/controllers/com_controller.dart';
import 'package:han_tok/app/modules/index/controllers/follow_controller.dart';
import 'package:han_tok/app/modules/login/controllers/login_bottom_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../main.dart';
import '../model/Fan.dart';
import '../model/LikeList.dart';
import '../model/PublicList.dart';

class MineController extends GetxController {
  var loginController = Get.find<LoginBottomController>();
  VideoController videoController = Get.put(VideoController());
  ComController comController = Get.put(ComController());

  final city = ''.obs;
  final page = 1.obs;
  final pageSize = 99.obs;
  var praised = 0.obs;

  var publicList = [].obs;
  var privateList = [].obs;
  var likeList = [].obs;

  var fanList = [].obs;
  var followList = [].obs;

  @override
  void onInit() async {
    publicList.value = await getPublic();
    publicList.value =
        publicList.map((element) => PublicList.fromJson(element)).toList();
    likeList.value = await getLike();
    likeList.value =
        likeList.map((element) => LikeList.fromJson(element)).toList();
    privateList.value = await getPrivate();
    privateList.value =
        privateList.map((element) => PublicList.fromJson(element)).toList();
    fanList.value = await getFanList();
    fanList.value = fanList.map((element) => Fan.fromJson(element)).toList();
    super.onInit();
  }

  @override
  void onReady() async {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  void renewFans() async {
    fanList.value = await getFanList();
    fanList.value = fanList.map((element) => Fan.fromJson(element)).toList();
    comController.friend();
    update();
  }

  void renewLike() async {
    likeList.value = await getLike();
    likeList.value =
        likeList.map((element) => LikeList.fromJson(element)).toList();
    update();
  }

  //TODO:获取作品列表
  Future<List> getPublic() async {
    var prefs = await SharedPreferences.getInstance();
    String id = prefs.getString('id')!;
    var result = await request.get(
        '/vlog/myPublicList?userId=$id&page=${page.value}&pageSize=${pageSize.value}');
    print(result);
    return result['rows'];
  }

  //TODO:获取私有列表
  Future<List> getPrivate() async {
    var prefs = await SharedPreferences.getInstance();
    String id = prefs.getString('id')!;
    var result = await request.get(
        '/vlog/myPrivateList?userId=$id&page=${page.value}&pageSize=${pageSize.value}');
    print(result);
    return result['rows'];
  }

  //TODO:获取喜欢列表
  Future<List> getLike() async {
    var prefs = await SharedPreferences.getInstance();
    String id = prefs.getString('id')!;
    var result = await request.get(
        '/vlog/myLikedList?userId=$id&page=${page.value}&pageSize=${pageSize.value}');
    print(result);
    return result['rows'];
  }

  //TODO:获取我的粉丝列表
  Future<List> getFanList() async {
    var prefs = await SharedPreferences.getInstance();
    String id = prefs.getString('id')!;
    var result = await request.get(
        '/fans/queryMyFans?myId=$id&page=${page.value}&pageSize=${pageSize.value}');
    print(result);
    return result['rows'];
  }

  //TODO:获取我的关注列表
  Future<List> getFollowList() async {
    var prefs = await SharedPreferences.getInstance();
    String id = prefs.getString('id')!;
    var result = await request.get(
        '/fans/queryMyFollows?myId=$id&page=${page.value}&pageSize=${pageSize.value}');
    print(result);
    return result['rows'];
  }
}
