// ignore_for_file: avoid_print, prefer_const_constructors, must_be_immutable

import 'dart:async';

import 'package:country_calling_code_picker/country.dart';
import 'package:country_calling_code_picker/country_code_picker.dart';
import 'package:country_calling_code_picker/functions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:get/get.dart';

import '../../../data/base_style.dart';
import '../../../data/theme_data.dart';
import '../../../utils/Iconfont.dart';
import '../controllers/login_bottom_controller.dart';

class LoginBottomView extends GetView {
  const LoginBottomView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    LoginBottomController controller = Get.put(LoginBottomController());
    final size = MediaQuery.of(context).size;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 32.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 50.h),
            Text(
              '登录后即可展示自己',
              style: BaseStyle.fs20.copyWith(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 12.h),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Obx(
                  () => Radio(
                    value: true,
                    groupValue: controller.isSelected.value,
                    activeColor: Colors.blue,
                    splashRadius: 4.r,
                    onChanged: (value) {
                      controller.radioSelect(value);
                      print(value);
                    },
                  ),
                ),
                SizedBox(
                  width: size.width * 0.7,
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
                        TextSpan(
                          text: '以及',
                          style: BaseStyle.fs12G,
                        ),
                        TextSpan(
                          text: ' 运营商服务协议 ',
                          style: BaseStyle.fs12.copyWith(color: Colors.blue),
                        ),
                        TextSpan(
                          text: '，运营商将对你提供的手机号进行验证',
                          style: BaseStyle.fs12G,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20.h),
            Container(
              height: 48.h,
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              decoration: BoxDecoration(
                color: Config.primarySwatchColor.shade50,
                borderRadius: BorderRadius.circular(5.r),
              ),
              child: Row(
                children: [
                  SelectCountry(),
                  SizedBox(
                    height: 16.h,
                    width: 1,
                  ),
                  SizedBox(
                    width: size.width * 0.6,
                    child: Obx(
                      () => TextFormField(
                        cursorColor: Colors.red,
                        decoration: InputDecoration(
                          hintText: "请输入手机号码",
                          border: InputBorder.none,
                        ),
                        controller: controller.phoneController.value,
                        onChanged: (value) {
                          controller.phoneNumber(value);
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Code(countdown: 60),
            Padding(
              padding: EdgeInsets.only(top: 10.w, bottom: 16.w),
              child: Text(
                '未注册的手机号验证通过后将自动注册',
                style: BaseStyle.fs12G,
              ),
            ),
            GestureDetector(
              onTap: () => {
                if (controller.isSelected.value == false)
                  {
                    EasyLoading.showToast('请先勾选，同意后再进行登录'),
                  }
                else
                  controller.login(),
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
                  '验证并登录',
                  style: BaseStyle.fs16W.copyWith(fontWeight: FontWeight.bold),
                ),
              ),
            ),
            SizedBox(height: 16.h),
            Row(
              children: [
                Container(
                  height: 48.h,
                  padding: EdgeInsets.symmetric(horizontal: 35.w),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20.r),
                    border: Border.all(
                      color: Config.primarySwatchColor.shade50,
                      width: 1.w,
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        IconFont.yaoshi,
                        // Icons.create_outlined,
                        size: 16,
                      ),
                      SizedBox(width: 6.w),
                      Text(
                        '密码登录',
                        style: BaseStyle.fs12,
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 10.w),
                Container(
                  width: 48.w,
                  height: 48.h,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(24.r),
                    border: Border.all(
                      width: 1.w,
                      color: Config.primarySwatchColor.shade50,
                    ),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20.r),
                    child: Icon(
                      IconFont.weixin,
                      color: Colors.green,
                      size: 28,
                    ),
                  ),
                ),
                SizedBox(width: 10.w),
                Container(
                  width: 48.w,
                  height: 48.h,
                  padding: EdgeInsets.all(9),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(24.r),
                    border: Border.all(
                      width: 1.w,
                      color: Config.primarySwatchColor.shade50,
                    ),
                  ),
                  child: SvgPicture.asset(
                    "assets/svg/QQ1.svg",
                  ),
                ),
                SizedBox(width: 10.w),
                Container(
                  width: 48.w,
                  height: 48.h,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(24.r),
                    border: Border.all(
                      width: 1.w,
                      color: Config.primarySwatchColor.shade50,
                    ),
                  ),
                  child: Icon(
                    IconFont.apple,
                    size: 28,
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

class SelectCountry extends StatefulWidget {
  const SelectCountry({Key? key}) : super(key: key);

  @override
  State<SelectCountry> createState() => _SelectCountryState();
}

class _SelectCountryState extends State<SelectCountry> {
  Country? _selectedCountry;

  @override
  void initState() {
    initCountry();
    super.initState();
  }

  void initCountry() async {
    final country = await getCountryByCountryCode(context, 'CN');
    setState(() {
      _selectedCountry = country;
    });
  }

  @override
  Widget build(BuildContext context) {
    final country = _selectedCountry;
    return GestureDetector(
      onTap: () => _onPressedShowBottomSheet(),
      child: country == null
          ? Container()
          : Row(
              children: [
                Text(
                  country.callingCode,
                  textAlign: TextAlign.center,
                  style: BaseStyle.fs16,
                ),
                Icon(Icons.arrow_drop_down)
              ],
            ),
    );
  }

  void _onPressedShowBottomSheet() async {
    final country = await showCountryPickerSheet(
      context,
      cancelWidget: Positioned(
        right: 4,
        top: -4,
        child: TextButton(
            child: Text(
              'Cancel',
              style: BaseStyle.fs14G,
            ),
            onPressed: () => Navigator.pop(context)),
      ),
    );
    if (country != null) {
      setState(() {
        _selectedCountry = country;
      });
    }
  }
}

class PickerPage extends StatelessWidget {
  const PickerPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Select Country'),
      ),
      body: CountryPickerWidget(
        onSelected: (country) => Navigator.pop(context, country),
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
    _seconds = widget.countdown;
  }

  _startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      _seconds--;
      _verifyStr = '${_seconds}s后重发';
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
    LoginBottomController controller = Get.put(LoginBottomController());

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
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 14.w),
              margin: EdgeInsets.symmetric(vertical: 6.w),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                border: Border.all(width: 1.w, color: Colors.white),
                borderRadius: BorderRadius.circular(5.r),
              ),
              child: Text(
                _verifyStr,
                style: BaseStyle.fs14.copyWith(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
