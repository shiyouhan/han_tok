// ignore_for_file: prefer_const_constructors, unnecessary_null_comparison, unnecessary_import

import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';
import 'package:han_tok/app/modules/login/views/login_view.dart';

import '../../../data/base_style.dart';
import '../../camera/views/camera_view.dart';
import '../../friend/views/friend_view.dart';
import '../../index/views/index_view.dart';
import '../../login/controllers/login_bottom_controller.dart';
import '../../message/views/message_view.dart';
import '../../mine/views/mine_view.dart';

class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  LoginBottomController loginController = Get.put(LoginBottomController());
  Color bgColor = Color(0xff111215);
  Color textColor = Colors.white;
  Color iconColor = Colors.white;
  Color borderColor = Colors.white;
  Color bottomColor = Color(0xff111215);

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // final size = MediaQuery.of(context).size;
    // final paddingTop = MediaQueryData.fromWindow(window).padding.top;
    return Container(
      color: bottomColor,
      child: SafeArea(
        top: false,
        child: DefaultTabController(
          length: bottomBar.length,
          child: Scaffold(
            bottomNavigationBar: Container(
              color: bgColor,
              child: TabBar(
                unselectedLabelColor: Colors.grey,
                unselectedLabelStyle:
                    BaseStyle.fs16.copyWith(fontWeight: FontWeight.bold),
                labelColor: textColor,
                labelStyle:
                    BaseStyle.fs16.copyWith(fontWeight: FontWeight.bold),
                indicator: const BoxDecoration(),
                tabs: bottomBar.keys.map((e) {
                  if (e == '') {
                    return Container(
                      width: 40.w,
                      height: 32.h,
                      decoration: BoxDecoration(
                        border: Border.all(width: 3.w, color: borderColor),
                        borderRadius: BorderRadius.all(Radius.circular(10.r)),
                      ),
                      child: Tab(
                        icon: Icon(
                          Icons.add,
                          color: iconColor,
                        ),
                      ),
                    );
                  } else {
                    return Tab(
                      text: e,
                    );
                  }
                }).toList(),
                onTap: (e) => {
                  setState(() {
                    bgColor = e > 1 ? Colors.white : Color(0xff111215);
                    textColor = e > 1 ? Colors.black : Colors.white;
                    iconColor = e > 1 ? Colors.black : Colors.white;
                    borderColor = e > 1 ? Colors.black : Colors.white;
                    bottomColor = e > 1 ? Colors.white : Color(0xff111215);
                  }),
                  if (loginController.userToken.value.isEmpty)
                    {
                      Get.to(() => LoginView()),
                      // showModalBottomSheet(
                      //   isScrollControlled: true,
                      //   context: context,
                      //   builder: (BuildContext context) {
                      //     return AnnotatedRegion<SystemUiOverlayStyle>(
                      //       value: SystemUiOverlayStyle.dark,
                      //       child: SizedBox(
                      //         height: size.height,
                      //         child: Column(
                      //           children: [
                      //             // SizedBox(height: paddingTop.h),
                      //             // Padding(
                      //             //   padding:
                      //             //       EdgeInsets.symmetric(horizontal: 16.w),
                      //             //   child: Row(
                      //             //     mainAxisAlignment:
                      //             //         MainAxisAlignment.spaceBetween,
                      //             //     children: [
                      //             //       GestureDetector(
                      //             //         onTap: () => Get.back(),
                      //             //         child: Icon(
                      //             //           Icons.clear,
                      //             //           size: 24,
                      //             //         ),
                      //             //       ),
                      //             //       Text(
                      //             //         '帮助与设置',
                      //             //         style: BaseStyle.fs16,
                      //             //       ),
                      //             //     ],
                      //             //   ),
                      //             // ),
                      //             // LoginBottomView(),
                      //           ],
                      //         ),
                      //       ),
                      //     );
                      //   },
                      // ),
                    },
                  // if (e == 2)
                  //   {
                  //     Get.to(() => CameraView()),
                  //   }
                },
              ),
            ),
            body: TabBarView(
              physics: NeverScrollableScrollPhysics(),
              children: tabView,
            ),
          ),
        ),
      ),
    );
  }
}

Map<String, Icon> bottomBar = {
  '首页': Icon(Icons.add),
  '朋友': Icon(Icons.add),
  '': Icon(Icons.add),
  '消息': Icon(Icons.add),
  '我': Icon(Icons.add),
};

List<Widget> tabView = [
  IndexView(),
  FriendView(),
  CameraView(),
  MessageView(),
  MineView(),
];
