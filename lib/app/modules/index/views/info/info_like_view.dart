// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';
import 'package:han_tok/app/utils/DataUtil.dart';

import '../../../../data/base_style.dart';
import '../../../../data/video/controller/user_info_controller.dart';
import 'like_detail_view.dart';

class InfoLikeView extends GetView {
  const InfoLikeView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    UserInfoController infoController = Get.put(UserInfoController());
    return Scaffold(
      body: Container(
        color: Colors.white,
        child: infoController.likeList.isEmpty
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
                        Text('当前列表所有人不可见',
                            textAlign: TextAlign.center,
                            style: BaseStyle.fs14G),
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
                itemCount: infoController.likeList.length,
                itemBuilder: (context, index) {
                  String vlogId = infoController.likeList[index].vlogId;
                  String vlogerId = infoController.likeList[index].vlogerId;
                  String url = infoController.likeList[index].url;
                  int likeCounts = infoController.likeList[index].likeCounts;
                  return GestureDetector(
                    onTap: () => Get.to(() => LikeDetailView(
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
                              infoController.likeList[index].cover,
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
                                DataUtil().generator(
                                    infoController.likeList[index].likeCounts),
                                style: BaseStyle.fs16W,
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
      ),
    );
  }
}
