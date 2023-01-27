// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';
import 'package:han_tok/app/modules/mine/controllers/mine_controller.dart';
import 'package:han_tok/app/modules/mine/controllers/mine_follow_controller.dart';

import '../../../../data/base_style.dart';
import '../../../../data/theme_data.dart';

class MineFollowView extends GetView {
  const MineFollowView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    MineController mineController = Get.put(MineController());
    MineFollowController controller = Get.put(MineFollowController());
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
                alignment: Alignment.center,
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
                  '我的关注（${mineController.followList.length}人）',
                  style: BaseStyle.fs12G,
                ),
              ),
              SizedBox(height: 10.h),
              Obx(
                () => Column(
                  children: mineController.followList
                      .map(
                        (element) => Padding(
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
                                  child: Image.network(element.face.toString()),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(left: 14.w),
                                child: Text(
                                  element.nickname,
                                  style: BaseStyle.fs16
                                      .copyWith(fontWeight: FontWeight.w500),
                                ),
                              ),
                              Spacer(),
                              Obx(
                                () => controller.followed.value == true
                                    ? GestureDetector(
                                        onTap: () => controller.unFollow(),
                                        child: Container(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 20.w, vertical: 6.h),
                                          decoration: BoxDecoration(
                                            color: Config
                                                .primarySwatchColor.shade50,
                                            borderRadius:
                                                BorderRadius.circular(5.r),
                                          ),
                                          child: Text(
                                            '已关注',
                                            style: BaseStyle.fs12,
                                          ),
                                        ),
                                      )
                                    : GestureDetector(
                                        onTap: () => controller.follow(),
                                        child: Container(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 20.w, vertical: 6.h),
                                          decoration: BoxDecoration(
                                            color: Colors.redAccent
                                                .withOpacity(.8),
                                            borderRadius:
                                                BorderRadius.circular(5.r),
                                          ),
                                          child: Text(
                                            '关注',
                                            style: BaseStyle.fs12
                                                .copyWith(color: Colors.white),
                                          ),
                                        ),
                                      ),
                              ),
                            ],
                          ),
                        ),
                      )
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
