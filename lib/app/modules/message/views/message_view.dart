// ignore_for_file: prefer_const_constructors, avoid_print

import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';
import 'package:han_tok/app/data/video/user_info.dart';
import 'package:han_tok/app/modules/camera/views/camera_view.dart';
import 'package:han_tok/app/modules/message/views/message_interact_view.dart';

import '../../../data/base_data.dart';
import '../../../data/base_style.dart';
import '../../../data/theme_data.dart';
import '../../../utils/Iconfont.dart';
import '../../index/views/tabbar/index_search_view.dart';
import '../../login/controllers/login_bottom_controller.dart';
import '../controllers/message_controller.dart';
import 'friend/friends_view.dart';

class MessageView extends GetView<MessageController> {
  const MessageView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    LoginBottomController loginController = Get.put(LoginBottomController());
    MessageController controller = Get.put(MessageController());
    final size = MediaQuery.of(context).size;
    final paddingTop = MediaQueryData.fromWindow(window).padding.top;
    return Scaffold(
      appBar: AppBar(
        title: GestureDetector(
          onTap: () => showModalBottomSheet(
            isScrollControlled: true,
            context: context,
            builder: (BuildContext context) {
              return AnnotatedRegion<SystemUiOverlayStyle>(
                 value: SystemUiOverlayStyle.light,
                child: Container(
                color: Colors.black,
                child: SizedBox(
                  height: size.height,
                  child: Column(
                    children: [
                      SizedBox(
                        height: paddingTop.h,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20.w),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Obx(
                              () => controller.isShow.value == true
                                  ? GestureDetector(
                                      onTap: () => {
                                        Get.back(),
                                        controller.leave(),
                                      },
                                      child: Icon(
                                        Icons.clear,
                                        size: 32,
                                        color: Colors.white,
                                      ),
                                    )
                                  : GestureDetector(
                                      onTap: () => {
                                        if (controller.isShow.value == true)
                                          {
                                            controller.leave(),
                                            Get.back(),
                                            print(controller.isShow.value)
                                          }
                                        else
                                          {
                                            Get.back(),
                                            print(controller.isShow.value)
                                          }
                                      },
                                      child: Icon(
                                        Icons.clear,
                                        size: 32,
                                        color: Colors.white,
                                      ),
                                    ),
                            ),
                            Text(
                              '抖音时刻',
                              style: BaseStyle.fs20.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                            Obx(
                              () => controller.isShow.value == false
                                  ? GestureDetector(
                                      onTap: () => controller.show(),
                                      child: Icon(
                                        Icons.grid_on,
                                        size: 32,
                                        color: Colors.white,
                                      ),
                                    )
                                  : Icon(
                                      Icons.grid_on,
                                      size: 32,
                                    ),
                            )
                          ],
                        ),
                      ),
                      Obx(
                        () => controller.isShow.value == false
                            ? Column(
                                children: [
                                  Container(
                                    padding:
                                        EdgeInsets.only(top: 30, bottom: 16),
                                    child: Row(
                                      children: [
                                        SizedBox(width: 16.h),
                                        Container(
                                          width: 40.w,
                                          height: 40.h,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(20.r),
                                          ),
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(20.r),
                                            child: Obx(
                                              () => Image.network(
                                                loginController.avatar.value,
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          ),
                                        ),
                                        SizedBox(width: 10.h),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Obx(
                                              () => Text(
                                                loginController.nickname.value,
                                                style: BaseStyle.fs14.copyWith(
                                                    color: Colors.white,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ),
                                            Text('此时此刻',
                                                style: BaseStyle.fs14G),
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                  Container(
                                    height: size.height * 0.62,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(25.r),
                                      border: Border.all(
                                        width: 2,
                                        color: Colors.green,
                                      ),
                                    ),
                                    child: Center(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          SizedBox(
                                            width: 100.w,
                                            height: 100.h,
                                            child: Image.asset(
                                                'assets/images/photo_green.png'),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.only(
                                                top: 26, bottom: 20),
                                            child: Text(
                                              '今天还没有发布时刻',
                                              style: BaseStyle.fs20.copyWith(
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white),
                                            ),
                                          ),
                                          GestureDetector(
                                            onTap: () => Get.to(() => CameraView()),
                                            child: Container(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 60, vertical: 16),
                                              decoration: BoxDecoration(
                                                color: Config
                                                    .primarySwatchColor.shade50,
                                                borderRadius:
                                                    BorderRadius.circular(30.r),
                                              ),
                                              child: Text(
                                                '去拍摄',
                                                style: BaseStyle.fs14,
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              )
                            : SizedBox(
                                height: size.height - paddingTop - 100.h,
                                child: Column(
                                  children: [
                                    Expanded(
                                      child: PageView(
                                        controller: controller.pageController,
                                        children: <Widget>[
                                          Expanded(
                                            child: Center(
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  SizedBox(
                                                    width: 100.w,
                                                    height: 100.h,
                                                    child: Image.asset(
                                                        'assets/images/photo_green.png'),
                                                  ),
                                                  Padding(
                                                    padding: EdgeInsets.only(
                                                        top: 26, bottom: 20),
                                                    child: Text(
                                                      '今天还没有人发布时刻',
                                                      style: BaseStyle.fs20
                                                          .copyWith(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              color:
                                                                  Colors.white),
                                                    ),
                                                  ),
                                                  GestureDetector(
                                                      onTap: () =>
                                                          Get.to(() => CameraView()),
                                                      child: Container(
                                                        padding: EdgeInsets
                                                            .symmetric(
                                                                horizontal: 60,
                                                                vertical: 16),
                                                        decoration:
                                                            BoxDecoration(
                                                          color: Config
                                                              .primarySwatchColor
                                                              .shade50,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      30.r),
                                                        ),
                                                        child: Text(
                                                          '去拍摄',
                                                          style: BaseStyle.fs14,
                                                        ),
                                                      ))
                                                ],
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            child: Center(
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  SizedBox(
                                                    width: 100.w,
                                                    height: 100.h,
                                                    child: Image.asset(
                                                        'assets/images/photo_green.png'),
                                                  ),
                                                  Padding(
                                                    padding: EdgeInsets.only(
                                                        top: 26, bottom: 20),
                                                    child: Text(
                                                      '你今天还没有发布时刻',
                                                      style: BaseStyle.fs20
                                                          .copyWith(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              color:
                                                                  Colors.white),
                                                    ),
                                                  ),
                                                  GestureDetector(
                                                    onTap: () => Get.to(() => CameraView()),
                                                    child: Container(
                                                      padding:
                                                      EdgeInsets.symmetric(
                                                          horizontal: 60,
                                                          vertical: 16),
                                                      decoration: BoxDecoration(
                                                        color: Config
                                                            .primarySwatchColor
                                                            .shade50,
                                                        borderRadius:
                                                        BorderRadius.circular(
                                                            30.r),
                                                      ),
                                                      child: Text(
                                                        '去拍摄',
                                                        style: BaseStyle.fs14,
                                                      ),
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                        onPageChanged: (index) {
                                          controller.change(index);
                                        },
                                      ),
                                    ),
                                    Container(
                                      width: 220.w,
                                      height: 44.h,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(22.r)),
                                        color:
                                            BaseData.bodyColor.withOpacity(0.1),
                                      ),
                                      child: Row(
                                        children: <Widget>[
                                          Expanded(
                                              child: Container(
                                            decoration:
                                                controller.currentPage.value ==
                                                        0
                                                    ? BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius.all(
                                                          Radius.circular(22.r),
                                                        ),
                                                        color: Config
                                                            .primarySwatchColor
                                                            .shade50
                                                            .withOpacity(.1),
                                                      )
                                                    : null,
                                            child: Center(
                                              child: MaterialButton(
                                                onPressed: () {
                                                  controller.pageController!
                                                      .animateToPage(0,
                                                          duration: Duration(
                                                              milliseconds:
                                                                  500),
                                                          curve: Curves
                                                              .decelerate);
                                                },
                                                child: Text(
                                                  "今日时刻",
                                                  style: BaseStyle.fs16W
                                                      .copyWith(
                                                          fontWeight:
                                                              FontWeight.bold),
                                                ),
                                              ),
                                            ),
                                          )),
                                          Expanded(
                                              child: Container(
                                            decoration:
                                                controller.currentPage.value ==
                                                        1
                                                    ? BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius.all(
                                                          Radius.circular(22.r),
                                                        ),
                                                        color: Config
                                                            .primarySwatchColor
                                                            .shade50
                                                            .withOpacity(.1),
                                                      )
                                                    : null,
                                            child: Center(
                                              child: MaterialButton(
                                                onPressed: () {
                                                  controller.pageController!
                                                      .animateToPage(1,
                                                          duration: Duration(
                                                              milliseconds:
                                                                  500),
                                                          curve: Curves
                                                              .decelerate);
                                                },
                                                child: Text(
                                                  "我的时刻",
                                                  style: BaseStyle.fs16W
                                                      .copyWith(
                                                          fontWeight:
                                                              FontWeight.bold),
                                                ),
                                              ),
                                            ),
                                          )),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                      ),
                    ],
                  ),
                ),
              ),);
            },
          ),
          child: Icon(
            IconFont.bolt_circle,
            size: 30,
          ),
        ),
        leading: GestureDetector(
          onTap: () => {
            showModalBottomSheet<void>(
              context: context,
              isScrollControlled: true,
              isDismissible: true,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              builder: (BuildContext context) {
                return Container(
                  height: size.height * 0.7,
                  color: Colors.white,
                  margin: EdgeInsets.symmetric(horizontal: 16.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(height: 12.h),
                      Container(
                        width: 35.w,
                        height: 4.h,
                        decoration: BoxDecoration(
                          color: Colors.grey,
                          borderRadius: BorderRadius.circular(4.r),
                        ),
                      ),
                      SizedBox(
                        height: size.height * 0.7 - 47.h,
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              SizedBox(height: 16.h),
                              Row(
                                children: [
                                  Expanded(
                                    child: Container(
                                      height: 36.h,
                                      color: Config.primarySwatchColor.shade50,
                                      child: TextField(
                                        onChanged: (String value) {},
                                        cursorColor: Colors.lightBlueAccent,
                                        decoration: InputDecoration(
                                          hintText: '搜索用户',
                                          hintStyle:
                                              TextStyle(color: Colors.grey),
                                          prefixIcon: Icon(
                                            Icons.search,
                                            color: Colors.grey,
                                          ),
                                          // prefixIconColor: Colors.red,
                                          border: InputBorder.none,
                                          contentPadding: EdgeInsets.symmetric(
                                              vertical: 10),
                                        ),
                                      ),
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () => {},
                                    child: Container(
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 15),
                                      child: Text('搜索'),
                                    ),
                                  )
                                ],
                              ),
                              SizedBox(height: 16.h),
                              Container(
                                height: 1.h,
                                color: Colors.grey,
                              ),
                              SizedBox(height: 16.h),
                              Obx(
                                () => Column(
                                  children: controller.followList
                                      .map((element) => Column(
                                            children: [
                                              GestureDetector(
                                                onTap: () => Get.to(
                                                  () => UserInfo(
                                                    vlogerId: element.vlogerId,
                                                  ),
                                                ),
                                                child: Row(
                                                  children: [
                                                    SizedBox(width: 12.w),
                                                    SizedBox(
                                                      width: 56.w,
                                                      height: 56.h,
                                                      child: ClipRRect(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(28.r),
                                                        child: Image.network(
                                                          element.face
                                                              .toString(),
                                                          fit: BoxFit.cover,
                                                        ),
                                                      ),
                                                    ),
                                                    SizedBox(width: 12.w),
                                                    Text(
                                                      element.nickname
                                                          .toString(),
                                                    )
                                                  ],
                                                ),
                                              ),
                                              SizedBox(height: 10.h),
                                              Container(
                                                height: 1.h,
                                                color:
                                                    Colors.grey.withOpacity(.1),
                                                margin: EdgeInsets.symmetric(
                                                    horizontal: 16.w),
                                              ),
                                              SizedBox(height: 10.h),
                                            ],
                                          ))
                                      .toList(),
                                ),
                              ),
                              Padding(
                                padding:
                                    EdgeInsets.only(top: 10.h, bottom: 4.h),
                                child: Text('发现朋友',
                                    style: BaseStyle.fs16
                                        .copyWith(fontWeight: FontWeight.bold)),
                              ),
                              Text('发现更多你可能认识的人', style: BaseStyle.fs14),
                              GestureDetector(
                                onTap: () => {
                                  Navigator.of(context).pop(),
                                  Get.to(() => FriendsView()),
                                },
                                child: Container(
                                  margin: EdgeInsets.only(top: 20.h),
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 16.w, vertical: 4.h),
                                  decoration: BoxDecoration(
                                    color: Colors.red.withOpacity(.8),
                                  ),
                                  child: Text('查找朋友并关注',
                                      style: BaseStyle.fs14
                                          .copyWith(color: Colors.white)),
                                ),
                              ),
                              SizedBox(height: 20.h),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                );
              },
            ),
          },
          child: Icon(
            Icons.add_circle_outline,
            size: 32,
          ),
        ),
        actions: [
          GestureDetector(
            onTap: () => Get.to(() => IndexSearchView()),
            child: Icon(
              Icons.search,
              size: 32,
            ),
          ),
          SizedBox(width: 10.w),
        ],
        elevation: 1,
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 80.h,
                  width: size.width * 0.15,
                  child: Stack(
                    children: [
                      Positioned(
                        top: 0,
                        left: 0,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: 56.w,
                              height: 56.h,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(28.r),
                                child: Image.network(
                                  loginController.avatar.value,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            SizedBox(height: 4.h),
                            Text(
                              '抖音时刻',
                              style: BaseStyle.fs12
                                  .copyWith(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                      Positioned(
                        top: 38.w,
                        left: 38.w,
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(width: 1.w, color: Colors.white),
                            borderRadius: BorderRadius.circular(16.r),
                            color: Colors.white,
                          ),
                          child: Icon(
                            Icons.add_circle,
                            color: Colors.green,
                            size: 20,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
          ListTile(
            onTap: () => Get.to(() => FriendsView()),
            leading: Icon(
              Icons.account_circle,
              color: Colors.blueAccent,
              size: 56,
            ),
            title: Text(
              '新朋友',
              style: BaseStyle.fs14.copyWith(fontWeight: FontWeight.bold),
            ),
            trailing: Icon(
              Icons.arrow_forward_ios,
              size: 16,
            ),
          ),
          SizedBox(height: 10.h),
          ListTile(
            onTap: () => Get.to(() => MessageInteractView()),
            leading: Icon(
              Icons.account_circle,
              color: Colors.pinkAccent,
              size: 56,
            ),
            title: Text(
              '互动消息',
              style: BaseStyle.fs14.copyWith(fontWeight: FontWeight.bold),
            ),
            trailing: Icon(
              Icons.arrow_forward_ios,
              size: 16,
            ),
          )
        ],
      ),
    );
  }
}
