// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';
import 'package:han_tok/app/data/base_data.dart';
import 'package:han_tok/app/modules/camera/controllers/camera_detail_controller.dart';

import '../../../data/base_style.dart';

class CameraDetailView extends GetView {
  const CameraDetailView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    CameraDetailController controller = Get.put(CameraDetailController());

    final size = MediaQuery.of(context).size;

    void hideKeyboard(BuildContext context) {
      FocusScopeNode currentFocus = FocusScope.of(context);
      if (!currentFocus.hasPrimaryFocus && currentFocus.focusedChild != null) {
        FocusManager.instance.primaryFocus!.unfocus();
      }
    }

    return SafeArea(
      child: Scaffold(
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
        body: GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: (() {
            hideKeyboard(context);
          }),
          child: Padding(
            padding: EdgeInsets.all(16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  color: Colors.white,
                  child: TextFormField(
                    maxLines: 10,
                    cursorColor: Colors.red,
                    // focusNode: focusNode,
                    decoration: InputDecoration(
                      hintText: '添加作品描述...',
                      // hintText: '添加简介，让大家更好的认识你',
                      border: InputBorder.none,
                    ),
                    controller: controller.contentController,
                    onChanged: (value) {
                      controller.contentStr(value);
                    },
                  ),
                ),
                Container(
                  width: size.width,
                  height: 1.h,
                  color: BaseData.bodyColor,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 4),
                  child: Text(
                    '视频缩略图',
                    style: BaseStyle.fs12G,
                  ),
                ),
                Obx(
                  () => Image.network(
                    // cameraController.coverUrl.value,
                    controller.cover.value,
                    width: 80.w,
                    height: 120.h,
                    fit: BoxFit.fill,
                  ),
                ),
                Spacer(),
                GestureDetector(
                  onTap: () => controller.createVideo(),
                  behavior: HitTestBehavior.opaque,
                  child: Container(
                    width: size.width - 32.w,
                    height: 44.h,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Color(0XF8FA9FB7),
                      borderRadius: BorderRadius.circular(5.r),
                    ),
                    child: Text(
                      '发布',
                      style:
                          BaseStyle.fs16W.copyWith(fontWeight: FontWeight.bold),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
