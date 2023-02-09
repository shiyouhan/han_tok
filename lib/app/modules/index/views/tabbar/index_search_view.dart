// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';
import 'package:han_tok/app/data/base_style.dart';
import 'package:han_tok/app/modules/index/controllers/index_search_controller.dart';
import 'package:han_tok/app/modules/index/views/tabbar/search_detail_view.dart';
import 'package:han_tok/app/utils/DataUtil.dart';

import '../../../../data/base_data.dart';
import '../../../../data/video/user_info.dart';
import '../../../../utils/DateUtil.dart';
import '../../../../utils/Iconfont.dart';

class IndexSearchView extends GetView {
  const IndexSearchView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    IndexSearchController controller = Get.put(IndexSearchController());
    final size = MediaQuery.of(context).size;

    FocusNode focusNode = FocusNode();

    //显示底部弹框的功能
    void showBottomSheet() {
      //用于在底部打开弹框的效果
      showModalBottomSheet(
        builder: (BuildContext context) {
          //构建弹框中的内容
          return buildBottomSheetWidget(context);
        },
        context: context,
        backgroundColor: Colors.transparent,
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Container(
          width: size.width * 0.7,
          height: 36.h,
          // padding: EdgeInsets.symmetric(horizontal: 10.w),
          color: Colors.grey.withOpacity(.1),
          child: TextField(
            cursorColor: Colors.red,
            decoration: InputDecoration(
              hintText: "请输入搜索内容",
              hintStyle: BaseStyle.fs14G,
              border: InputBorder.none,
              prefixIcon: Icon(
                Icons.search,
                size: 24,
              ),
            ),
            controller: controller.searchController.value,
            onChanged: (value) {
              controller.searchStr(value);
            },
          ),
        ),
        centerTitle: true,
        elevation: 0,
        actions: [
          GestureDetector(
            onTap: () => controller.search(),
            child: Center(
              child: Padding(
                padding: EdgeInsets.only(right: 16.w),
                child: Text(
                  '搜索',
                  style: BaseStyle.fs16,
                ),
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Obx(
          () => Column(
            children: controller.videoList
                .map(
                  (element) => Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 16.w, vertical: 24.h),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            GestureDetector(
                              onTap: () => Get.to(
                                  () => UserInfo(vlogerId: element.vlogerId)),
                              child: Row(
                                children: [
                                  Container(
                                    width: 34.w,
                                    height: 34.w,
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: Colors.white,
                                        width: 1.w,
                                      ),
                                      borderRadius: BorderRadius.circular(16.r),
                                      color: Colors.white70,
                                    ),
                                    child: ClipOval(
                                      child: Image.network(
                                        element.vlogerFace,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 8.w),
                                  Text(element.vlogerName,
                                      style: BaseStyle.fs14.copyWith(
                                          fontWeight: FontWeight.w500)),
                                ],
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(vertical: 10.h),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: GestureDetector(
                                      onTap: () => Get.to(
                                        () => SearchDetailView(
                                          vlogId: element.vlogId,
                                          url: element.url,
                                          vlogerId: element.vlogerId,
                                          likeCounts: element.likeCounts,
                                        ),
                                      ),
                                      child: Text(element.content,
                                          style: BaseStyle.fs16),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(10.r),
                              child: GestureDetector(
                                onTap: () => Get.to(
                                  () => SearchDetailView(
                                    vlogId: element.vlogId,
                                    url: element.url,
                                    vlogerId: element.vlogerId,
                                    likeCounts: element.likeCounts,
                                  ),
                                ),
                                child: Image.network(
                                  element.cover,
                                  width: size.width * 0.66,
                                  height: size.height * 0.44,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            SizedBox(height: 12.h),
                            Row(
                              children: [
                                GestureDetector(
                                  child: Row(
                                    children: [
                                      element.doILikeThisVlog == false
                                          ? GestureDetector(
                                              onTap: () => {
                                                controller.vlogId.value =
                                                    element.vlogId,
                                                controller.vlogerId.value =
                                                    element.vlogerId,
                                                controller.like(),
                                              },
                                              child: Icon(IconFont.favourite,
                                                  size: 24),
                                            )
                                          : GestureDetector(
                                              onTap: () => {
                                                controller.vlogId.value =
                                                    element.vlogId,
                                                controller.vlogerId.value =
                                                    element.vlogerId,
                                                controller.unlike(),
                                              },
                                              child: Icon(
                                                Icons.favorite,
                                                size: 24,
                                                color: Colors.red,
                                              ),
                                            ),
                                      SizedBox(width: 4.w),
                                      Text(
                                        element.likeCounts == 0
                                            ? '点赞'
                                            : DataUtil()
                                                .generator(element.likeCounts),
                                        style: BaseStyle.fs12,
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(width: size.width * 0.11),
                                GestureDetector(
                                  child: Row(
                                    children: [
                                      GestureDetector(
                                        onTap: () => {
                                          controller.vlogId.value =
                                              element.vlogId,
                                          controller
                                              .renewComment(element.vlogId),
                                          showModalBottomSheet<void>(
                                            context: context,
                                            isScrollControlled: true,
                                            isDismissible: true,
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.only(
                                                topLeft: Radius.circular(20),
                                                topRight: Radius.circular(20),
                                              ),
                                            ),
                                            builder: (BuildContext context) {
                                              return AnimatedPadding(
                                                padding: MediaQuery.of(context)
                                                    .viewInsets,
                                                duration:
                                                    Duration(microseconds: 100),
                                                child: Container(
                                                  height: MediaQuery.of(context)
                                                              .viewInsets
                                                              .bottom
                                                              .toInt() ==
                                                          0
                                                      ? size.height * 0.7
                                                      : size.height * 0.5,
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.only(
                                                      topLeft:
                                                          Radius.circular(20),
                                                      topRight:
                                                          Radius.circular(20),
                                                    ),
                                                    color: Colors.white,
                                                  ),
                                                  child: SafeArea(
                                                      child: Stack(
                                                    children: [
                                                      Container(
                                                        decoration:
                                                            BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius.only(
                                                            topLeft:
                                                                Radius.circular(
                                                                    20),
                                                            topRight:
                                                                Radius.circular(
                                                                    20),
                                                          ),
                                                          // color: Colors.white,
                                                        ),
                                                        child: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .center,
                                                          children: [
                                                            Column(
                                                              children: [
                                                                Padding(
                                                                  padding: EdgeInsets.only(
                                                                      top: 12.h,
                                                                      bottom:
                                                                          18.h),
                                                                  child: Obx(
                                                                    () => Text(
                                                                      '${controller.commentList.length}条评论',
                                                                      style: BaseStyle
                                                                          .fs14,
                                                                    ),
                                                                  ),
                                                                ),
                                                                Obx(
                                                                  () =>
                                                                      Container(
                                                                    height: MediaQuery.of(context).viewInsets.bottom.toInt() ==
                                                                            0
                                                                        ? size.height *
                                                                            0.52
                                                                        : size.height *
                                                                            0.36,
                                                                    padding: EdgeInsets.symmetric(
                                                                        horizontal:
                                                                            16.w),
                                                                    child: controller
                                                                            .commentList
                                                                            .isEmpty
                                                                        ? Center(
                                                                            child:
                                                                                Column(
                                                                            mainAxisAlignment:
                                                                                MainAxisAlignment.center,
                                                                            children: [
                                                                              SizedBox(
                                                                                width: size.width * 0.4,
                                                                                child: Image.asset('assets/images/pinglun.png', fit: BoxFit.fill),
                                                                              ),
                                                                              SizedBox(height: 10.h),
                                                                              Text(
                                                                                '平等表达，友善交流',
                                                                                style: BaseStyle.fs14G,
                                                                              ),
                                                                            ],
                                                                          ))
                                                                        : SingleChildScrollView(
                                                                            child:
                                                                                Column(
                                                                              children: controller.commentList
                                                                                  .map(
                                                                                    (element) => GestureDetector(
                                                                                        onLongPress: () => {
                                                                                              controller.commentId.value = element.commentId,
                                                                                              controller.commentUserId.value = element.commentUserId,
                                                                                              showBottomSheet(),
                                                                                            },
                                                                                        child: Padding(
                                                                                          padding: EdgeInsets.only(bottom: 10),
                                                                                          child: Row(
                                                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                                                            children: [
                                                                                              Container(
                                                                                                width: 40.w,
                                                                                                height: 40.h,
                                                                                                decoration: BoxDecoration(
                                                                                                  borderRadius: BorderRadius.circular(20.r),
                                                                                                ),
                                                                                                child: ClipRRect(
                                                                                                  borderRadius: BorderRadius.circular(20.r),
                                                                                                  child: Image.network(element.commentUserFace.toString()),
                                                                                                ),
                                                                                              ),
                                                                                              Padding(
                                                                                                padding: EdgeInsets.only(left: 14),
                                                                                                child: Column(
                                                                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                                                                  children: [
                                                                                                    SizedBox(
                                                                                                      width: 2 * (size.width / 3),
                                                                                                      child: Column(
                                                                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                                                                        children: [
                                                                                                          Padding(
                                                                                                              padding: EdgeInsets.only(bottom: 4),
                                                                                                              child: Row(
                                                                                                                children: [
                                                                                                                  Text(
                                                                                                                    element.commentUserNickname,
                                                                                                                    style: BaseStyle.fs14G,
                                                                                                                  ),
                                                                                                                  SizedBox(width: 4.w),
                                                                                                                  controller.vlogerId == element.vlogerId
                                                                                                                      ? Container(
                                                                                                                          decoration: BoxDecoration(color: Colors.pink, borderRadius: BorderRadius.circular(2.r)),
                                                                                                                          padding: EdgeInsets.symmetric(horizontal: 2),
                                                                                                                          child: Text(
                                                                                                                            '作者',
                                                                                                                            style: BaseStyle.fs12.copyWith(color: Colors.white),
                                                                                                                          ),
                                                                                                                        )
                                                                                                                      : Container(),
                                                                                                                  element.replyedUserNickname != null
                                                                                                                      ? Row(
                                                                                                                          children: [
                                                                                                                            Icon(Icons.arrow_right, size: 24, color: Colors.grey),
                                                                                                                            SizedBox(width: 4.w),
                                                                                                                            Text(
                                                                                                                              element.replyedUserNickname,
                                                                                                                              style: BaseStyle.fs14.copyWith(color: Colors.grey),
                                                                                                                            ),
                                                                                                                          ],
                                                                                                                        )
                                                                                                                      : Container(),
                                                                                                                ],
                                                                                                              )),
                                                                                                          Row(
                                                                                                            children: [
                                                                                                              Expanded(
                                                                                                                child: Text(
                                                                                                                  element.content,
                                                                                                                  style: BaseStyle.fs16,
                                                                                                                ),
                                                                                                              ),
                                                                                                            ],
                                                                                                          ),
                                                                                                        ],
                                                                                                      ),
                                                                                                    ),
                                                                                                    SizedBox(height: 4.h),
                                                                                                    SizedBox(
                                                                                                      width: size.width - 86.w,
                                                                                                      child: Row(
                                                                                                        children: [
                                                                                                          Row(
                                                                                                            children: [
                                                                                                              Text(
                                                                                                                DateUtil().getComparedTime(element.createTime.toString()),
                                                                                                                style: BaseStyle.fs14G,
                                                                                                              ),
                                                                                                              SizedBox(width: 16.h),
                                                                                                              GestureDetector(
                                                                                                                onTap: () => {
                                                                                                                  controller.fatherCommentId.value = element.commentId,
                                                                                                                  FocusScope.of(context).requestFocus(focusNode),
                                                                                                                },
                                                                                                                child: Text(
                                                                                                                  '回复',
                                                                                                                  style: BaseStyle.fs14.copyWith(color: Colors.black87),
                                                                                                                ),
                                                                                                              )
                                                                                                            ],
                                                                                                          ),
                                                                                                          Spacer(),
                                                                                                          GestureDetector(
                                                                                                            child: Row(
                                                                                                              children: [
                                                                                                                element.isLike == 0
                                                                                                                    ? GestureDetector(
                                                                                                                        onTap: () => {
                                                                                                                          controller.vlogId.value = element.vlogId,
                                                                                                                          controller.commentId.value = element.commentId,
                                                                                                                          controller.commentLike(),
                                                                                                                        },
                                                                                                                        child: Icon(Icons.favorite_border, size: 14, color: Colors.grey),
                                                                                                                      )
                                                                                                                    : GestureDetector(
                                                                                                                        onTap: () => {
                                                                                                                          controller.vlogId.value = element.vlogId,
                                                                                                                          controller.commentId.value = element.commentId,
                                                                                                                          controller.commentUnLike(),
                                                                                                                        },
                                                                                                                        child: Icon(Icons.favorite, size: 14, color: Colors.redAccent),
                                                                                                                      ),
                                                                                                                SizedBox(width: 2.w),
                                                                                                                Text(
                                                                                                                  element.likeCounts.toString(),
                                                                                                                  style: BaseStyle.fs14G,
                                                                                                                ),
                                                                                                              ],
                                                                                                            ),
                                                                                                          )
                                                                                                        ],
                                                                                                      ),
                                                                                                    ),
                                                                                                    // element.isLike == 1
                                                                                                    //     ? Container(
                                                                                                    //         padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 1.h),
                                                                                                    //         margin: EdgeInsets.only(top: 2.h),
                                                                                                    //         decoration: BoxDecoration(color: Colors.grey.withOpacity(.2), borderRadius: BorderRadius.circular(2.r)),
                                                                                                    //         child: Text(
                                                                                                    //           '作者赞过',
                                                                                                    //           style: BaseStyle.fs10.copyWith(color: Colors.black.withOpacity(.8)),
                                                                                                    //         ),
                                                                                                    //       )
                                                                                                    //     : Container(),
                                                                                                  ],
                                                                                                ),
                                                                                              ),
                                                                                            ],
                                                                                          ),
                                                                                        )),
                                                                                  )
                                                                                  .toList(),
                                                                            ),
                                                                          ),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                            Spacer(),
                                                            Container(
                                                              height: 1.h,
                                                              color: Colors.grey
                                                                  .withOpacity(
                                                                      .2),
                                                              margin: EdgeInsets
                                                                  .only(
                                                                      bottom:
                                                                          6.h),
                                                            ),
                                                            Container(
                                                              margin: EdgeInsets
                                                                  .symmetric(
                                                                      horizontal:
                                                                          16),
                                                              padding: EdgeInsets
                                                                  .symmetric(
                                                                      horizontal:
                                                                          20.w),
                                                              decoration:
                                                                  BoxDecoration(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            30.r),
                                                                color: BaseData
                                                                    .bodyColor,
                                                              ),
                                                              child: TextField(
                                                                cursorColor:
                                                                    Colors.red,
                                                                focusNode:
                                                                    focusNode,
                                                                decoration:
                                                                    InputDecoration(
                                                                  hintText:
                                                                      '善语结善缘，恶言伤人心',
                                                                  // videoController.fatherComment.value !=
                                                                  //         ''
                                                                  //     ? ('@' +
                                                                  //         videoController
                                                                  //             .fatherComment.value)
                                                                  //     : '善语结善缘，恶言伤人心',
                                                                  hintStyle:
                                                                      BaseStyle
                                                                          .fs14G,
                                                                  border:
                                                                      InputBorder
                                                                          .none,
                                                                  suffixIcon:
                                                                      Icon(Icons
                                                                          .alternate_email),
                                                                ),
                                                                controller:
                                                                    controller
                                                                        .commentController,
                                                                onChanged:
                                                                    (value) {
                                                                  controller
                                                                      .commentStr(
                                                                          value);
                                                                },
                                                                onSubmitted:
                                                                    (value) {
                                                                  controller
                                                                          .vlogId
                                                                          .value =
                                                                      element
                                                                          .vlogId;
                                                                  controller
                                                                          .vlogerId
                                                                          .value =
                                                                      element
                                                                          .vlogerId;
                                                                  controller
                                                                      .commentCreate();
                                                                },
                                                              ),
                                                            ),
                                                            SizedBox(
                                                                height: 6.h),
                                                          ],
                                                        ),
                                                      ),
                                                      Positioned(
                                                        right: 16,
                                                        top: 12,
                                                        child: GestureDetector(
                                                          onTap: () =>
                                                              Get.back(),
                                                          child:
                                                              Icon(Icons.clear),
                                                        ),
                                                      ),
                                                    ],
                                                  )),
                                                ),
                                              );
                                            },
                                          ),
                                        },
                                        child:
                                            Icon(IconFont.pinglun_b, size: 24),
                                      ),
                                      SizedBox(width: 4.w),
                                      Text(
                                        element.commentsCounts == 0
                                            ? '评论'
                                            : DataUtil().generator(
                                                element.commentsCounts),
                                        style: BaseStyle.fs12,
                                      )
                                    ],
                                  ),
                                ),
                                SizedBox(width: size.width * 0.11),
                                GestureDetector(
                                  child: Row(
                                    children: [
                                      Icon(IconFont.shoucang_b, size: 24),
                                      SizedBox(width: 4.w),
                                      Text(
                                        '收藏',
                                        style: BaseStyle.fs12,
                                      )
                                    ],
                                  ),
                                ),
                                SizedBox(width: size.width * 0.11),
                                GestureDetector(
                                  child: Row(
                                    children: [
                                      Icon(IconFont.zhuanfa_b, size: 24),
                                      SizedBox(width: 4.w),
                                      Text(
                                        '转发',
                                        style: BaseStyle.fs12,
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Container(
                        height: 10.h,
                        color: Colors.grey.withOpacity(.1),
                      ),
                    ],
                  ),
                )
                .toList(),
          ),
        ),
      ),
    );
  }

  Widget buildBottomSheetWidget(BuildContext context) {
    IndexSearchController controller = Get.put(IndexSearchController());
    return SafeArea(
      child: Container(
        height: 50.h,
        margin: EdgeInsets.symmetric(horizontal: 10.w),
        child: Column(
          children: [
            GestureDetector(
              onTap: () {
                controller.delete();
                Navigator.of(context).pop();
              },
              behavior: HitTestBehavior.opaque,
              child: Container(
                height: 50.h,
                alignment: Alignment.center,
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15.r),
                ),
                child: Row(
                  children: [
                    Icon(
                      IconFont.shanchu,
                      size: 20,
                      color: Colors.black54,
                    ),
                    SizedBox(width: 8.w),
                    Text(
                      "删除改评论",
                      style: BaseStyle.fs16,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
