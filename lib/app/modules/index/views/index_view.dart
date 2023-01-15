// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';
import 'package:han_tok/app/utils/Iconfont.dart';
import 'package:popover/popover.dart';

import '../../../data/base_style.dart';
import '../controllers/index_controller.dart';
import 'com_view.dart';
import 'follow_view.dart';
import 'recommend_view.dart';
import 'tabbar/index_scan_view.dart';

class IndexView extends GetView<IndexController> {
  const IndexView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    IndexController controller = Get.put(IndexController());
    final size = MediaQuery.of(context).size;
    return DefaultTabController(
      //导航栏的长度
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: SizedBox(
            width: size.width * 0.4,
            child: TabBar(
              // isScrollable: true, //可滚动
              labelPadding: EdgeInsets.all(0),
              indicatorColor: Colors.white, //指示器的颜色
              labelStyle: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
              labelColor: Colors.white, //选中文字颜色
              unselectedLabelColor: Colors.grey, //为选中文字颜色
              indicatorSize: TabBarIndicatorSize.label, //指示器与文字等宽
              indicatorPadding: EdgeInsets.all(6),
              controller: controller.tabController,
              tabs: controller.tabs.map((e) => Tab(text: e)).toList(),
            ),
          ),
          backgroundColor: Colors.black,
          elevation: 0,
          leading: Button(),
          actions: [
            IconButton(
              icon: Icon(
                Icons.search,
                color: Colors.white,
                size: 28,
              ),
              onPressed: () {},
            ),
          ],
        ),
        body: TabBarView(
          controller: controller.tabController,
          children: tabView,
        ),
      ),
    );
  }
}

class Button extends StatelessWidget {
  const Button({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Icon(
        Icons.add_circle_outline,
        color: Colors.white,
        size: 28,
      ),
      onTap: () {
        showPopover(
          context: context,
          bodyBuilder: (context) => Container(
            margin: EdgeInsets.symmetric(horizontal: 10.w),
            child: Column(
              children: [
                InkWell(
                  onTap: () => Get.to(() => IndexScanView()),
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 10.h),
                    child: Row(
                      children: [
                        Icon(Icons.camera_alt_outlined),
                        SizedBox(width: 6.w),
                        Text(
                          '拍日常',
                          style: BaseStyle.fs16
                              .copyWith(fontWeight: FontWeight.bold),
                        )
                      ],
                    ),
                  ),
                ),
                Container(
                  height: 1.h,
                  color: Colors.grey.withOpacity(.2),
                ),
                InkWell(
                  onTap: () => Get.to(() => IndexScanView()),
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 10.h),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(IconFont.saoyisao),
                        SizedBox(width: 6.w),
                        Text(
                          '扫一扫',
                          style: BaseStyle.fs16
                              .copyWith(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          width: 150.w,
          height: 90.h,
          arrowHeight: 5,
          arrowWidth: 15,
        );
      },
    );
  }
}

List<Widget> tabView = [
  ComView(),
  FollowView(),
  RecommendView(),
];
