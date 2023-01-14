// ignore_for_file: must_be_immutable, prefer_const_constructors, depend_on_referenced_packages

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';
import 'package:han_tok/app/modules/mine/controllers/video_detail_controller.dart';
import 'package:video_player/video_player.dart';

import '../../../../data/base_data.dart';
import '../../../../data/base_style.dart';
import '../../../../utils/Iconfont.dart';

class VideoDetailView extends GetView {
  String vlogId;
  String url;
  VideoDetailView({Key? key, required this.vlogId, required this.url})
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
            body: VideoDetail(vlogId: vlogId, url: url),
          ),
        ),
      ),
    );
  }
}

class VideoDetail extends StatefulWidget {
  String vlogId;
  String url;
  VideoDetail({Key? key, required this.vlogId, required this.url})
      : super(key: key);

  @override
  State<VideoDetail> createState() => _VideoDetailState();
}

class _VideoDetailState extends State<VideoDetail> {
  VideoDetailController controller = Get.put(VideoDetailController());
  late VideoPlayerController _controller;
  // late String url;

  @override
  void initState() {
    controller.vlogId.value = widget.vlogId;
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
              Obx(
                () => Text(controller.vlogerName.value,
                    style:
                        BaseStyle.fs14G.copyWith(fontWeight: FontWeight.bold)),
              ),
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
              '赞',
              style: BaseStyle.fs12.copyWith(color: Colors.white),
            )
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
