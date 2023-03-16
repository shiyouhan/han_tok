// ignore_for_file: prefer_const_constructors

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';
import 'package:han_tok/app/data/base_style.dart';
import 'package:han_tok/app/modules/login/views/login_view.dart';

// class StartView extends GetView {
//   const StartView({Key? key}) : super(key: key);
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Center(
//         child: Text(
//           'StartView is working',
//           style: TextStyle(fontSize: 20),
//         ),
//       ),
//     );
//   }
// }

class StartView extends StatefulWidget {
  const StartView({Key? key}) : super(key: key);

  @override
  State<StartView> createState() => _StartViewState();
}

class _StartViewState extends State<StartView> {
  late Timer _countTimer;
  int _countDown = 5;

  @override
  void initState() {
    super.initState();
    _startCountDown();
  }

  void _startCountDown() {
    _countTimer = Timer.periodic(
      Duration(seconds: 1),
      (timer) {
        setState(() {
          if (_countDown == 1) {
            Get.to(() => LoginView());
            _countTimer.cancel();
          } else {
            _countDown -= 1; //计数器减1
          }
        });
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
    _countTimer.cancel();
    _countDown = 0;
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: AnnotatedRegion<SystemUiOverlayStyle>(
          value: SystemUiOverlayStyle.light,
          child: Container(
            color: Color(0xff111215),
            child: SafeArea(
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Container(
                    color: Color(0xff111215),
                    child: Center(
                        child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset('assets/images/logo.png',
                            width: 120.w, height: 120.h),
                        Padding(
                          padding: EdgeInsets.only(top: 8.h),
                          child: Text(
                            'HanTok',
                            style: BaseStyle.fs20W
                                .copyWith(fontWeight: FontWeight.bold, fontSize: 36.sp),
                          ),
                        ),
                      ],
                    )),
                  ),
                  Positioned(
                    top: 30,
                    right: 30,
                    child: GestureDetector(
                      onTap: () => Get.to(() => LoginView()),
                      child: Container(
                        decoration: BoxDecoration(
                          // color: Colors.grey[350],
                          border: Border.all(width: 1, color: Colors.white38),
                          borderRadius: BorderRadius.all(
                            Radius.circular(45),
                          ),
                        ),
                        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                        child: RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: "跳过($_countDown)",
                                style: TextStyle(color: Colors.white54),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 10,
                    left: size.width / 2 - 49.w,
                    child: Text(
                      '短视频社交应用',
                      style: BaseStyle.fs14.copyWith(color: Colors.white54),
                    ),
                  ),
                ],
              ),
            ),
          )),
    );
  }
}
