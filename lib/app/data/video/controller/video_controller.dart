// ignore_for_file: depend_on_referenced_packages, unnecessary_overrides, avoid_print

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:han_tok/app/data/video/model/comment/CommentList.dart';
import 'package:han_tok/app/modules/mine/model/Follow.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../../main.dart';
import '../../../modules/index/controllers/follow_controller.dart';

class VideoController extends GetxController {
  FollowController followController = Get.put(FollowController());
  TextEditingController commentController = TextEditingController();
  //var commentController = TextEditingController().obs;

  @override
  void onInit() async {
    followList.value = await getVideo();
    followList.value =
        followList.map((element) => Follow.fromJson(element)).toList();
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

  var followList = [].obs;
  var commentList = [].obs;
  final page = 1.obs;
  final pageSize = 99.obs;

  final followed = false.obs;
  final isMine = false.obs;

  final vlogId = ''.obs;
  final vlogerId = ''.obs;
  final commentId = ''.obs;
  final commentUserId = ''.obs;
  final fatherCommentId = '0'.obs;
  final isLike = 0.obs;
  final doILikeThisVlog = false.obs;
  final likeCounts = 0.obs;
  final content = ''.obs;

  void commentStr(value) => content.value = value;

  void renew() async {
    followList.value = await getVideo();
    followList.value =
        followList.map((element) => Follow.fromJson(element)).toList();
    followController.follow();
    update();
  }

  void renewComment() async {
    commentList.value = await getComment();
    commentList.value =
        commentList.map((element) => CommentList.fromJson(element)).toList();
    update();
  }

  Future<List> getVideo() async {
    var prefs = await SharedPreferences.getInstance();
    String id = prefs.getString('id')!;
    var result = await request.get(
        '/fans/queryMyFollows?myId=$id&page=${page.value}&pageSize=${pageSize.value}');
    print(result);
    return result['rows'];
  }

  Future<List> getComment() async {
    var prefs = await SharedPreferences.getInstance();
    String id = prefs.getString('id')!;
    var result = await request.get(
        '/comment/list?vlogId=${vlogId.value}&userId=$id&page=${page.value}&pageSize=${pageSize.value}');
    print(result);
    return result['rows'];
  }

  //todo:发送/回复评论
  commentCreate() async {
    var prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('userToken')!;
    String id = prefs.getString('id')!;

    Map<String, dynamic> headers = {
      "headerUserId": id,
      "headerUserToken": token,
    };
    Map<String, dynamic> data = {
      "commentUserId": id,
      "content": commentController.text,
      "fatherCommentId": fatherCommentId.value,
      "vlogId": vlogId.value,
      "vlogerId": vlogerId.value,
    };
    request
        .post('/comment/create', headers: headers, data: data)
        .then((value) async {
      print(value);
      renewComment();
    }).catchError((error) {
      EasyLoading.showError('数据解析异常');
      print(error);
    });
  }

  //todo:点赞评论
  like() async {
    var prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('userToken')!;
    String id = prefs.getString('id')!;

    Map<String, dynamic> headers = {
      "headerUserId": id,
      "headerUserToken": token,
    };
    request
        .post('/comment/like?userId=$id&commentId=${commentId.value}',
            headers: headers)
        .then((value) async {
      print(value);
      renewComment();
    }).catchError((error) {
      EasyLoading.showError('数据解析异常');
      print(error);
    });
  }

  //todo:点赞评论
  unLike() async {
    var prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('userToken')!;
    String id = prefs.getString('id')!;

    Map<String, dynamic> headers = {
      "headerUserId": id,
      "headerUserToken": token,
    };
    request
        .post('/comment/unlike?userId=$id&commentId=${commentId.value}',
            headers: headers)
        .then((value) async {
      print(value);
      renewComment();
    }).catchError((error) {
      EasyLoading.showError('数据解析异常');
      print(error);
    });
  }

  //todo:删除评论
  delete() async {
    var prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('userToken')!;
    String id = prefs.getString('id')!;

    Map<String, dynamic> headers = {
      "headerUserId": id,
      "headerUserToken": token,
    };
    if (vlogerId.value == id) {
      request
          .post(
              '/comment/delete?commentUserId=${commentUserId.value}&commentId=${commentId.value}&vlogId=${vlogId.value}',
              headers: headers)
          .then((value) async {
        print(commentId.value);
        print(value);
        EasyLoading.showSuccess('删除成功');
        renewComment();
      }).catchError((error) {
        EasyLoading.showError('数据解析异常');
        print(error);
      });
    } else if (commentUserId.value == id) {
      request
          .post(
              '/comment/delete?commentUserId=${commentUserId.value}&commentId=${commentId.value}&vlogId=${vlogId.value}',
              headers: headers)
          .then((value) async {
        print(commentId.value);
        print(value);
        EasyLoading.showSuccess('删除成功');
        renewComment();
      }).catchError((error) {
        EasyLoading.showError('数据解析异常');
        print(error);
      });
    } else {
      EasyLoading.showError('您无权删除该评论!');
    }
  }
}
