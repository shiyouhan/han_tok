// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../../../../data/base_style.dart';
import 'friend_add_view.dart';
import 'friend_new_view.dart';
import 'friend_single_view.dart';

class FriendsView extends StatefulWidget {
  const FriendsView({Key? key}) : super(key: key);

  @override
  State<FriendsView> createState() => _FriendsViewState();
}

class _FriendsViewState extends State<FriendsView>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: tabView.length, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return DefaultTabController(
      //导航栏的长度
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: SizedBox(
            width: size.width * 0.7,
            child: TabBar(
              // isScrollable: true,
              labelPadding: EdgeInsets.symmetric(horizontal: 10),
              indicatorColor: Colors.black,
              labelStyle: BaseStyle.fs16.copyWith(fontWeight: FontWeight.bold),
              labelColor: Colors.black,
              unselectedLabelStyle: BaseStyle.fs16
                  .copyWith(fontWeight: FontWeight.bold, color: Colors.grey),
              unselectedLabelColor: Colors.grey,
              indicatorSize: TabBarIndicatorSize.label,
              controller: _tabController,
              tabs: <Widget>[
                Tab(text: "朋友"),
                Tab(text: "新朋友"),
                Tab(text: "添加朋友"),
              ],
            ),
          ),
          // backgroundColor: Colors.black,
          elevation: 0,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios,
              size: 28,
              color: Colors.black,
            ),
            onPressed: () => Get.back(),
          ),
        ),
        body: TabBarView(
          controller: _tabController,
          children: tabView,
        ),
      ),
    );
  }
}

List<Widget> tabView = [
  FriendSingleView(),
  FriendNewView(),
  FriendAddView(),
];
