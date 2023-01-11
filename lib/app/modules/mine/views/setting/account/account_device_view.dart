// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';

import '../../../../../data/base_data.dart';
import '../../../../../data/base_style.dart';
import '../../../../login/controllers/login_bottom_controller.dart';
import '../../../controllers/account_device_controller.dart';
import 'account_device_detail_view.dart';

class AccountDeviceView extends GetView {
  const AccountDeviceView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    AccountDeviceController controller = Get.put(AccountDeviceController());
    LoginBottomController loginController = Get.put(LoginBottomController());

    return Scaffold(
      appBar: AppBar(
        backgroundColor: BaseData.bodyColor,
        elevation: 0,
        title: Text(
          '登录设备管理',
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
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(vertical: 16.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '登录设备管理显示最近登录过您账户的设备情况',
                      style:
                          BaseStyle.fs12G.copyWith(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      '若您发现非本人操作的设备，请及时移除，并更换密码，以及保障您的账号安全。',
                      style:
                          BaseStyle.fs12G.copyWith(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              InkWell(
                onTap: () => Get.to(() => AccountDeviceDetailView()),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Obx(
                              () => Text(
                                controller.deviceName.value,
                                style: BaseStyle.fs16
                                    .copyWith(fontWeight: FontWeight.w500),
                              ),
                            ),
                            SizedBox(width: 5.w),
                            Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 4.w, vertical: 2.h),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(4.r),
                                color: BaseData.kBackColor,
                              ),
                              child: Text(
                                '本机',
                                style: BaseStyle.fs12G,
                              ),
                            )
                          ],
                        ),
                        Icon(
                          Icons.arrow_forward_ios,
                          size: 12,
                          color: Colors.grey,
                        ),
                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 4.h, bottom: 2.h),
                      child: Text(
                        '${loginController.loginWay.value == 1 ? '验证码登录' : '密码登录'} · HanTok',
                        style: BaseStyle.fs12G,
                      ),
                    ),
                    Obx(
                      () => Text(
                        loginController.time.value,
                        style: BaseStyle.fs12G,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
