// ignore_for_file: prefer_const_constructors, avoid_print

import 'package:country_calling_code_picker/country.dart';
import 'package:country_calling_code_picker/functions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';

import '../../../data/base_style.dart';
import '../../../data/theme_data.dart';
import '../controllers/login_bottom_controller.dart';

class LoginPasswordView extends GetView {
  const LoginPasswordView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    LoginBottomController controller = Get.put(LoginBottomController());
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
        actions: [
          Center(
            child: Padding(
              padding: EdgeInsets.only(right: 16.w),
              child: Text(
                '帮助与设置',
                style: BaseStyle.fs16,
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 32.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 50.h),
            Text(
              '手机号密码登录',
              style: BaseStyle.fs20.copyWith(fontWeight: FontWeight.bold),
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
                        keyboardType: TextInputType.number,
                        controller: controller.phoneController1.value,
                        onChanged: (value) {
                          controller.phoneNumber(value);
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
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
                    groupValue: controller.isSelected2.value,
                    activeColor: Colors.blue,
                    splashRadius: 4.r,
                    materialTapTargetSize: MaterialTapTargetSize.padded,
                    onChanged: (value) {
                      controller.radioTwo(value);
                      print(value);
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
                if (controller.isSelected2.value == false)
                  {
                    EasyLoading.showToast('请先勾选，同意后再进行登录'),
                  }
                else
                  controller.passwordLogin(),
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
                  '登录',
                  style: BaseStyle.fs16W.copyWith(fontWeight: FontWeight.bold),
                ),
              ),
            ),
            SizedBox(height: 16.h),
            GestureDetector(
              onTap: () => {
                if (controller.phoneController1.value.text.length == 11)
                  {
                    controller.getCode(),
                  }
                else if (controller.phoneController1.value.text.isEmpty)
                  {
                    EasyLoading.showToast('请输入正确的手机号'),
                  }
                else
                  {
                    EasyLoading.showError('手机号不符合规范、请重新输入!'),
                  }
              },
              child: Row(
                children: [
                  Text(
                    '忘记了? ',
                    style: BaseStyle.fs12G,
                  ),
                  Text(
                    '找回密码',
                    style: BaseStyle.fs12.copyWith(color: Colors.blue),
                  )
                ],
              ),
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
