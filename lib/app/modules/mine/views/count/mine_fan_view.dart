// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';
import 'package:han_tok/app/modules/mine/controllers/mine_controller.dart';
import 'package:han_tok/app/modules/mine/controllers/mine_fan_controller.dart';

import '../../../../data/base_style.dart';
import '../../../../data/theme_data.dart';
import '../../../../data/video/user_info.dart';

class MineFanView extends GetView {
  const MineFanView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    MineController mineController = Get.put(MineController());
    MineFanController controller = Get.put(MineFanController());

    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 14.w),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 16.h),
              Container(
                height: 36.h,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.r),
                  color: Config.primarySwatchColor.shade50,
                ),
                child: TextField(
                  onChanged: (String value) {},
                  cursorColor: Colors.red,
                  decoration: InputDecoration(
                    hintText: '搜索用户备注或名字',
                    hintStyle:
                        BaseStyle.fs16.copyWith(color: Colors.grey.shade500),
                    prefixIcon: Icon(
                      Icons.search,
                      color: Colors.grey,
                    ),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(vertical: 10),
                  ),
                ),
              ),
              SizedBox(height: 16.h),
              Obx(
                () => Text(
                  '我的粉丝（${mineController.fanList.length}人）',
                  style: BaseStyle.fs12G,
                ),
              ),
              SizedBox(height: 10.h),
              Obx(
                () => Column(
                  children: mineController.fanList
                      .map((element) => GestureDetector(
                            onTap: () =>
                                Get.to(() => UserInfo(vlogerId: element.fanId)),
                            child: Container(
                              width: size.width,
                              padding: EdgeInsets.only(bottom: 16.h),
                              child: Row(
                                children: [
                                  Container(
                                    width: 56.w,
                                    height: 56.h,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(28.r),
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(28.r),
                                      child: Image.network(
                                          element.face.toString()),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(left: 14.w),
                                    child: Text(
                                      element.nickname,
                                      style: BaseStyle.fs16.copyWith(
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ),
                                  Spacer(),
                                  element.friend == true
                                      ? GestureDetector(
                                          onTap: () =>
                                              controller.cancel(element.fanId),
                                          child: Container(
                                            width: 70.w,
                                            alignment: Alignment.center,
                                            padding: EdgeInsets.symmetric(
                                                vertical: 6.h),
                                            decoration: BoxDecoration(
                                              color: Config
                                                  .primarySwatchColor.shade50,
                                              borderRadius:
                                                  BorderRadius.circular(5.r),
                                            ),
                                            child: Text(
                                              '已互关',
                                              style: BaseStyle.fs12,
                                            ),
                                          ),
                                        )
                                      : GestureDetector(
                                          onTap: () =>
                                              controller.follow(element.fanId),
                                          child: Container(
                                            width: 70.w,
                                            alignment: Alignment.center,
                                            padding: EdgeInsets.symmetric(
                                                vertical: 6.h),
                                            decoration: BoxDecoration(
                                              color: Colors.redAccent
                                                  .withOpacity(.8),
                                              borderRadius:
                                                  BorderRadius.circular(5.r),
                                            ),
                                            child: Text(
                                              '回关',
                                              style: BaseStyle.fs12.copyWith(
                                                  color: Colors.white),
                                            ),
                                          ),
                                        ),
                                ],
                              ),
                            ),
                          ))
                      .toList(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
