// ignore_for_file: prefer_const_constructors

import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';
import 'package:han_tok/app/modules/login/controllers/login_bottom_controller.dart';

import '../../../../data/base_style.dart';
import '../../../../data/theme_data.dart';
import '../../controllers/visit_controller.dart';

class VisitView extends GetView<VisitController> {
  const VisitView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    LoginBottomController loginController = Get.put(LoginBottomController());
    VisitController controller = Get.put(VisitController());
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '主页访客',
          style: BaseStyle.fs16.copyWith(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 0,
        actions: [
          Center(
            child: Padding(
              padding: EdgeInsets.only(right: 16.w),
              child: GestureDetector(
                onTap: () => {
                  showModalBottomSheet<void>(
                    context: context,
                    isDismissible: true,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20.r),
                        topRight: Radius.circular(20.r),
                      ),
                    ),
                    builder: (BuildContext context) {
                      return Container(
                        height: size.height * 0.36,
                        color: Colors.white,
                        margin: EdgeInsets.symmetric(horizontal: 16.w),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(height: 16.h),
                            Row(
                              children: [
                                Spacer(),
                                GestureDetector(
                                  onTap: () => Get.back(),
                                  child: Container(
                                    width: 36.w,
                                    height: 36.w,
                                    decoration: BoxDecoration(
                                      color: Config.primarySwatchColor.shade50,
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(18.r),
                                      ),
                                    ),
                                    child: Icon(Icons.close),
                                  ),
                                ),
                              ],
                            ),
                            Obx(
                              () => Stack(
                                children: [
                                  SizedBox(
                                    width: 72.w,
                                    height: 72.w,
                                    child: Image(
                                      image: AssetImage(
                                          'assets/images/person_close.png'),
                                    ),
                                  ),
                                  Positioned(
                                    top: 50.w,
                                    left: 48.w,
                                    child: controller.isShow.value == false
                                        ? ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(30.r),
                                            child: Container(
                                              color: Colors.white,
                                              child: Icon(
                                                Icons.remove_circle,
                                                color: Colors.pink,
                                              ),
                                            ),
                                          )
                                        : Container(),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(vertical: 16.h),
                              child: Text(
                                '主页访客',
                                style: BaseStyle.fs16.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Text(
                              '关闭后，你查看他人主页时不会留下记录；同时，你也无法查看谁访问了你的主页。',
                              textAlign: TextAlign.center,
                              style: BaseStyle.fs12G,
                            ),
                            SizedBox(height: 12.h),
                            Container(
                              height: 1.h,
                              color: Colors.grey,
                            ),
                            Obx(
                              () => ListTile(
                                title: Text(
                                  '展示主页访客',
                                  style: BaseStyle.fs16,
                                ),
                                trailing: CupertinoSwitch(
                                  activeColor: Config.primaryColor,
                                  trackColor: Config.primarySwatchColor.shade50,
                                  value: controller.isShow.value,
                                  onChanged: (value) {
                                    controller.visitSwitch();
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  )
                },
                child: Text(
                  '设置',
                  style: BaseStyle.fs16,
                ),
              ),
            ),
          )
        ],
      ),
      body: SafeArea(
        child: Container(
          color: Colors.white,
          child: Obx(
            () => controller.isShow.value == false
                ? Center(
                    child: Column(
                      children: [
                        SizedBox(height: size.height * 0.18),
                        SizedBox(
                          width: size.width,
                          height: 100.h,
                          child: Stack(
                            children: [
                              Positioned(
                                top: 55,
                                left: size.width / 2 - 74,
                                child: Transform.rotate(
                                  angle: pi / 4,
                                  child: Container(
                                    width: 34.w,
                                    height: 34.h,
                                    decoration: BoxDecoration(
                                      color: Colors.orange,
                                      borderRadius: BorderRadius.circular(17.r),
                                    ),
                                    child: Icon(
                                      Icons.ac_unit,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                              Positioned(
                                left: size.width / 2 - 50,
                                top: 0,
                                child: Container(
                                  width: 100.w,
                                  height: 100.h,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(50.r),
                                    border: Border.all(
                                      width: 5.w,
                                      color: Colors.white,
                                    ),
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(50.r),
                                    child: Image.network(
                                      loginController.avatar.value,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ),
                              Positioned(
                                top: 50,
                                left: size.width / 2 + 30,
                                child: Transform.rotate(
                                  angle: -pi / 4,
                                  child: Container(
                                    width: 54.w,
                                    height: 54.h,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(27.r),
                                      color: Colors.pinkAccent,
                                      border: Border.all(
                                        width: 5.w,
                                        color: Colors.white,
                                      ),
                                    ),
                                    child: Icon(
                                      Icons.ac_unit,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 34.h, bottom: 24.h),
                          child: Text(
                            '查看新访客需要你的授权',
                            style: BaseStyle.fs16
                                .copyWith(fontWeight: FontWeight.bold),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 90.w),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Container(
                                    width: 2.w,
                                    height: 2.w,
                                    margin: EdgeInsets.only(right: 12.w),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(1.r),
                                      color: Colors.black,
                                    ),
                                  ),
                                  Text(
                                    '访客记录中仅展示同样己授权的用户',
                                    style: BaseStyle.fs12G,
                                  ),
                                ],
                              ),
                              SizedBox(height: 16.h),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Container(
                                    width: 2.w,
                                    height: 2.w,
                                    margin: EdgeInsets.only(right: 12.w),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(1.r),
                                      color: Colors.black,
                                    ),
                                  ),
                                  Text(
                                    '开启后，你访向他人主页也将留下记录',
                                    style: BaseStyle.fs12G,
                                  ),
                                ],
                              ),
                              SizedBox(height: 16.h),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Container(
                                    width: 2.w,
                                    height: 2.w,
                                    margin: EdgeInsets.only(right: 12.w),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(1.r),
                                      color: Colors.black,
                                    ),
                                  ),
                                  Text(
                                    '你可以随时在访客设置中关闭授权',
                                    style: BaseStyle.fs12G,
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                        Spacer(),
                        Padding(
                          padding: EdgeInsets.only(bottom: 16.h),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              GestureDetector(
                                onTap: () => {
                                  EasyLoading.showToast('你将不再收到相关通知'),
                                  Get.back(),
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(2.r),
                                    border: Border.all(
                                      width: 1,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 54, vertical: 14),
                                  child: Text(
                                    '保持关闭',
                                    style: BaseStyle.fs16,
                                  ),
                                ),
                              ),
                              SizedBox(width: 8.w),
                              GestureDetector(
                                onTap: () => controller.show(),
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(2.r),
                                    color: Colors.pinkAccent,
                                  ),
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 55, vertical: 15),
                                  child: Text(
                                    '开启访客',
                                    style: BaseStyle.fs16W,
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  )
                : Column(
                    children: [
                      SizedBox(height: 90.h),
                      SizedBox(
                        width: 200,
                        height: 200,
                        child: Image(
                          image: AssetImage('assets/images/no_data.png'),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 10),
                        child: Text(
                          '下次有新访客时将通知你',
                          style: BaseStyle.fs16
                              .copyWith(fontWeight: FontWeight.bold),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 40.w),
                        child: Text(
                          '部分访客因暂未授权开启而未展示；当同样已授权开启访客的人查看你的主页后，会留下访客记录；当有新访客后，你将很快收到通知。',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.grey),
                        ),
                      )
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}
