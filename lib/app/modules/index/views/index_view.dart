// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/index_controller.dart';
import 'com_view.dart';
import 'follow_view.dart';
import 'recommend_view.dart';

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
          leading: IconButton(
            icon: Icon(
              Icons.add_circle_outline,
              color: Colors.white,
              size: 28,
            ),
            onPressed: () {},
          ),
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

List<Widget> tabView = [
  ComView(),
  FollowView(),
  RecommendView(),
];
