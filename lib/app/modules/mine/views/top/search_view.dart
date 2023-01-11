// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';

import '../../../../data/base_style.dart';
import '../../../../data/theme_data.dart';

class SearchView extends GetView {
  const SearchView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Container(
          width: double.infinity,
          height: 36.h,
          color: Config.primarySwatchColor.shade50,
          child: TextField(
            onChanged: (String value) {},
            cursorColor: Colors.lightBlueAccent,
            decoration: InputDecoration(
              hintText: '搜索作品',
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
        centerTitle: false,
        elevation: 0,
        backgroundColor: Colors.white,
        leading: GestureDetector(
          onTap: () => Get.back(),
          child: Icon(Icons.arrow_back_ios),
        ),
        actions: [
          Center(
            child: Padding(
              padding: EdgeInsets.only(right: 16.w),
              child: GestureDetector(
                onTap: () => {},
                child: Text(
                  '搜索',
                  style: BaseStyle.fs16,
                ),
              ),
            ),
          ),
        ],
      ),
      body: Container(
        color: Colors.white,
        child: Center(
          child: Column(
            children: [
              SizedBox(height: size.height * 0.16),
              Text(
                '搜索你赞过、发过的作品',
                style: BaseStyle.fs16,
              ),
              SizedBox(height: 12.h),
              Text(
                '你可以搜索“喜欢”或“作品”内的视频',
                style: BaseStyle.fs14G,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
