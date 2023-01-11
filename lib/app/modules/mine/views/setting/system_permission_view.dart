// ignore_for_file: prefer_const_constructors

import 'package:app_settings/app_settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';

import '../../../../data/base_data.dart';
import '../../../../data/base_style.dart';
import '../../../../data/theme_data.dart';

class SystemPermissionView extends GetView {
  const SystemPermissionView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: BaseData.bodyColor,
        elevation: 0,
        title: Text(
          '系统权限',
          style: BaseStyle.fs18,
        ),
        leading: GestureDetector(
          onTap: () => Get.back(),
          child: Icon(
            Icons.arrow_back_ios,
            color: Colors.black,
            size: 24,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          SizedBox(height: 40.h),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 16.w),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              children: [
                ListTile(
                  onTap: () => {
                    showModalBottomSheet<void>(
                      context: context,
                      isDismissible: true,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20),
                        ),
                      ),
                      builder: (BuildContext context) {
                        return Container(
                          height: 315.h,
                          color: Colors.white,
                          margin: EdgeInsets.symmetric(horizontal: 16.w),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(height: 16.h),
                              Row(
                                children: [
                                  Spacer(),
                                  GestureDetector(
                                    onTap: () => Get.back(),
                                    child: Container(
                                      width: 32.w,
                                      height: 32.w,
                                      decoration: BoxDecoration(
                                        color:
                                            Config.primarySwatchColor.shade50,
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(32.r),
                                        ),
                                      ),
                                      child: Icon(
                                        Icons.close,
                                        size: 20,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                width: 72.w,
                                height: 72.w,
                                child: Image(
                                    image: AssetImage(
                                        'assets/images/xiangce.png')),
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(vertical: 16.h),
                                child: Text(
                                  '相册权限',
                                  style: BaseStyle.fs16.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              Text(
                                '关闭后，将无法上传相册中的照片或视频进行发布，也无法下载作品到你的相册。',
                                textAlign: TextAlign.center,
                                style: BaseStyle.fs12G,
                              ),
                              SizedBox(height: 26.h),
                              Padding(
                                padding: EdgeInsets.only(
                                  bottom: 16.h,
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    GestureDetector(
                                      onTap: () => {
                                        Get.back(),
                                      },
                                      child: Container(
                                        alignment: Alignment.center,
                                        width: (size.width - 42.w) / 2,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(5.r),
                                          color: BaseData.bodyColor,
                                        ),
                                        padding: EdgeInsets.symmetric(
                                          vertical: 15,
                                        ),
                                        child: Text(
                                          '再想想',
                                          style: BaseStyle.fs16.copyWith(
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 10.w),
                                    GestureDetector(
                                      onTap: () =>
                                          AppSettings.openLocationSettings(),
                                      child: Container(
                                        alignment: Alignment.center,
                                        width: (size.width - 42.w) / 2,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(5.r),
                                          color: Colors.pinkAccent,
                                        ),
                                        padding: EdgeInsets.symmetric(
                                          vertical: 15,
                                        ),
                                        child: Text(
                                          '去设置',
                                          style: BaseStyle.fs16W.copyWith(
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    )
                  },
                  minLeadingWidth: 15.w,
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '相机权限',
                        style: BaseStyle.fs14,
                      ),
                      Text(
                        '去设置',
                        style: BaseStyle.fs14G,
                      )
                    ],
                  ),
                  trailing: Icon(
                    Icons.arrow_forward_ios,
                    size: 16,
                  ),
                ),
                Container(
                  height: 1.h,
                  color: Config.primarySwatchColor.shade50,
                  margin: EdgeInsets.only(left: 16.w),
                ),
                ListTile(
                  onTap: () => {
                    showModalBottomSheet<void>(
                      context: context,
                      isDismissible: true,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20),
                        ),
                      ),
                      builder: (BuildContext context) {
                        return Container(
                          height: 315.h,
                          color: Colors.white,
                          margin: EdgeInsets.symmetric(horizontal: 16.w),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(height: 16.h),
                              Row(
                                children: [
                                  Spacer(),
                                  GestureDetector(
                                    onTap: () => Get.back(),
                                    child: Container(
                                      width: 32.w,
                                      height: 32.w,
                                      decoration: BoxDecoration(
                                        color:
                                            Config.primarySwatchColor.shade50,
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(32.r),
                                        ),
                                      ),
                                      child: Icon(
                                        Icons.close,
                                        size: 20,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                width: 72.w,
                                height: 72.w,
                                child: Image(
                                  image:
                                      AssetImage('assets/images/location.png'),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(vertical: 16.h),
                                child: Text(
                                  '位置权限',
                                  style: BaseStyle.fs16.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              Text(
                                '关闭后，将无法为你推荐位置相关的服务。',
                                textAlign: TextAlign.center,
                                style: BaseStyle.fs12G,
                              ),
                              SizedBox(height: 26.h),
                              Padding(
                                padding: EdgeInsets.only(bottom: 16.h),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    GestureDetector(
                                      onTap: () => {
                                        Get.back(),
                                      },
                                      child: Container(
                                        alignment: Alignment.center,
                                        width: (size.width - 42.w) / 2,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(5.r),
                                          color: BaseData.bodyColor,
                                        ),
                                        padding:
                                            EdgeInsets.symmetric(vertical: 15),
                                        child: Text(
                                          '再想想',
                                          style: BaseStyle.fs16.copyWith(
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 10.w),
                                    GestureDetector(
                                      onTap: () =>
                                          AppSettings.openLocationSettings(),
                                      child: Container(
                                        alignment: Alignment.center,
                                        width: (size.width - 42.w) / 2,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(5.r),
                                          color: Colors.pinkAccent,
                                        ),
                                        padding:
                                            EdgeInsets.symmetric(vertical: 15),
                                        child: Text(
                                          '去设置',
                                          style: BaseStyle.fs16W.copyWith(
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    )
                  },
                  minLeadingWidth: 15.w,
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '位置权限',
                        style: BaseStyle.fs14,
                      ),
                      Text(
                        '去设置',
                        style: BaseStyle.fs14G,
                      )
                    ],
                  ),
                  trailing: Icon(
                    Icons.arrow_forward_ios,
                    size: 16,
                  ),
                ),
                Container(
                  height: 1.h,
                  color: Config.primarySwatchColor.shade50,
                  margin: EdgeInsets.only(left: 16.w),
                ),
                ListTile(
                  onTap: () => {
                    showModalBottomSheet<void>(
                      context: context,
                      isDismissible: true,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20),
                        ),
                      ),
                      builder: (BuildContext context) {
                        return Container(
                          height: 315.h,
                          color: Colors.white,
                          margin: EdgeInsets.symmetric(horizontal: 16.w),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(height: 16.h),
                              Row(
                                children: [
                                  Spacer(),
                                  GestureDetector(
                                    onTap: () => Get.back(),
                                    child: Container(
                                      width: 32.w,
                                      height: 32.w,
                                      decoration: BoxDecoration(
                                        color:
                                            Config.primarySwatchColor.shade50,
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(32.r),
                                        ),
                                      ),
                                      child: Icon(
                                        Icons.close,
                                        size: 20,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                width: 72.w,
                                height: 72.w,
                                child: Image(
                                  image: AssetImage('assets/images/photo.png'),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(vertical: 16.h),
                                child: Text(
                                  '相册权限',
                                  style: BaseStyle.fs16.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              Text(
                                '关闭后，将无法使用抖音拍摄作品。',
                                textAlign: TextAlign.center,
                                style: BaseStyle.fs12G,
                              ),
                              SizedBox(height: 26.h),
                              Padding(
                                padding: EdgeInsets.only(bottom: 16.h),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    GestureDetector(
                                      onTap: () => {
                                        Get.back(),
                                      },
                                      child: Container(
                                        alignment: Alignment.center,
                                        width: (size.width - 42.w) / 2,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(5.r),
                                          color: BaseData.bodyColor,
                                        ),
                                        padding:
                                            EdgeInsets.symmetric(vertical: 15),
                                        child: Text(
                                          '再想想',
                                          style: BaseStyle.fs16.copyWith(
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 10.w),
                                    GestureDetector(
                                      onTap: () =>
                                          AppSettings.openLocationSettings(),
                                      child: Container(
                                        alignment: Alignment.center,
                                        width: (size.width - 42.w) / 2,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(5.r),
                                          color: Colors.pinkAccent,
                                        ),
                                        padding:
                                            EdgeInsets.symmetric(vertical: 15),
                                        child: Text(
                                          '去设置',
                                          style: BaseStyle.fs16W.copyWith(
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    )
                  },
                  minLeadingWidth: 15.w,
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '相册权限',
                        style: BaseStyle.fs14,
                      ),
                      Text(
                        '去设置',
                        style: BaseStyle.fs14G,
                      )
                    ],
                  ),
                  trailing: Icon(
                    Icons.arrow_forward_ios,
                    size: 16,
                  ),
                ),
                Container(
                  height: 1.h,
                  color: Config.primarySwatchColor.shade50,
                  margin: EdgeInsets.only(left: 16.w),
                ),
                ListTile(
                  onTap: () => {
                    showModalBottomSheet<void>(
                      context: context,
                      isDismissible: true,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20),
                        ),
                      ),
                      builder: (BuildContext context) {
                        return Container(
                          height: 315.h,
                          color: Colors.white,
                          margin: EdgeInsets.symmetric(horizontal: 16.w),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(height: 16.h),
                              Row(
                                children: [
                                  Spacer(),
                                  GestureDetector(
                                    onTap: () => Get.back(),
                                    child: Container(
                                      width: 32.w,
                                      height: 32.w,
                                      decoration: BoxDecoration(
                                        color:
                                            Config.primarySwatchColor.shade50,
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(32.r),
                                        ),
                                      ),
                                      child: Icon(
                                        Icons.close,
                                        size: 20,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                width: 72.w,
                                height: 72.w,
                                child: Image(
                                  image:
                                      AssetImage('assets/images/maikefeng.png'),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(vertical: 16.h),
                                child: Text(
                                  '麦克风权限',
                                  style: BaseStyle.fs16.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              Text(
                                '关闭后，将无法使用抖音拍摄作品。',
                                textAlign: TextAlign.center,
                                style: BaseStyle.fs12G,
                              ),
                              SizedBox(height: 26.h),
                              Padding(
                                padding: EdgeInsets.only(bottom: 16.h),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    GestureDetector(
                                      onTap: () => {
                                        Get.back(),
                                      },
                                      child: Container(
                                        alignment: Alignment.center,
                                        width: (size.width - 42.w) / 2,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(5.r),
                                          color: BaseData.bodyColor,
                                        ),
                                        padding:
                                            EdgeInsets.symmetric(vertical: 15),
                                        child: Text(
                                          '再想想',
                                          style: BaseStyle.fs16.copyWith(
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 10.w),
                                    GestureDetector(
                                      onTap: () =>
                                          AppSettings.openLocationSettings(),
                                      child: Container(
                                        alignment: Alignment.center,
                                        width: (size.width - 42.w) / 2,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(5.r),
                                          color: Colors.pinkAccent,
                                        ),
                                        padding:
                                            EdgeInsets.symmetric(vertical: 15),
                                        child: Text(
                                          '去设置',
                                          style: BaseStyle.fs16W.copyWith(
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    )
                  },
                  minLeadingWidth: 15.w,
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '麦克风权限',
                        style: BaseStyle.fs14,
                      ),
                      Text(
                        '去设置',
                        style: BaseStyle.fs14G,
                      )
                    ],
                  ),
                  trailing: Icon(
                    Icons.arrow_forward_ios,
                    size: 16,
                  ),
                ),
                Container(
                  height: 1.h,
                  color: Config.primarySwatchColor.shade50,
                  margin: EdgeInsets.only(left: 16.w),
                ),
                ListTile(
                  onTap: () => AppSettings.openLocationSettings(),
                  minLeadingWidth: 15.w,
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '其他权限',
                        style: BaseStyle.fs14,
                      ),
                      Text(
                        '去设置',
                        style: BaseStyle.fs14G,
                      )
                    ],
                  ),
                  trailing: Icon(
                    Icons.arrow_forward_ios,
                    size: 16,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
