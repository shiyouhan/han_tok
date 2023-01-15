// ignore_for_file: prefer_const_constructors, avoid_print

import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:get/get.dart';
import 'package:han_tok/app/modules/login/controllers/login_bottom_controller.dart';
import 'package:han_tok/app/utils/Iconfont.dart';
import 'package:popover/popover.dart';

import '../../../data/base_data.dart';
import '../../../data/base_style.dart';
import '../../../data/theme_data.dart';
import '../../index/views/index_view.dart';
import '../../index/views/tabbar/index_scan_view.dart';
import '../controllers/friend_controller.dart';

class FriendView extends GetView<FriendController> {
  const FriendView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    LoginBottomController loginController = Get.put(LoginBottomController());
    FriendController controller = Get.put(FriendController());
    final paddingTop = MediaQueryData.fromWindow(window).padding.top;
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: Button(),
        title: GestureDetector(
          onTap: () => showModalBottomSheet(
            isScrollControlled: true,
            context: context,
            builder: (BuildContext context) {
              return Container(
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
                                          Container(
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
                                                  Container(
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
                                                  )
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
                                                  Container(
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
              );
            },
          ),
          child: Icon(
            IconFont.bolt_circle,
            size: 30,
            color: Colors.white,
          ),
        ),
        actions: [
          GestureDetector(
            // onTap: () => Get.to(() => SearchUserView()),
            child: Icon(
              Icons.search,
              size: 32,
              color: Colors.white,
            ),
          ),
          SizedBox(width: 10.w),
        ],
        centerTitle: true,
        automaticallyImplyLeading: false,
        elevation: 0,
      ),
      body: Container(
        color: Colors.black,
        padding: EdgeInsets.symmetric(horizontal: 14),
        child: Column(
          children: [
            SizedBox(height: 142.h),
            SizedBox(
              width: size.width,
              height: 80.h,
              child: Stack(
                children: [
                  Positioned(
                    top: 7.h,
                    left: size.width / 2 - 87.w,
                    child: SizedBox(
                      width: 56.w,
                      height: 56.h,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(28.r),
                        child: Image.asset(
                          'assets/images/nologin.jpeg',
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 7.h,
                    left: size.width / 2,
                    child: SizedBox(
                      width: 56.w,
                      height: 56.h,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(28.r),
                        child: Image.asset(
                          'assets/images/nologin.jpeg',
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 0,
                    left: size.width / 2 - 51.w,
                    child: Container(
                      width: 70.w,
                      height: 70.h,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(35.r),
                        color: Colors.pinkAccent,
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(35.r),
                        child: Image.asset(
                          'assets/images/nologin.png',
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 26.h),
            Text(
              '发现通讯录朋友',
              style: BaseStyle.fs18Wb,
            ),
            SizedBox(height: 10.h),
            Text(
              '你身边的朋友在用HanTok，快去看看吧',
              style: BaseStyle.fs14G,
            ),
            SizedBox(height: 20.h),
            Container(
              width: size.width,
              alignment: Alignment.center,
              margin: EdgeInsets.symmetric(horizontal: 28),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5.r),
                color: Colors.pinkAccent,
              ),
              padding: EdgeInsets.symmetric(vertical: 13),
              child: Text(
                '查看',
                style: BaseStyle.fs16W.copyWith(fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(height: 94.h),
            Container(
              foregroundDecoration: BoxDecoration(
                color: BaseData.bodyColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10.r),
              ),
              padding: EdgeInsets.all(10),
              child: Column(
                children: [
                  ListTile(
                    leading: Container(
                      width: 48.w,
                      height: 48.h,
                      foregroundDecoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(24.r),
                        color:
                            Config.primarySwatchColor.shade50.withOpacity(.1),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20.r),
                        child: Icon(
                          IconFont.weixin,
                          color: Colors.green,
                          size: 28,
                        ),
                      ),
                    ),
                    title: Text(
                      '快速添加微信好友',
                      style: BaseStyle.fs14.copyWith(color: Colors.white),
                    ),
                    trailing: Icon(
                      Icons.arrow_forward_ios,
                      size: 20,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 16.h),
                  ListTile(
                    leading: Container(
                      width: 48.w,
                      height: 48.h,
                      padding: EdgeInsets.all(9.w),
                      foregroundDecoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(24.r),
                        color:
                            Config.primarySwatchColor.shade50.withOpacity(.1),
                      ),
                      child: SvgPicture.asset(
                        "assets/svg/QQ1.svg",
                      ),
                    ),
                    title: Text(
                      '快速添加QQ好友',
                      style: BaseStyle.fs14.copyWith(color: Colors.white),
                    ),
                    trailing: Icon(
                      Icons.arrow_forward_ios,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
