// ignore_for_file: avoid_print, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';

import '../../../../data/base_style.dart';
import '../../../login/controllers/login_bottom_controller.dart';
import '../../controllers/info_desc_controller.dart';

class InfoDescView extends GetView<InfoDescController> {
  const InfoDescView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    InfoDescController controller = Get.put(InfoDescController());
    LoginBottomController loginController = Get.put(LoginBottomController());
    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        title: Text(
          '修改简介',
          style: BaseStyle.fs18,
        ),
        actions: [
          Center(
            child: Padding(
                padding: EdgeInsets.only(right: 16.w),
                child: GestureDetector(
                  onTap: () => controller.modify(),
                  child: Obx(
                    () => Text(
                      '保存',
                      style: BaseStyle.fs16.copyWith(
                        color: controller.isChange.value == false
                            ? Color(0XF8FA9FB7)
                            : Colors.red,
                      ),
                    ),
                  ),
                )),
          )
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(16.w),
        child: TextFormField(
          maxLines: 10,
          cursorColor: Colors.red,
          decoration: InputDecoration(
            hintText: loginController.description.value,
            // hintText: '添加简介，让大家更好的认识你',
            border: InputBorder.none,
          ),
          controller: controller.descController,
          onChanged: (value) {
            controller.descStr(value);
            print(controller.isChange.value);
          },
        ),
      ),
    );
  }
}
