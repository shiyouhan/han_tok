// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';
import 'package:han_tok/app/modules/mine/controllers/private_controller.dart';

import '../../../../data/base_style.dart';

class PrivateView extends GetView {
  const PrivateView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    PrivateController controller = Get.put(PrivateController());
    return GridView.builder(
      padding: EdgeInsets.zero,
      physics: ClampingScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 3 / 4,
      ),
      itemCount: controller.privateList.length,
      itemBuilder: (context, index) {
        return GestureDetector(
          child: controller.privateList.isEmpty
              ? Container(
                  color: Colors.white,
                  child: Center(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 40),
                      child: Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.only(
                              top: 42,
                              bottom: 22,
                            ),
                            child: Text(
                              '没有私密作品或相册',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Text(
                            '设为私密的作品、过期的日常或上传的相册会展示在这里，并且只有你能看到',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              : Stack(
                  children: [
                    AbsorbPointer(
                      absorbing: true,
                      child: Container(
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: Colors.black,
                          border: Border.all(width: 1, color: Colors.grey),
                        ),
                        child: Image.network(
                          controller.privateList[index].cover,
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
                          ),
                          SizedBox(width: 2.w),
                          Text(
                            controller.privateList[index].likeCounts.toString(),
                            style: BaseStyle.fs16W,
                          )
                        ],
                      ),
                    ),
                  ],
                ),
        );
      },
    );
  }
}
