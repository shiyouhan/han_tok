// ignore_for_file: depend_on_referenced_packages, avoid_print, unnecessary_overrides

import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:han_tok/app/data/video/controller/video_controller.dart';
import 'package:han_tok/app/modules/message/model/MessageOne.dart';
import 'package:han_tok/app/modules/mine/controllers/mine_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../main.dart';
import '../model/MessageFive.dart';
import '../model/MessageFour.dart';
import '../model/MessageThree.dart';
import '../model/MessageTwo.dart';

class MessageInteractController extends GetxController {
  VideoController videoController = Get.put(VideoController());
  MineController mineController = Get.put(MineController());

  final page = 0.obs;
  final pageSize = 99.obs;
  var messageList = [].obs;
  final msgType = 1.obs;

  final vlogerId = ''.obs;

  @override
  void onInit() {
    renewOne();
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

  void renewOne() async => {
        messageList.value = await getMessageOne(),
        messageList.value =
            messageList.map((element) => MessageOne.fromJson(element)).toList(),
      };

  void renewTwo() async => {
        messageList.value = await getMessageTwo(),
        messageList.value =
            messageList.map((element) => MessageTwo.fromJson(element)).toList(),
      };

  void renewThree() async => {
        messageList.value = await getMessageThree(),
        messageList.value = messageList
            .map((element) => MessageThree.fromJson(element))
            .toList(),
      };

  void renewFour() async => {
        messageList.value = await getMessageFour(),
        messageList.value = messageList
            .map((element) => MessageFour.fromJson(element))
            .toList(),
      };

  void renewFive() async => {
        messageList.value = await getMessageFive(),
        messageList.value = messageList
            .map((element) => MessageFive.fromJson(element))
            .toList(),
      };

  //TODO:获取全部关注消息列表
  Future<List> getMessageOne() async {
    var prefs = await SharedPreferences.getInstance();
    String id = prefs.getString('id')!;
    var result = await request.get(
        '/msg/list?page=${page.value}&pageSize=${pageSize.value}&userId=$id&msgType=1');
    return result;
  }

  //TODO:获取全部点赞视频消息列表
  Future<List> getMessageTwo() async {
    var prefs = await SharedPreferences.getInstance();
    String id = prefs.getString('id')!;
    var result = await request.get(
        '/msg/list?page=${page.value}&pageSize=${pageSize.value}&userId=$id&msgType=2');
    return result;
  }

  //TODO:获取全部评论消息列表
  Future<List> getMessageThree() async {
    var prefs = await SharedPreferences.getInstance();
    String id = prefs.getString('id')!;
    var result = await request.get(
        '/msg/list?page=${page.value}&pageSize=${pageSize.value}&userId=$id&msgType=3');
    return result;
  }

  //TODO:获取全部回复评论消息列表
  Future<List> getMessageFour() async {
    var prefs = await SharedPreferences.getInstance();
    String id = prefs.getString('id')!;
    var result = await request.get(
        '/msg/list?page=${page.value}&pageSize=${pageSize.value}&userId=$id&msgType=4');
    return result;
  }

  //TODO:获取全部点赞评论消息列表
  Future<List> getMessageFive() async {
    var prefs = await SharedPreferences.getInstance();
    String id = prefs.getString('id')!;
    var result = await request.get(
        '/msg/list?page=${page.value}&pageSize=${pageSize.value}&userId=$id&msgType=5');
    return result;
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
      videoController.renew();
      mineController.renewFans();
      renewOne();
      print(value);
    }).catchError((error) {
      EasyLoading.showError('数据解析异常');
      print(error);
    });
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
      mineController.renewFans();
      renewOne();
    }).catchError((error) {
      EasyLoading.showError('数据解析异常');
      print(error);
    });
    update();
  }
}
