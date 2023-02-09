// ignore_for_file: avoid_print, unnecessary_overrides, depend_on_referenced_packages

import 'package:flutter/cupertino.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:get/get.dart';

import '../../../../main.dart';
import '../../../data/video/controller/video_controller.dart';
import '../../../data/video/model/comment/CommentList.dart';
import '../../mine/controllers/mine_controller.dart';
import '../../mine/model/Vlog.dart';

class SearchDetailController extends GetxController {
  MineController mineController = Get.put(MineController());
  VideoController videoController = Get.put(VideoController());
  TextEditingController commentController = TextEditingController();

  final vlogId = ''.obs;
  final vlogerId = ''.obs;
  final vlogerFace = 'http://img.syhan.top/uPic/grey.jpg'.obs;
  final vlogerName = ''.obs;
  final content = ''.obs;
  final url = ''.obs;
  final likeCounts = 0.obs;
  final commentsCounts = 0.obs;
  final province = ''.obs;
  final createdTime = ''.obs;
  final doIFollowVloger = false.obs;
  final doILikeThisVlog = false.obs;

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
      vlogerName.value = Vlog.fromJson(value).vlogerName;
      vlogerFace.value = Vlog.fromJson(value).vlogerFace;
      content.value = Vlog.fromJson(value).content;
      likeCounts.value = Vlog.fromJson(value).likeCounts;
      commentsCounts.value = Vlog.fromJson(value).commentsCounts;
      doIFollowVloger.value = Vlog.fromJson(value).doIFollowVloger;
      doILikeThisVlog.value = Vlog.fromJson(value).doILikeThisVlog;
      print(value);
    }).catchError((error) {
      EasyLoading.showError('数据解析异常');
      print(error);
    });
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
      getDetail();
      print(value);
    }).catchError((error) {
      EasyLoading.showError('数据解析异常');
      print(error);
    });
  }

  //TODO:点赞
  Future<bool> changeData(status) async {
    like();
    return Future.value(!status);
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
      getDetail();
      mineController.renewLike();
    }).catchError((error) {
      EasyLoading.showError('数据解析异常');
      print(error);
    });
  }

  //TODO:视频取消点赞
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
      getDetail();
      mineController.renewLike();
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
      "vlogerId": vlogerId.value,
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
        videoController.renewComment();
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
        videoController.renewComment();
      }).catchError((error) {
        EasyLoading.showError('数据解析异常');
        print(error);
      });
    } else {
      EasyLoading.showError('您无权删除该评论!');
    }
  }
}
