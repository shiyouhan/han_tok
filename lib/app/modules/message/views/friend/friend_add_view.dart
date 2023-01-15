// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import 'package:get/get.dart';

import '../../../../data/base_data.dart';
import '../../../../data/base_style.dart';
import '../../../../data/theme_data.dart';
import '../../../../utils/Iconfont.dart';

class FriendAddView extends GetView {
  const FriendAddView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        color: Colors.white,
        child: Column(
          children: [
            Container(
              height: 36.h,
              margin: EdgeInsets.all(16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.r),
                color: Config.primarySwatchColor.shade50,
              ),
              child: TextField(
                onChanged: (String value) {},
                cursorColor: Colors.lightBlueAccent,
                decoration: InputDecoration(
                  hintText: '搜索用户名字/HanTok号',
                  hintStyle: TextStyle(color: Colors.grey),
                  prefixIcon: Icon(
                    Icons.search,
                    color: Colors.grey,
                  ),
                  suffixIcon: Icon(
                    Icons.search,
                    color: Colors.grey,
                  ),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(vertical: 10),
                ),
              ),
            ),
            Container(
              height: 88.h,
              padding: EdgeInsets.only(left: 16),
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: 5,
                itemBuilder: (context, index) {
                  FunctionList model = items[index];
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: FunctionListItem(model.iconData, model.title),
                  );
                },
              ),
            ),
            SizedBox(height: 100.h),
            Column(
              children: [
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
                    style:
                        BaseStyle.fs16W.copyWith(fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(height: 94.h),
                Container(
                  decoration: BoxDecoration(
                    color: BaseData.bodyColor,
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  padding: EdgeInsets.all(10),
                  margin: EdgeInsets.symmetric(horizontal: 16.w),
                  child: Column(
                    children: [
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
                      SizedBox(height: 16.h),
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
                    ],
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

class FunctionListItem extends StatelessWidget {
  final IconData iconData;
  final String title;
  const FunctionListItem(this.iconData, this.title, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 78.w,
      height: 78.h,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5.r),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Color(0xFFE8E8E8),
            offset: Offset(2, 2),
            blurRadius: 10,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            iconData,
            size: 32,
          ),
          SizedBox(height: 10.h),
          Text(title),
        ],
      ),
    );
  }
}

class FunctionList {
  IconData iconData;
  String title;

  FunctionList(this.iconData, this.title);
}

final List<FunctionList> items = [
  FunctionList(IconFont.tongxunlu, '通讯录'),
  FunctionList(Icons.qr_code, '二维码'),
  FunctionList(IconFont.saoyisao, '扫一扫'),
  FunctionList(IconFont.id, 'HanTok号'),
  FunctionList(IconFont.yaoshi, '分享加好友'),
];
