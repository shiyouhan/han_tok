// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';

import '../../../../../data/base_data.dart';
import '../../../../../data/base_style.dart';
import '../../../../login/controllers/login_bottom_controller.dart';
import '../../info/info_qrcode_view.dart';
import 'account_device_view.dart';
import 'account_password_view.dart';

class AccountSecurityView extends GetView {
  const AccountSecurityView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    LoginBottomController loginController = Get.put(LoginBottomController());
    return Scaffold(
      appBar: AppBar(
        backgroundColor: BaseData.bodyColor,
        elevation: 0,
        title: Text(
          '账号与安全',
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
          ListTile(
            title: Text(
              'HanTokID',
              style: BaseStyle.fs14,
            ),
            trailing: Obx(
              () => Text(
                loginController.hantokNum.value,
                style: BaseStyle.fs14G,
              ),
            ),
          ),
          ListTile(
            onTap: () => Get.to(() => InfoQrcodeView()),
            title: Text(
              '我的二维码',
              style: BaseStyle.fs14,
            ),
            trailing: Icon(
              Icons.arrow_forward_ios,
              size: 16,
            ),
          ),
          ListTile(
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '手机号绑定',
                  style: BaseStyle.fs14,
                ),
                Obx(
                  () => Text(
                    loginController.mobile.value
                        .toString()
                        .replaceFirst(RegExp(r'\d{4}'), '****', 3),
                    style: BaseStyle.fs14G,
                  ),
                ),
              ],
            ),
            trailing: Icon(
              Icons.arrow_forward_ios,
              size: 16,
            ),
          ),
          ListTile(
            title: Text(
              '第三方账号绑定',
              style: BaseStyle.fs14,
            ),
            trailing: Icon(
              Icons.arrow_forward_ios,
              size: 16,
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 16.w),
            color: Colors.grey,
            height: 1.h,
          ),
          ListTile(
            onTap: () => Get.to(() => AccountPasswordView()),
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'HanTok密码',
                  style: BaseStyle.fs14,
                ),
                Obx(
                  () => Text(
                    loginController.password.value == '' ? '未设置' : '已设置',
                    style: BaseStyle.fs14G,
                  ),
                ),
              ],
            ),
            trailing: Icon(
              Icons.arrow_forward_ios,
              size: 16,
            ),
          ),
          ListTile(
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '实名认证',
                  style: BaseStyle.fs14,
                ),
                Text(
                  '未认证',
                  style: BaseStyle.fs14G,
                )
              ],
            ),
            trailing: Icon(
              Icons.arrow_forward_ios,
              size: 16,
            ),
          ),
          ListTile(
            onTap: () => Get.to(() => AccountDeviceView()),
            title: Text(
              '登录设备管理',
              style: BaseStyle.fs14,
            ),
            trailing: Icon(
              Icons.arrow_forward_ios,
              size: 16,
            ),
          ),
        ],
      ),
    );
  }
}
