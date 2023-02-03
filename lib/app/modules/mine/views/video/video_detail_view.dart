// ignore_for_file: must_be_immutable, prefer_const_constructors, depend_on_referenced_packages

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';
import 'package:han_tok/app/modules/mine/controllers/video_detail_controller.dart';
import 'package:han_tok/app/utils/DataUtil.dart';
import 'package:video_player/video_player.dart';

import '../../../../data/base_data.dart';
import '../../../../data/base_style.dart';
import '../../../../utils/DateUtil.dart';
import '../../../../utils/Iconfont.dart';

class VideoDetailView extends GetView {
  String vlogId;
  String vlogerId;
  String url;
  String createdTime;
  int likeCounts;
  VideoDetailView(
      {Key? key,
      required this.vlogId,
      required this.url,
      required this.likeCounts,
      required this.vlogerId,
      required this.createdTime})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Container(
        color: Colors.black,
        child: SafeArea(
          child: Scaffold(
            appBar: AppBar(
              leading: GestureDetector(
                onTap: () => Get.back(),
                child: Icon(
                  Icons.arrow_back_ios,
                  size: 24,
                  color: Colors.white,
                ),
              ),
              actions: [
                Padding(
                  padding: EdgeInsets.only(right: 10),
                  child: GestureDetector(
                    // onTap: () => Get.back(),
                    child: Icon(
                      Icons.search_rounded,
                      size: 28,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
              backgroundColor: Colors.black,
            ),
            body: VideoDetail(
                vlogId: vlogId,
                url: url,
                likeCounts: likeCounts,
                vlogerId: vlogerId,
                createdTime: createdTime),
          ),
        ),
      ),
    );
  }
}

class VideoDetail extends StatefulWidget {
  String vlogId;
  String vlogerId;
  String url;
  String createdTime;
  int likeCounts;
  VideoDetail(
      {Key? key,
      required this.vlogId,
      required this.vlogerId,
      required this.url,
      required this.createdTime,
      required this.likeCounts})
      : super(key: key);

  @override
  State<VideoDetail> createState() => _VideoDetailState();
}

class _VideoDetailState extends State<VideoDetail> {
  VideoDetailController controller = Get.put(VideoDetailController());
  late VideoPlayerController _controller;
  FocusNode focusNode = FocusNode();

  @override
  void initState() {
    controller.vlogId.value = widget.vlogId;
    controller.vlogerId.value = widget.vlogerId;
    controller.createdTime.value = widget.createdTime;
    controller.getDetail();
    _controller = VideoPlayerController.network(widget.url);
    _controller.addListener(() {
      setState(() {});
    });
    _controller.setLooping(true);
    _controller.initialize().then((_) => setState(() {}));
    _controller.play();
    controller.renewComment();
    controller.commentController = TextEditingController();
    super.initState();
  }

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

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    Widget bottomInfo = Container(
      margin: EdgeInsets.only(left: 10),
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: BaseData.bodyColor.withOpacity(.1),
        borderRadius: BorderRadius.circular(30.r),
      ),
      child: Row(
        children: [
          Container(
            width: 48.w,
            height: 48.w,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24.r),
            ),
            child: ClipOval(
              child: Obx(
                () => Image.network(
                  controller.vlogerFace.value,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          SizedBox(width: 10.w),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Obx(() => Row(
                    children: [
                      Text('${controller.vlogerName.value} · ',
                          style: BaseStyle.fs14G
                              .copyWith(fontWeight: FontWeight.bold)),
                      Text(
                          DateUtil()
                              .getComparedTime(controller.createdTime.value),
                          style: BaseStyle.fs12G
                              .copyWith(fontWeight: FontWeight.bold)),
                    ],
                  )),
              Row(
                children: [
                  Text('#发布视频 · ',
                      style: BaseStyle.fs14.copyWith(color: Colors.white)),
                  Text(controller.isPrivate.value == 0 ? '公开' : '私密',
                      style: BaseStyle.fs14.copyWith(color: Colors.white)),
                ],
              ),
            ],
          )
        ],
      ),
    );

    Widget rightInfo = Column(
      children: [
        Container(
          width: 48.w,
          height: 48.w,
          decoration: BoxDecoration(
            border: Border.all(
              color: Colors.white,
              width: 2,
            ),
            borderRadius: BorderRadius.circular(24.r),
            color: Colors.white70,
          ),
          child: ClipOval(
            child: Obx(
              () => Image.network(
                controller.vlogerFace.value,
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
        SizedBox(height: 16.h),
        Column(
          children: [
            Icon(
              Icons.favorite,
              size: 40,
              color: Colors.white,
            ),
            SizedBox(height: 2.h),
            Text(
              widget.likeCounts == 0
                  ? '赞'
                  : DataUtil().generator(widget.likeCounts),
              style: BaseStyle.fs12.copyWith(color: Colors.white),
            )
          ],
        ),
        SizedBox(height: 16.h),
        Column(
          children: [
            GestureDetector(
              onTap: () => {
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
                      padding: MediaQuery.of(context).viewInsets,
                      duration: Duration(microseconds: 100),
                      child: Container(
                        height:
                            MediaQuery.of(context).viewInsets.bottom.toInt() ==
                                    0
                                ? size.height * 0.7
                                : size.height * 0.5,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(20),
                            topRight: Radius.circular(20),
                          ),
                          color: Colors.white,
                        ),
                        child: SafeArea(
                            child: Stack(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(20),
                                  topRight: Radius.circular(20),
                                ),
                                // color: Colors.white,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Column(
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.only(
                                            top: 12.h, bottom: 18.h),
                                        child: Obx(
                                          () => Text(
                                            '${controller.commentList.length}条评论',
                                            style: BaseStyle.fs14,
                                          ),
                                        ),
                                      ),
                                      Obx(
                                        () => Container(
                                          height: MediaQuery.of(context)
                                                      .viewInsets
                                                      .bottom
                                                      .toInt() ==
                                                  0
                                              ? size.height * 0.52
                                              : size.height * 0.36,
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 16.w),
                                          child: controller.commentList.isEmpty
                                              ? Center(
                                                  child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    SizedBox(
                                                      width: size.width * 0.4,
                                                      child: Image.asset(
                                                          'assets/images/pinglun.png',
                                                          fit: BoxFit.fill),
                                                    ),
                                                    SizedBox(height: 10.h),
                                                    Text(
                                                      '平等表达，友善交流',
                                                      style: BaseStyle.fs14G,
                                                    ),
                                                  ],
                                                ))
                                              : SingleChildScrollView(
                                                  child: Column(
                                                    children:
                                                        controller.commentList
                                                            .map(
                                                              (element) =>
                                                                  GestureDetector(
                                                                      onLongPress:
                                                                          () =>
                                                                              {
                                                                                controller.commentId.value = element.commentId,
                                                                                controller.commentUserId.value = element.commentUserId,
                                                                                showBottomSheet(),
                                                                              },
                                                                      child:
                                                                          Padding(
                                                                        padding:
                                                                            EdgeInsets.only(bottom: 10),
                                                                        child:
                                                                            Row(
                                                                          crossAxisAlignment:
                                                                              CrossAxisAlignment.start,
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
                                                                                                widget.vlogerId == element.vlogerId
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
                                                                                                          // SizedBox(width: 6.w),
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
                                                                                                        controller.commentId.value = element.commentId,
                                                                                                        controller.commentLike(),
                                                                                                      },
                                                                                                      child: Icon(Icons.favorite_border, size: 14, color: Colors.grey),
                                                                                                    )
                                                                                                  : GestureDetector(
                                                                                                      onTap: () => {
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
                                    color: Colors.grey.withOpacity(.2),
                                    margin: EdgeInsets.only(bottom: 6.h),
                                  ),
                                  Container(
                                    margin:
                                        EdgeInsets.symmetric(horizontal: 16),
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 20.w),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(30.r),
                                      color: BaseData.bodyColor,
                                    ),
                                    child: TextField(
                                      cursorColor: Colors.red,
                                      focusNode: focusNode,
                                      decoration: InputDecoration(
                                        hintText: '善语结善缘，恶言伤人心',
                                        hintStyle: BaseStyle.fs14G,
                                        border: InputBorder.none,
                                        suffixIcon: Icon(Icons.alternate_email),
                                      ),
                                      controller: controller.commentController,
                                      onChanged: (value) {
                                        controller.commentStr(value);
                                      },
                                      onSubmitted: (value) {
                                        controller.commentCreate();
                                      },
                                    ),
                                  ),
                                  SizedBox(height: 6.h),
                                ],
                              ),
                            ),
                            Positioned(
                              right: 16,
                              top: 12,
                              child: GestureDetector(
                                onTap: () => Get.back(),
                                child: Icon(Icons.clear),
                              ),
                            ),
                          ],
                        )),
                      ),
                    );
                  },
                ),
              },
              child: Icon(
                IconFont.pinglun,
                size: 32,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 4.h),
            Text(
              controller.commentList.isEmpty
                  ? '抢首评'
                  : DataUtil().generator(controller.commentList.length),
              style: BaseStyle.fs12.copyWith(color: Colors.white),
            ),
          ],
        ),
        SizedBox(height: 16.h),
        Column(
          children: [
            Icon(
              IconFont.shoucang,
              size: 32,
              color: Colors.white,
            ),
            SizedBox(height: 4.h),
            Text(
              '收藏',
              style: BaseStyle.fs12.copyWith(color: Colors.white),
            )
          ],
        ),
        SizedBox(height: 16.h),
        Icon(
          Icons.more_horiz,
          size: 32,
          color: Colors.white,
        ),
        SizedBox(height: 16.h),
        Stack(
          alignment: Alignment.center,
          children: [
            Container(
              width: 48.w,
              height: 48.w,
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.white,
                  width: 2,
                ),
                borderRadius: BorderRadius.circular(10.r),
                color: Colors.white70,
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10.r),
                child: Obx(
                  () => Image.network(
                    controller.vlogerFace.value,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            SpinKitWave(
              size: 14,
              color: Colors.white70,
            ),
          ],
        ),
        SizedBox(height: 10.h),
      ],
    );

    Widget video = AspectRatio(
      aspectRatio: _controller.value.aspectRatio,
      child: VideoPlayer(_controller),
    );

    return Container(
      color: Colors.black,
      child: Stack(
        children: [
          Center(
            child: video,
          ),
          Stack(
            children: [
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 50),
                reverseDuration: const Duration(milliseconds: 200),
                child: _controller.value.isPlaying
                    ? const SizedBox.shrink()
                    : Container(
                        color: Colors.black26,
                        child: const Center(
                          child: Icon(
                            Icons.play_arrow_rounded,
                            color: Colors.white24,
                            size: 100.0,
                            semanticLabel: 'Play',
                          ),
                        ),
                      ),
              ),
              GestureDetector(
                onTap: () {
                  _controller.value.isPlaying
                      ? _controller.pause()
                      : _controller.play();
                },
              ),
            ],
          ),
          Positioned(
            bottom: 6,
            left: 0,
            child: bottomInfo,
          ),
          Positioned(
            right: 10,
            bottom: 0,
            child: rightInfo,
          ),
        ],
      ),
    );
  }

  Widget buildBottomSheetWidget(BuildContext context) {
    VideoDetailController controller = Get.put(VideoDetailController());
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
