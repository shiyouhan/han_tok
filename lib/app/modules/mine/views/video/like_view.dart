// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';
import 'package:han_tok/app/modules/mine/controllers/mine_controller.dart';

import '../../../../data/base_style.dart';
import '../../controllers/like_controller.dart';
import 'vlog_detail_view.dart';

class LikeView extends GetView {
  const LikeView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    MineController mineController = Get.put(MineController());
    // LikeController controller = Get.put(LikeController());
    return mineController.likeList.isEmpty
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
                      child: Text('暂无内容',
                          style: BaseStyle.fs16
                              .copyWith(fontWeight: FontWeight.bold)),
                    ),
                    Text('当前列表所有人可见',
                        textAlign: TextAlign.center, style: BaseStyle.fs14G),
                  ],
                ),
              ),
            ),
          )
        : GridView.builder(
            padding: EdgeInsets.zero,
            physics: ClampingScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              childAspectRatio: 3 / 4,
            ),
            itemCount: mineController.likeList.length,
            itemBuilder: (context, index) {
              String vlogId = mineController.likeList[index].vlogId;
              String vlogerId = mineController.likeList[index].vlogerId;
              String url = mineController.likeList[index].url;
              int likeCounts = mineController.likeList[index].likeCounts;
              return GestureDetector(
                onTap: () => Get.to(() => VlogDetailView(
                    vlogId: vlogId,
                    vlogerId: vlogerId,
                    url: url,
                    likeCounts: likeCounts)),
                child: Stack(
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
                          mineController.likeList[index].cover,
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
                            mineController.likeList[index].likeCounts
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
          );
  }
}
