// ignore_for_file: prefer_const_constructors, must_be_immutable, depend_on_referenced_packages

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';
import 'package:video_player/video_player.dart';

import '../../../../data/base_data.dart';
import '../../../../data/base_style.dart';
import '../../../../utils/Iconfont.dart';
import '../../controllers/vlog_detail_controller.dart';

class VlogDetailView extends GetView {
  String vlogId;
  String vlogerId;
  String url;
  VlogDetailView(
      {Key? key,
      required this.vlogId,
      required this.url,
      required this.vlogerId})
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
            body: VlogDetail(vlogId: vlogId, vlogerId: vlogerId, url: url),
          ),
        ),
      ),
    );
  }
}

class VlogDetail extends StatefulWidget {
  String vlogId;
  String vlogerId;
  String url;
  VlogDetail(
      {Key? key,
      required this.vlogId,
      required this.url,
      required this.vlogerId})
      : super(key: key);

  @override
  State<VlogDetail> createState() => _VlogDetailState();
}

class _VlogDetailState extends State<VlogDetail> {
  VlogDetailController controller = Get.put(VlogDetailController());
  late VideoPlayerController _controller;

  @override
  void initState() {
    controller.vlogId.value = widget.vlogId;
    controller.vlogerId.value = widget.vlogerId;
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