// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import 'package:get/get.dart';

import '../../../../data/base_data.dart';
import '../../../../data/base_style.dart';
import '../../../../data/theme_data.dart';
import '../../../../utils/Iconfont.dart';

class MineFriendView extends GetView {
  const MineFriendView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 14),
        child: Column(
          children: [
            SizedBox(height: 16.h),
            Container(
              height: 36.h,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.r),
                color: Config.primarySwatchColor.shade50,
              ),
              child: TextField(
                onChanged: (String value) {},
                cursorColor: Colors.red,
                decoration: InputDecoration(
                  hintText: '搜索用户',
                  hintStyle: TextStyle(color: Colors.grey),
                  prefixIcon: Icon(
                    Icons.search,
                    color: Colors.grey,
                  ),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(vertical: 10),
                ),
              ),
            ),
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
              style: BaseStyle.fs18Wb.copyWith(color: Colors.black),
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
              decoration: BoxDecoration(
                color: BaseData.bodyColor,
                borderRadius: BorderRadius.circular(10.r),
              ),
              padding: EdgeInsets.all(10),
              child: Column(
                children: [
                  ListTile(
                    leading: Container(
                      width: 48.w,
                      height: 48.h,
                      padding: EdgeInsets.all(9.w),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(24.r),
                        color: Config.primarySwatchColor.shade50,
                      ),
                      child: SvgPicture.asset(
                        "assets/svg/QQ1.svg",
                      ),
                    ),
                    title: Text(
                      '快速添加QQ好友',
                      style: BaseStyle.fs14,
                    ),
                    trailing: Icon(
                      Icons.arrow_forward_ios,
                      color: Colors.black,
                      size: 20,
                    ),
                  ),
                  SizedBox(height: 16.h),
                  ListTile(
                    leading: Container(
                      width: 48.w,
                      height: 48.h,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(24.r),
                        color: Config.primarySwatchColor.shade50,
                      ),
                      child: Icon(
                        IconFont.weixin,
                        color: Colors.green,
                        size: 28,
                      ),
                    ),
                    title: Text(
                      '快速添加微信好友',
                      style: BaseStyle.fs14,
                    ),
                    trailing: Icon(
                      Icons.arrow_forward_ios,
                      color: Colors.black,
                      size: 20,
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
