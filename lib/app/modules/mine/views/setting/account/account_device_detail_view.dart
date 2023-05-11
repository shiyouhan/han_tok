// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';

import '../../../../../data/base_data.dart';
import '../../../../../data/base_style.dart';
import '../../../../login/controllers/login_bottom_controller.dart';
import '../../../controllers/account_device_controller.dart';
import '../../../controllers/mine_controller.dart';

class AccountDeviceDetailView extends GetView {
  const AccountDeviceDetailView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    AccountDeviceController deviceController =
        Get.put(AccountDeviceController());
    LoginBottomController loginController = Get.put(LoginBottomController());
    MineController mineController = Get.put(MineController());

    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: BaseData.bodyColor,
        elevation: 0,
        title: Text(
          '设备详情',
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
      body: Container(
        color: Colors.white,
        width: size.width,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(vertical: 16.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '登录设备',
                      style: BaseStyle.fs12G,
                    ),
                    SizedBox(height: 10),
                    Text(deviceController.deviceName.value),
                  ],
                ),
              ),
              Container(
                height: 1.h,
                color: BaseData.bodyColor,
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 16.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '最近活跃时间',
                      style: BaseStyle.fs12G,
                    ),
                    SizedBox(height: 10),
                    Text(loginController.time.value),
                  ],
                ),
              ),
              Container(
                height: 1.h,
                color: BaseData.bodyColor,
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 16.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '登录地点',
                      style: BaseStyle.fs12G,
                    ),
                    SizedBox(height: 10),
                    Obx(
                      () => Text(loginController.city.value.substring(0, loginController.city.value.length - 1)),
                    ),
                      // .substring(0, mineController.city.value.length - 1)
                  ],
                ),
              ),
              Container(
                height: 1.h,
                color: BaseData.bodyColor,
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 16.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '登录方式',
                      style: BaseStyle.fs12G,
                    ),
                    SizedBox(height: 10),
                    Text(
                        loginController.loginWay.value == 1 ? '验证码登录' : '密码登录'),
                  ],
                ),
              ),
              Container(
                height: 1.h,
                color: BaseData.bodyColor,
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 16.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '登录应用',
                      style: BaseStyle.fs12G,
                    ),
                    SizedBox(height: 10),
                    Text('HanTok'),
                  ],
                ),
              ),
              Container(
                height: 1.h,
                color: BaseData.bodyColor,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
