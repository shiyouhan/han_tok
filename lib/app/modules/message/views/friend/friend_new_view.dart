import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';

import '../../../../data/base_style.dart';

class FriendNewView extends GetView {
  const FriendNewView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: SizedBox(
        width: size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '暂时没有更多了',
              style: BaseStyle.fs16.copyWith(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10.h),
            Text(
              '最近没有新朋友关注我',
              style: BaseStyle.fs14G,
            )
          ],
        ),
      ),
    );
  }
}
