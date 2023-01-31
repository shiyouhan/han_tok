// ignore_for_file: must_be_immutable, prefer_const_constructors, depend_on_referenced_packages

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';
import 'package:han_tok/app/data/video/controller/user_info_controller.dart';
import 'package:han_tok/app/utils/DataUtil.dart';
import 'package:like_button/like_button.dart';
import 'package:video_player/video_player.dart';

import '../../../../data/base_style.dart';
import '../../../../utils/Iconfont.dart';
import '../../controllers/opus_detail_controller.dart';

class OpusDetailView extends GetView {
  String vlogId;
  String vlogerId;
  String url;
  int likeCounts;
  String updatedTime;
  OpusDetailView(
      {Key? key,
      required this.vlogId,
      required this.vlogerId,
      required this.url,
      required this.updatedTime,
      required this.likeCounts})
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
            body: OpusDetail(
                vlogId: vlogId,
                vlogerId: vlogerId,
                updatedTime: updatedTime,
                likeCounts: likeCounts,
                url: url),
          ),
        ),
      ),
    );
  }
}

class OpusDetail extends StatefulWidget {
  String vlogId;
  String vlogerId;
  String updatedTime;
  String url;
  int likeCounts;
  OpusDetail(
      {Key? key,
      required this.vlogId,
      required this.vlogerId,
      required this.url,
      required this.likeCounts,
      required this.updatedTime})
      : super(key: key);

  @override
  State<OpusDetail> createState() => _OpusDetailState();
}

class _OpusDetailState extends State<OpusDetail> {
  OpusDetailController controller = Get.put(OpusDetailController());
  UserInfoController infoController = Get.put(UserInfoController());
  late VideoPlayerController _controller;

  @override
  void initState() {
    controller.vlogId.value = widget.vlogId;
    controller.vlogerId.value = widget.vlogerId;
    controller.updatedTime.value = widget.updatedTime;
    controller.getDetail();
    _controller = VideoPlayerController.network(widget.url);
    _controller.addListener(() {
      setState(() {});
    });
    _controller.setLooping(true);
    _controller.initialize().then((_) => setState(() {}));
    _controller.play();
    super.initState();
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
      padding: EdgeInsets.only(
        left: 20,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                '@',
                style: BaseStyle.fs16W,
              ),
              Obx(
                () => Text(
                  controller.vlogerName.value,
                  style: BaseStyle.fs16W.copyWith(fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
          Container(
            width: size.width * 0.7,
            padding: EdgeInsets.symmetric(vertical: 6),
            child: Obx(
              () => Text(
                controller.content.value,
                style: BaseStyle.fs14.copyWith(color: Colors.white),
              ),
            ),
          ),
          Obx(() => Row(
                children: [
                  Text(
                    controller.updatedTime.value,
                    style: BaseStyle.fs12G,
                  ),
                  SizedBox(width: 6.w),
                  Text(
                      infoController.province.isNotEmpty
                          ? 'IP所属:${infoController.province.value.substring(0, infoController.province.value.length - 1)}'
                          : '',
                      style: BaseStyle.fs12G)
                ],
              ))
        ],
      ),
    );

    Widget rightInfo = Column(
      children: [
        SizedBox(
          width: 52.w,
          height: 56.h,
          child: Stack(
            children: <Widget>[
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
              Obx(
                () => controller.doIFollowVloger.value == false
                    ? Positioned(
                        left: 14,
                        bottom: 0,
                        child: GestureDetector(
                          onTap: () => controller.follow(),
                          child: Container(
                            width: 22.w,
                            height: 22.h,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(11.r),
                              color: Colors.pink,
                            ),
                            child: Icon(
                              Icons.add,
                              size: 16,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      )
                    : Positioned(
                        left: 14,
                        bottom: 0,
                        child: Container(
                          width: 22.w,
                          height: 22.h,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(11.r),
                          ),
                        ),
                      ),
              ),
            ],
          ),
        ),
        SizedBox(height: 16.h),
        Column(
          children: [
            Obx(
              () => controller.doILikeThisVlog.value == false
                  ? LikeButton(
                      size: 40,
                      circleColor: CircleColor(
                          start: Color(0XF8FA9FB7), end: Colors.red),
                      bubblesColor: BubblesColor(
                        dotPrimaryColor: Color(0XF8FA9FB7),
                        dotSecondaryColor: Colors.red,
                      ),
                      onTap: (isLiked) {
                        return controller.changeData(isLiked);
                      },
                      likeBuilder: (bool isLiked) {
                        return Icon(
                          Icons.favorite,
                          color: Colors.white,
                          size: 40,
                        );
                      },
                    )
                  : GestureDetector(
                      onTap: () => controller.unlike(),
                      child: Icon(
                        Icons.favorite,
                        size: 40,
                        color: Colors.red,
                      ),
                    ),
            ),
            SizedBox(height: 2.h),
            Obx(
              () => Text(
                controller.likeCounts.value == 0
                    ? '赞'
                    : DataUtil().generator(controller.likeCounts.value),
                style: BaseStyle.fs12.copyWith(color: Colors.white),
              ),
            ),
          ],
        ),
        SizedBox(height: 16.h),
        Column(
          children: [
            Icon(
              IconFont.pinglun,
              size: 32,
              color: Colors.white,
            ),
            SizedBox(height: 4.h),
            Text(
              '抢首评',
              style: BaseStyle.fs12.copyWith(color: Colors.white),
            )
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
}
