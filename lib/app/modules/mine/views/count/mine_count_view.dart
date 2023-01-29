// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:han_tok/app/data/video/controller/video_controller.dart';
import 'package:han_tok/app/modules/mine/controllers/mine_count_controller.dart';

import '../../../../data/base_style.dart';
import 'mine_fan_view.dart';
import 'mine_follow_view.dart';
import 'mine_friend_view.dart';

class MineCountView extends GetView {
  const MineCountView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    MineCountController controller = Get.put(MineCountController());
    VideoController videoController = Get.put(VideoController());
    final size = MediaQuery.of(context).size;
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: SizedBox(
            width: size.width * 0.4,
            child: TabBar(
              labelPadding: EdgeInsets.zero,
              indicatorColor: Colors.black,
              labelStyle: BaseStyle.fs16.copyWith(fontWeight: FontWeight.bold),
              labelColor: Colors.black,
              unselectedLabelColor: Colors.grey,
              indicatorSize: TabBarIndicatorSize.label,
              controller: controller.tabController,
              tabs: controller.tabs.map((e) => Tab(text: e)).toList(),
            ),
          ),
          elevation: 0,
          leading: GestureDetector(
            onTap: () => {
              videoController.renew(),
              Get.back(),
            },
            child: Icon(
              Icons.arrow_back_ios,
              size: 24,
            ),
          ),
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
  MineFriendView(),
  MineFollowView(),
  MineFanView(),
];
