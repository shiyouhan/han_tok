// ignore_for_file: prefer_const_constructors, must_be_immutable, avoid_print

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';
import 'package:han_tok/app/modules/login/controllers/login_bottom_controller.dart';

import '../../../data/base_style.dart';
import '../../../data/theme_data.dart';
import '../controllers/reset_password_controller.dart';

class ResetPasswordView extends GetView {
  const ResetPasswordView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    ResetPasswordController controller = Get.put(ResetPasswordController());
    LoginBottomController loginController = Get.put(LoginBottomController());
    final size = MediaQuery.of(context).size;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        elevation: 0,
        leading: GestureDetector(
          onTap: () => Get.back(),
          child: Icon(
            Icons.arrow_back_ios,
            size: 24,
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 32.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 50.h),
            Text(
              '找回密码',
              style: BaseStyle.fs20.copyWith(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10.h),
            Text(
              '验证码已通过短信发送至 +86 ${loginController.phoneController1.value.text}。密码需要6-20位',
              style: BaseStyle.fs12G,
            ),
            Code(countdown: 60),
            SizedBox(height: 10.h),
            Container(
              height: 48.h,
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              decoration: BoxDecoration(
                color: Config.primarySwatchColor.shade50,
                borderRadius: BorderRadius.circular(5.r),
              ),
              child: SizedBox(
                width: size.width - 96.w,
                child: Obx(
                  () => TextFormField(
                    cursorColor: Colors.red,
                    decoration: InputDecoration(
                      hintText: "请输入密码",
                      border: InputBorder.none,
                    ),
                    controller: controller.passwordController.value,
                    onChanged: (value) {
                      controller.passwordNumber(value);
                    },
                  ),
                ),
              ),
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              // mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Obx(
                  () => Radio(
                    value: true,
                    groupValue: controller.isSelected.value,
                    activeColor: Colors.blue,
                    splashRadius: 4.r,
                    materialTapTargetSize: MaterialTapTargetSize.padded,
                    onChanged: (value) {
                      controller.radioSelect(value);
                      // print(value);
                    },
                  ),
                ),
                Container(
                  width: size.width * 0.7,
                  height: 50.h,
                  alignment: Alignment.centerLeft,
                  child: RichText(
                    text: TextSpan(
                      text: '已阅读井同意',
                      style: BaseStyle.fs12G,
                      children: <TextSpan>[
                        TextSpan(
                          text: ' 用户协议 ',
                          style: BaseStyle.fs12.copyWith(color: Colors.blue),
                        ),
                        TextSpan(
                          text: '和',
                          style: BaseStyle.fs12G,
                        ),
                        TextSpan(
                          text: ' 隐私政策 ',
                          style: BaseStyle.fs12.copyWith(color: Colors.blue),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            GestureDetector(
              onTap: () => {
                if (controller.isSelected.value == false)
                  {
                    EasyLoading.showToast('请先勾选，同意后再进行登录'),
                  }
                else
                  controller.resetPassword(),
              },
              child: Container(
                width: size.width - 64.w,
                height: 44.h,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Color(0XF8FA9FB7),
                  borderRadius: BorderRadius.circular(5.r),
                ),
                child: Text(
                  '完成',
                  style: BaseStyle.fs14.copyWith(
                      fontWeight: FontWeight.bold, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Code extends StatefulWidget {
  Code({Key? key, required this.countdown}) : super(key: key);

  /// 倒计时的秒数，默认60秒。
  int countdown;

  @override
  State<Code> createState() => _CodeState();
}

class _CodeState extends State<Code> {
  late Timer _timer;
  late int _seconds;

  String _verifyStr = '获取验证码';

  @override
  void initState() {
    super.initState();
    _startTimer();
    _seconds = widget.countdown;
  }

  _startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      _seconds--;
      _verifyStr = '$_seconds';
      if (_seconds == 0) {
        _verifyStr = '重新获取';
        _seconds = widget.countdown;
        _cancelTimer();
      }
      setState(() {});
    });
  }

  /// 取消倒计时的计时器。
  void _cancelTimer() {
    // 计时器（`Timer`）组件的取消（`cancel`）方法，取消计时器。
    _timer.cancel();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    ResetPasswordController controller = Get.put(ResetPasswordController());

    return Container(
      width: size.width - 64.w,
      height: 44.h,
      alignment: Alignment.center,
      margin: EdgeInsets.only(top: 20.h),
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      decoration: BoxDecoration(
        color: Config.primarySwatchColor.shade50,
        borderRadius: BorderRadius.circular(5.r),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Obx(() => SizedBox(
                width: size.width * 0.48,
                child: TextField(
                  cursorColor: Colors.red,
                  decoration: InputDecoration(
                    hintText: "请输入验证码",
                    border: InputBorder.none,
                  ),
                  keyboardType: TextInputType.number,
                  controller: controller.codeController.value,
                  onChanged: (value) {
                    controller.codeNumber(value);
                    // print(value);
                  },
                ),
              )),
          GestureDetector(
            onTap: _seconds == widget.countdown
                ? () {
                    controller.getVerify();
                    _startTimer();
                  }
                : null,
            child: Text(
              _verifyStr,
              style: (_verifyStr == '获取验证码' || _verifyStr == '重新获取')
                  ? BaseStyle.fs14.copyWith(color: Colors.red.withOpacity(.8))
                  : BaseStyle.fs14G,
            ),
          ),
        ],
      ),
    );
  }
}
