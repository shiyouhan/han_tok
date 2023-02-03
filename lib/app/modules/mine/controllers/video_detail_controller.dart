// ignore_for_file: depend_on_referenced_packages, avoid_print, unnecessary_overrides

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../main.dart';
import '../../../data/video/controller/video_controller.dart';
import '../../../data/video/model/comment/CommentList.dart';
import '../model/Video.dart';

class VideoDetailController extends GetxController {
  VideoController videoController = Get.put(VideoController());
  TextEditingController commentController = TextEditingController();
  final vlogId = ''.obs;
  final vlogerId = ''.obs;
  final createdTime = ''.obs;
  final vlogerFace = 'http://img.syhan.top/uPic/grey.jpg'.obs;
  final vlogerName = ''.obs;
  final content = ''.obs;
  final url = ''.obs;
  final likeCounts = 0.obs;
  final commentsCounts = 0.obs;
  final isPrivate = 0.obs;

  final fatherCommentId = '0'.obs;
  final commentId = ''.obs;
  final commentUserId = ''.obs;
  final commentContent = ''.obs;

  var commentList = [].obs;
  final page = 1.obs;
  final pageSize = 99.obs;

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

  void commentStr(value) => commentContent.value = value;

  //todo:获取视频详情
  getDetail() async {
    var prefs = await SharedPreferences.getInstance();
    String id = prefs.getString('id')!;

    request
        .get('/vlog/detail?userId=$id&vlogId=${vlogId.value}')
        .then((value) async {
      vlogId.value = Video.fromJson(value).vlogId;
      vlogerFace.value = Video.fromJson(value).vlogerFace;
      vlogerName.value = Video.fromJson(value).vlogerName;
      content.value = Video.fromJson(value).content;
      likeCounts.value = Video.fromJson(value).likeCounts;
      commentsCounts.value = Video.fromJson(value).commentsCounts;
      isPrivate.value = Video.fromJson(value).isPrivate;
      print(value);
    }).catchError((error) {
      EasyLoading.showError('数据解析异常');
      print(error);
    });
  }

  Future<List> getComment() async {
    var prefs = await SharedPreferences.getInstance();
    String id = prefs.getString('id')!;
    var result = await request.get(
        '/comment/list?vlogId=${vlogId.value}&userId=$id&page=${page.value}&pageSize=${pageSize.value}');
    print(result);
    return result['rows'];
  }

  void renewComment() async {
    commentList.value = await getComment();
    commentList.value =
        commentList.map((element) => CommentList.fromJson(element)).toList();
    update();
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
      "vlogerId": id,
    };
    request
        .post('/comment/create', headers: headers, data: data)
        .then((value) async {
      print(value);
      renewComment();
      videoController.renewComment();
    }).catchError((error) {
      EasyLoading.showError('数据解析异常');
      print(error);
    });
  }

  //todo:点赞评论
  commentLike() async {
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
      videoController.renewComment();
    }).catchError((error) {
      EasyLoading.showError('数据解析异常');
      print(error);
    });
  }

  //todo:点赞评论
  commentUnLike() async {
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
      videoController.renewComment();
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

    request
        .post(
            '/comment/delete?commentUserId=${commentUserId.value}&commentId=${commentId.value}&vlogId=${vlogId.value}',
            headers: headers)
        .then((value) async {
      print(commentId.value);
      print(value);
      EasyLoading.showSuccess('删除成功');
      renewComment();
      videoController.renewComment();
    }).catchError((error) {
      EasyLoading.showError('数据解析异常');
      print(error);
    });
  }
}
