// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';

import '../../../../data/base_style.dart';
import '../../controllers/composition_controller.dart';

class CompositionView extends GetView {
  const CompositionView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    CompositionController controller = Get.put(CompositionController());
    return GridView.builder(
        padding: EdgeInsets.zero,
        physics: ClampingScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          childAspectRatio: 3 / 4,
        ),
        itemCount: controller.publicList.length,
        itemBuilder: (context, index) {
          // 实际羡慕中， 通过dateList[index]取出url
          return GestureDetector(
            child: controller.publicList.isEmpty
                ? Container() // 加载提示或者骨架屏
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
                              controller.publicList[index].cover,
                              fit: BoxFit.fill,
                            ),
                          )
                          // VideoView(
                          //   Player()
                          //     ..setLoop(0)
                          //     ..setCommonDataSource(
                          //         controller.publicList[index].url,
                          //         type: SourceType.net,
                          //         autoPlay: true),
                          //   fit: FijkFit.cover,
                          // ),
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
                                controller.publicList[index].likeCounts
                                    .toString(),
                                style: BaseStyle.fs16W,
                              )
                            ],
                          )),
                    ],
                  ),
          );
        });
  }
}
