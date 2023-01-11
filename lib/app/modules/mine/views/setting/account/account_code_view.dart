// ignore_for_file: prefer_const_constructors, must_be_immutable

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';

import '../../../../../data/base_style.dart';
import '../../../../../data/theme_data.dart';
import '../../../../login/controllers/login_bottom_controller.dart';
import '../../../controllers/account_code_controller.dart';

class AccountCodeView extends GetView {
  const AccountCodeView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    AccountCodeController controller = Get.put(AccountCodeController());
    LoginBottomController loginController = Get.put(LoginBottomController());
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
                '请输入验证码',
                style: BaseStyle.fs18.copyWith(fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 10.w, bottom: 24.w),
              child: Text(
                '验证码已通过短信发送至 ${loginController.mobile.value.toString().replaceFirst(RegExp(r'\d{4}'), '****', 3)}',
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
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        width: size.width * 0.50,
                        child: TextFormField(
                          cursorColor: Colors.red,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                          ),
                          controller: controller.codeController,
                          onChanged: (value) {
                            controller.codeStr(value);
                          },
                        ),
                      ),
                      Code(countdown: 60),
                    ],
                  )),
            ),
            SizedBox(height: 18.h),
            GestureDetector(
              onTap: () => controller.modifyPassword(),
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
                    '完成',
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

class Code extends StatefulWidget {
  Code({Key? key, required this.countdown}) : super(key: key);

  /// 倒计时的秒数，默认60秒。
  int countdown;

  @override
  State<Code> createState() => _CodeState();
}

class _CodeState extends State<Code> {
  String _verifyStr = '';

  /// 倒计时的计时器。
  late Timer _timer;

  /// 当前倒计时的秒数。
  late int _seconds;

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
    LoginBottomController controller = Get.put(LoginBottomController());

    return GestureDetector(
      onTap: _seconds == widget.countdown
          ? () {
              controller.getVerify();
              _startTimer();
            }
          : null,
      child: Text(
        _verifyStr,
        style: BaseStyle.fs14G,
      ),
    );
  }
}
