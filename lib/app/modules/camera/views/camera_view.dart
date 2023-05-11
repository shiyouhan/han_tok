// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, sort_child_properties_last, avoid_print

import 'dart:ui';

import 'package:camera/camera.dart';
import 'package:control_center/control_center.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';
import 'package:han_tok/app/data/base_style.dart';
import 'package:han_tok/app/modules/home/views/home_view.dart';
import 'package:image_picker/image_picker.dart';
import '../../../utils/Iconfont.dart';
import '../controllers/camera_controller.dart';
import 'package:scan/scan.dart';

class CameraView extends StatefulWidget {
  const CameraView({super.key});

  @override
  State<StatefulWidget> createState() => _CameraViewStage();
}

class _CameraViewStage extends State<CameraView> {
  late CameraViewController _controller;
  final _controlCenterPlugin = ControlCenter();

  @override
  void initState() {
    super.initState();
    _controller = CameraViewController();
    _controller.init();
  }

  @override
  Widget build(BuildContext context) {
    final paddingTop = MediaQueryData.fromWindow(window).padding.top;

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Stack(
        children: [
          // 相机视频预览区域
          SizedBox(
              width: double.infinity,
              height: double.infinity,
              child: Obx(() {
                return _controller.cameraController == null ||
                        !_controller.cameraController!.value.isInitialized
                    ? Container(color: Colors.black)
                    : CameraPreview(_controller.cameraController!);
              })),
          Padding(
            padding: EdgeInsets.only(top: paddingTop + 10, left: 19),
            child: GestureDetector(
              child: Icon(
                Icons.clear,
                size: 32,
                color: Colors.white,
              ),
              onTap: () {
                // Get.to(() => HomeView());
                Get.back();
              },
            ),
          ),
          Align(
            alignment: Alignment.topRight,
            child: Padding(
                padding: EdgeInsets.only(top: paddingTop + 10, right: 14),
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: () => _controller.onSwitchCamera(),
                      behavior: HitTestBehavior.opaque,
                      child: Column(
                        children: [
                          Image.asset(
                            'assets/images/rotate.png',
                            width: 28.w,
                            height: 28.h,
                            fit: BoxFit.fill,
                          ),
                          SizedBox(height: 6.h),
                          Text(
                            '翻转',
                            style: BaseStyle.fs12.copyWith(
                                color: Colors.white,
                                decoration: TextDecoration.none,
                                fontWeight: FontWeight.w100),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 16),
                    GestureDetector(
                      onTap: () => _controller.takePhotoAndUpload(),
                      behavior: HitTestBehavior.opaque,
                      child: Column(
                        children: [
                          Image.asset(
                            'assets/images/clock.png',
                            width: 36.w,
                            height: 36.h,
                            fit: BoxFit.fill,
                          ),
                          SizedBox(height: 6.h),
                          Text(
                            '倒计时',
                            style: BaseStyle.fs12.copyWith(
                                color: Colors.white,
                                decoration: TextDecoration.none,
                                fontWeight: FontWeight.w100),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 16),
                    Obx(() => GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        child: Column(
                          children: [
                            _controller.flash
                                ? Image.asset(
                                    'assets/images/flash_on.png',
                                    width: 36.w,
                                    height: 36.h,
                                    fit: BoxFit.fill,
                                  )
                                : Image.asset(
                                    'assets/images/flash_off.png',
                                    width: 36.w,
                                    height: 36.h,
                                    fit: BoxFit.fill,
                                  ),
                            SizedBox(height: 6.h),
                            Text(
                              '闪光灯',
                              style: BaseStyle.fs12.copyWith(
                                  color: Colors.white,
                                  decoration: TextDecoration.none,
                                  fontWeight: FontWeight.w100),
                            ),
                          ],
                        ),
                        onTap: () {
                          _controller.onSwitchFlash();
                          _controlCenterPlugin.openOrCloseFlashlight();
                        }
                    ),),
                  ],
                )),
          ),
          // 相册
          Align(
            alignment: Alignment.bottomRight,
            child: Padding(
              padding: EdgeInsets.only(right: 62, bottom: 110),
              child: GestureDetector(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      // Image.asset(
                      //   'assets/images/gallery.png',
                      //   width: 40.w,
                      //   height: 40.h,
                      //   fit: BoxFit.fill,
                      // ),
                      Icon(
                        IconFont.image,
                        size: 40,
                        color: Colors.white,
                      ),
                      SizedBox(height: 10),
                      Text(
                        '相册',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            decoration: TextDecoration.none),
                      )
                    ],
                  ),
                  onTap: () async {
                    var pickedFile = await ImagePicker()
                        .pickVideo(source: ImageSource.gallery);
                    var path = pickedFile?.path;
                    if (path != null) {
                      print('MOOC= upload picture: $path');
                    }
                  }),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: EdgeInsets.only(bottom: 115),
              child: GestureDetector(
                onTap: () => _controller.takePhotoAndUpload(),
                child: Obx(
                  () => _controller.recording
                      ? Container(
                          constraints:
                              BoxConstraints(maxHeight: 80, maxWidth: 80),
                          padding: EdgeInsets.all(16.w),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(40.r),
                          ),
                          child: Container(
                            constraints:
                                BoxConstraints(maxHeight: 40, maxWidth: 40),
                            decoration: BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.circular(10.r),
                            ),
                          ),
                        )
                      : Container(
                          constraints:
                              BoxConstraints(maxHeight: 80, maxWidth: 80),
                          padding: EdgeInsets.all(3.w),
                          decoration: BoxDecoration(
                            color: Colors.transparent,
                            borderRadius: BorderRadius.circular(40),
                            border: Border.all(
                              // style: BorderStyle.solid,
                              color: Colors.white,
                              width: 4.w,
                            ),
                          ),
                          child: Container(
                            constraints:
                                BoxConstraints(maxHeight: 74, maxWidth: 74),
                            decoration: BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.circular(37.r),
                            ),
                          ),
                        ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
