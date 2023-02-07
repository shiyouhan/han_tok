// ignore_for_file: unnecessary_overrides, prefer_const_constructors, avoid_print, depend_on_referenced_packages, library_prefixes

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart' as DIO;
import 'package:han_tok/app/modules/home/views/home_view.dart';
import 'package:han_tok/app/modules/index/controllers/recommend_controller.dart';
import 'package:han_tok/app/modules/mine/controllers/mine_controller.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:video_thumbnail/video_thumbnail.dart' as video;

import '../../../../main.dart';
import 'camera_controller.dart';

class CameraDetailController extends GetxController {
  TextEditingController contentController = TextEditingController();
  CameraViewController cameraViewController = Get.put(CameraViewController());
  RecommendController recommendController = Get.put(RecommendController());
  MineController mineController = Get.put(MineController());

  final content = ''.obs;
  final cover = 'http://img.syhan.top/uPic/grey.jpg'.obs;
  final videoStr = ''.obs;

  @override
  void onInit() async {
    super.onInit();
    getVideo();
    uploadBg();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  void contentStr(value) => content.value = value;

  //TODO:上传视频
  void getVideo() async {
    var prefs = await SharedPreferences.getInstance();
    String videoUrl = prefs.getString('videoUrl')!;

    var formData = DIO.FormData.fromMap(
        {'file': await DIO.MultipartFile.fromFile(videoUrl)});
    request.post('/vlog/upload?type=3', data: formData).then((value) async {
      videoStr.value = value;
      print(value);
    }).catchError((_) {
      EasyLoading.showError('数据解析异常');
    });
  }

  //TODO:上传视频封面图
  uploadBg() async {
    var prefs = await SharedPreferences.getInstance();
    String videoUrl = prefs.getString('videoUrl')!;

    String? fileName = await video.VideoThumbnail.thumbnailFile(
      video: videoUrl,
      thumbnailPath: (await getTemporaryDirectory()).path,
      imageFormat: video.ImageFormat.PNG,
      maxWidth: 390,
      quality: 100,
    );

    var formData = DIO.FormData.fromMap(
        {'file': await DIO.MultipartFile.fromFile(fileName!)});
    String token = prefs.getString('userToken')!;
    String id = prefs.getString('id')!;
    Map<String, dynamic> headers = {
      "headerUserId": id,
      "headerUserToken": token,
    };
    request
        .post('/vlog/upload?type=${4}', headers: headers, data: formData)
        .then((value) async {
      cover.value = value;
      print(value);
    }).catchError((_) {
      EasyLoading.showError('数据解析异常');
    });
  }

  //TODO:发布视频
  createVideo() async {
    var prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('userToken')!;
    String id = prefs.getString('id')!;
    Map<String, dynamic> headers = {
      "headerUserId": id,
      "headerUserToken": token,
    };

    Map<String, dynamic> data = {
      "vlogerId": id,
      "url": videoStr.value,
      "cover": cover.value,
      "title": contentController.text,
      "width": 320,
      "height": 640
    };
    request
        .post('/vlog/publish', headers: headers, data: data)
        .then((value) async {
      print(value);
      recommendController.renewIndex();
      mineController.renewPublic();
      prefs.remove('videoUrl');
      Get.offAll(() => HomeView());
    }).catchError((_) {
      EasyLoading.showError('数据解析异常');
    });
  }
}
