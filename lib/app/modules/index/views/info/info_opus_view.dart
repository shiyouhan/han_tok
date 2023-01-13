// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';
import 'package:han_tok/app/data/video/controller/user_info_controller.dart';

import '../../../../data/base_data.dart';
import '../../../../data/base_style.dart';
import '../../../../utils/Iconfont.dart';

class InfoOpusView extends GetView {
  const InfoOpusView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    UserInfoController infoController = Get.put(UserInfoController());
    return Obx(() => infoController.publicList.isEmpty
        ? Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 54.w,
                height: 54.w,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(27.r),
                  color: BaseData.kBackColor,
                ),
                child: Icon(IconFont.image),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 20.h),
                child: Text(
                  '发一张你点赞最多的照片',
                  style: BaseStyle.fs16.copyWith(fontWeight: FontWeight.bold),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 25.w, vertical: 10.h),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5.r),
                  border:
                      Border.all(width: 1, color: Colors.grey.withOpacity(.4)),
                ),
                child: Text(
                  '打开相册',
                  style: BaseStyle.fs16.copyWith(fontWeight: FontWeight.bold),
                ),
              ),
            ],
          )
        : GridView.builder(
            padding: EdgeInsets.zero,
            physics: ClampingScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              childAspectRatio: 3 / 4,
            ),
            itemCount: infoController.publicList.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                child: Stack(
                  children: [
                    AbsorbPointer(
                      absorbing: true,
                      child: Container(
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: Colors.black,
                          border: Border.all(width: 0.5.w, color: Colors.white),
                        ),
                        child: Image.network(
                          infoController.publicList[index].cover,
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),
                    Positioned(
                      left: 4,
                      bottom: 4,
                      child: Row(
                        children: [
                          Icon(
                            Icons.favorite_border,
                            color: Colors.white,
                            size: 22,
                          ),
                          SizedBox(width: 2.w),
                          Text(
                            infoController.publicList[index].likeCounts
                                .toString(),
                            style: BaseStyle.fs16W,
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ));
  }
}
