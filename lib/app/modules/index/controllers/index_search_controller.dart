// ignore_for_file: avoid_print, depend_on_referenced_packages, unnecessary_overrides, avoid_function_literals_in_foreach_calls

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:han_tok/app/modules/mine/controllers/mine_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../main.dart';
import '../../../data/video/model/comment/CommentList.dart';
import '../../mine/model/Video.dart';
import '../model/IndexList.dart';

class IndexSearchController extends GetxController {
  MineController mineController = Get.put(MineController());
  var searchController = TextEditingController().obs;
  TextEditingController commentController = TextEditingController();

  void commentStr(value) => content.value = value;

  final searchContent = ''.obs;

  final vlogId = ''.obs;
  final vlogerId = ''.obs;
  final doILikeThisVlog = false.obs;
  final likeCounts = 0.obs;
  final commentId = ''.obs;
  final content = ''.obs;
  final commentUserId = ''.obs;
  final fatherCommentId = '0'.obs;
  final isLike = 0.obs;

  final page = 1.obs;
  final pageSize = 99.obs;
  var videoList = [].obs;
  var commentList = [].obs;

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

  void searchStr(value) => searchContent.value = value;

  void search() async => {
        videoList.value = await getVideo(),
        videoList.value =
            videoList.map((element) => IndexList.fromJson(element)).toList(),
        videoList.forEach((element) {
          query(element.vlogId);
        }),
        update(),
      };

  void renewComment(String vlogId) async {
    commentList.value = await getComment(vlogId);
    commentList.value =
        commentList.map((element) => CommentList.fromJson(element)).toList();
    update();
  }

  //TODO:获取评论列表
  Future<List> getComment(String vlogId) async {
    var prefs = await SharedPreferences.getInstance();
    String id = prefs.getString('id')!;
    var result = await request.get(
        '/comment/list?vlogId=$vlogId&userId=$id&page=${page.value}&pageSize=${pageSize.value}');
    print(result);
    return result['rows'];
  }

  //TODO:获取视频列表
  Future<List> getVideo() async {
    var prefs = await SharedPreferences.getInstance();
    String id = prefs.getString('id')!;
    var result = await request.get(
        '/vlog/indexList?page=${page.value}&pageSize=${pageSize.value}&search=${searchController.value.text}&userId=$id');
    videoList.value = result['rows'];
    print(result);
    return result['rows'];
  }

  //todo:获取评论数
  query(String vlogId) async {
    request.get('/comment/counts?vlogId=$vlogId').then((value) async {
      print(value);
    }).catchError((error) {
      EasyLoading.showError('数据解析异常');
      print(error);
    });
  }

  //todo:获取视频详情
  getDetail(String vlogId) async {
    var prefs = await SharedPreferences.getInstance();
    String id = prefs.getString('id')!;

    request.get('/vlog/detail?userId=$id&vlogId=$vlogId').then((value) async {
      doILikeThisVlog.value = Video.fromJson(value).doILikeThisVlog;
      likeCounts.value = Video.fromJson(value).likeCounts;
      print(value);
    }).catchError((error) {
      EasyLoading.showError('数据解析异常');
      print(error);
    });
  }

  //TODO:视频点赞
  like() async {
    var prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('userToken')!;
    String id = prefs.getString('id')!;

    Map<String, dynamic> headers = {
      "headerUserId": id,
      "headerUserToken": token,
    };
    request
        .post(
            '/vlog/like?userId=$id&vlogId=${vlogId.value}&vlogerId=${vlogerId.value}',
            headers: headers)
        .then((value) {
      print(value);
      doILikeThisVlog.value = true;
      search();
      //getDetail();
      mineController.renewLike();
    }).catchError((error) {
      EasyLoading.showError('数据解析异常');
      print(error);
    });
  }

  // //TODO:视频取消点赞
  unlike() async {
    var prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('userToken')!;
    String id = prefs.getString('id')!;

    Map<String, dynamic> headers = {
      "headerUserId": id,
      "headerUserToken": token,
    };
    request
        .post(
            '/vlog/unlike?userId=$id&vlogId=${vlogId.value}&vlogerId=${vlogerId.value}',
            headers: headers)
        .then((value) {
      print(value);
      doILikeThisVlog.value = false;
      search();
      // getDetail();
      mineController.renewLike();
    }).catchError((error) {
      EasyLoading.showError('数据解析异常');
      print(error);
    });
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
      renewComment(vlogId.value);
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
      renewComment(vlogId.value);
    }).catchError((error) {
      EasyLoading.showError('数据解析异常');
      print(error);
    });
  }

  //todo:取消点赞评论
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
      renewComment(vlogId.value);
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
        renewComment(vlogId.value);
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
        renewComment(vlogId.value);
      }).catchError((error) {
        EasyLoading.showError('数据解析异常');
        print(error);
      });
    } else {
      EasyLoading.showError('您无权删除该评论!');
    }
  }
}
