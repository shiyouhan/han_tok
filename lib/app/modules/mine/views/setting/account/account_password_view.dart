// ignore_for_file: prefer_const_constructors, avoid_print

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';

import '../../../../../data/base_style.dart';
import '../../../../../data/theme_data.dart';
import '../../../../login/controllers/login_bottom_controller.dart';
import '../../../controllers/account_password_controller.dart';

class AccountPasswordView extends GetView {
  const AccountPasswordView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    LoginBottomController loginController = Get.put(LoginBottomController());
    AccountPasswordController controller = Get.put(AccountPasswordController());

    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        elevation: 1,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 32.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(top: 32.w),
              child: Text(
                '请输入${loginController.password.value == '' ? '' : '新'}登录密码',
                style: BaseStyle.fs18.copyWith(fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 10.w, bottom: 24.w),
              child: Text(
                '密码为6-20位，至少包含字母/数字/符号2种组合',
                style: BaseStyle.fs12G,
              ),
            ),
            Container(
              height: 48.h,
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              decoration: BoxDecoration(
                color: Config.primarySwatchColor.shade50,
                borderRadius: BorderRadius.circular(5.r),
              ),
              child: SizedBox(
                width: size.width - 64.w,
                child: TextFormField(
                  cursorColor: Colors.red,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                  ),
                  controller: controller.passwordController,
                  onChanged: (value) {
                    controller.passwordStr(value);
                    print(controller.number.value);
                  },
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 10, bottom: 18),
              child: Text(
                '通过短信验证可以使用新密码',
                style: BaseStyle.fs12G,
              ),
            ),
            GestureDetector(
              onTap: () => {
                if (controller.number.value >= 6 &&
                    controller.number.value <= 20)
                  {
                    controller.getVerify(),
                  }
                else
                  {
                    EasyLoading.showError('密码不符合规范、请重新输入!'),
                  }
              },
              child: Obx(
                () => Container(
                  width: size.width - 64.w,
                  alignment: Alignment.center,
                  padding: EdgeInsets.symmetric(vertical: 10.h),
                  decoration: BoxDecoration(
                    color: controller.number.value < 6
                        ? Color(0XF8FA9FB7)
                        : Colors.pink,
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  child: Text(
                    '获取短信验证码',
                    style: BaseStyle.fs16.copyWith(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
