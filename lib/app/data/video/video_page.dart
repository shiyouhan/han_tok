// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, depend_on_referenced_packages

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';

import 'package:han_tok/app/data/base_data.dart';
import 'package:han_tok/app/data/base_style.dart';
import 'package:han_tok/app/data/video/controller/video_controller.dart';
import 'package:han_tok/app/data/video/user_info.dart';

import '../../utils/Iconfont.dart';
import 'video_gesture.dart';

///
/// TikTok风格的一个视频页组件，覆盖在video上，提供以下功能：
/// 播放按钮的遮罩
/// 单击事件
/// 点赞事件回调（每次）
/// 长宽比控制
/// 底部padding（用于适配有沉浸式底部状态栏时）
///
class VideoPage extends StatelessWidget {
  final Widget? video;
  // final double aspectRatio;
  final String? tag;
  final double bottomPadding;

  final Widget? rightButtonColumn;
  final Widget? userInfoWidget;

  final bool hidePauseIcon;

  final Function? onAddFavorite;
  final Function? onSingleTap;

  const VideoPage({
    Key? key,
    required this.bottomPadding,
    this.tag,
    this.rightButtonColumn,
    this.userInfoWidget,
    this.onAddFavorite,
    this.onSingleTap,
    this.video,
    // required this.aspectRatio,
    this.hidePauseIcon: false,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    // 用户信息
    Widget userInfo = userInfoWidget ?? VideoUserInfo();
    // 视频加载的动画
    Widget videoLoading = VideoLoadingPlaceHolder();

    final size = MediaQuery.of(context).size;
    // 视频播放页
    Widget videoContainer = Stack(
      children: <Widget>[
        Container(
          child: videoLoading,
        ),
        Container(
          height: size.height,
          width: size.width,
          // color: Colors.black,
          alignment: Alignment.center,
          // child: video,
          child: AspectRatio(
            aspectRatio: 9 / 16,
            child: video,
          ),
        ),
        VideoGesture(
          onAddFavorite: onAddFavorite,
          onSingleTap: onSingleTap,
          child: Container(
            color: Colors.transparent,
            height: double.infinity,
            width: double.infinity,
          ),
        ),
        hidePauseIcon
            ? Container()
            : Container(
                height: double.infinity,
                width: double.infinity,
                alignment: Alignment.center,
                child: Icon(
                  Icons.play_circle_outline,
                  size: 120,
                  color: Colors.white.withOpacity(0.4),
                ),
              ),
      ],
    );
    Widget body = Stack(
      children: <Widget>[
        videoContainer,
        Container(
          height: double.infinity,
          width: double.infinity,
          alignment: Alignment.bottomLeft,
          child: userInfo,
        ),
      ],
    );
    return body;
  }
}

class VideoLoadingPlaceHolder extends StatefulWidget {
  const VideoLoadingPlaceHolder({
    Key? key,
  }) : super(key: key);

  @override
  State<VideoLoadingPlaceHolder> createState() =>
      _VideoLoadingPlaceHolderState();
}

class _VideoLoadingPlaceHolderState extends State<VideoLoadingPlaceHolder>
    with TickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    _controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1200));
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        SpinKitWave(
          color: Colors.white.withOpacity(.8),
          size: 50.0,
          controller: _controller,
        ),
      ],
    );
  }
}

class VideoUserInfo extends GetView {
  final String? desc;
  final String? vlogerId;
  final String? vlogerName;
  final String? vlogerFace;
  const VideoUserInfo({
    Key? key,
    this.vlogerId,
    this.vlogerFace,
    this.vlogerName,
    this.desc,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    VideoController videoController = Get.put(VideoController());

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
              Text(
                '$vlogerName',
                style: BaseStyle.fs16W.copyWith(fontWeight: FontWeight.w600),
              ),
            ],
          ),
          Container(
            width: size.width * 0.7,
            padding: EdgeInsets.symmetric(vertical: 6),
            child: Text(
              '$desc',
              style: BaseStyle.fs14.copyWith(color: Colors.white),
            ),
          ),
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
              GestureDetector(
                onTap: () => Get.to(() => UserInfo(vlogerId: vlogerId)),
                child: Container(
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
                    child: Image.network(
                      vlogerFace!,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 14,
                bottom: 0,
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
            ],
          ),
        ),
        SizedBox(height: 10.h),
        Column(
          children: [
            Icon(
              Icons.favorite,
              size: 40,
              color: Colors.white,
            ),
            SizedBox(height: 2.h),
            Text(
              '99万',
              style: BaseStyle.fs12.copyWith(color: Colors.white),
            )
          ],
        ),
        SizedBox(height: 10.h),
        Column(
          children: [
            Icon(
              IconFont.pinglun,
              size: 32,
              color: Colors.white,
            ),
            SizedBox(height: 4.h),
            Text(
              '99万',
              style: BaseStyle.fs12.copyWith(color: Colors.white),
            )
          ],
        ),
        SizedBox(height: 10.h),
        Column(
          children: [
            Icon(
              IconFont.shoucang,
              size: 32,
              color: Colors.white,
            ),
            SizedBox(height: 4.h),
            Text(
              '6789',
              style: BaseStyle.fs12.copyWith(color: Colors.white),
            )
          ],
        ),
        SizedBox(height: 10.h),
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
                    return Container(
                      height: size.height * 0.45,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20),
                        ),
                        color: Colors.white,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // SizedBox(height: 10.h),
                          Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 16.w, vertical: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  '分享给朋友',
                                  style: BaseStyle.fs14
                                      .copyWith(fontWeight: FontWeight.bold),
                                ),
                                GestureDetector(
                                  onTap: () => Get.back(),
                                  child: Container(
                                    width: 30.w,
                                    height: 30.h,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15.r),
                                      color: BaseData.kBackColor,
                                    ),
                                    child: Icon(
                                      Icons.clear,
                                      size: 16,
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                          SizedBox(height: 6.h),
                          Container(
                            // height: 88.h,
                            padding: EdgeInsets.only(left: 16.w),
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: videoController.fansList
                                    .map(
                                      (element) => Padding(
                                        padding: EdgeInsets.only(right: 22.w),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            SizedBox(
                                              width: 50.w,
                                              height: 50.h,
                                              child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(25.r),
                                                child: Image.network(
                                                    element.face.toString()),
                                              ),
                                            ),
                                            SizedBox(height: 10.h),
                                            Container(
                                              height: 40.h,
                                              width: 50.w,
                                              alignment: Alignment.topCenter,
                                              child: Text(
                                                element.nickname.toString(),
                                                style: BaseStyle.fs10,
                                                textAlign: TextAlign.center,
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                                softWrap: true,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    )
                                    .toList(),
                              ),
                            ),
                          ),
                          Container(
                            height: 1,
                            margin: EdgeInsets.only(left: 16),
                            color: Colors.grey.withOpacity(.3),
                          ),
                          SizedBox(height: 16.h),
                          Row(
                            children: [
                              SizedBox(width: 16.w),
                              Padding(
                                padding: EdgeInsets.only(right: 22.w),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      width: 50.w,
                                      height: 50.h,
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(25.r),
                                        color: Colors.green,
                                      ),
                                      child: Icon(
                                        IconFont.pengyouquan,
                                        size: 32,
                                        color: Colors.white,
                                      ),
                                    ),
                                    SizedBox(height: 10.h),
                                    Text(
                                      '朋友圈',
                                      style: BaseStyle.fs10,
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(right: 22.w),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      width: 50.w,
                                      height: 50.h,
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(25.r),
                                        color: Colors.green,
                                      ),
                                      child: Icon(
                                        IconFont.weixin,
                                        size: 32,
                                        color: Colors.white,
                                      ),
                                    ),
                                    SizedBox(height: 10.h),
                                    Text(
                                      '微信',
                                      style: BaseStyle.fs10,
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(right: 22.w),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      width: 50.w,
                                      height: 50.h,
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(25.r),
                                        color: Colors.orangeAccent,
                                      ),
                                      child: Icon(
                                        IconFont.qqkongjian,
                                        size: 32,
                                        color: Colors.white,
                                      ),
                                    ),
                                    SizedBox(height: 10.h),
                                    Text(
                                      'QQ空间',
                                      style: BaseStyle.fs10,
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(right: 22.w),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      width: 50.w,
                                      height: 50.h,
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(25.r),
                                        color: Colors.blue,
                                      ),
                                      child: Icon(
                                        IconFont.QQ,
                                        size: 32,
                                        color: Colors.white,
                                      ),
                                    ),
                                    SizedBox(height: 10.h),
                                    Text(
                                      'QQ',
                                      style: BaseStyle.fs10,
                                    ),
                                  ],
                                ),
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    width: 50.w,
                                    height: 50.h,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(25.r),
                                      color: Colors.blueAccent,
                                    ),
                                    child: Icon(
                                      Icons.more_horiz,
                                      size: 32,
                                      color: Colors.white,
                                    ),
                                  ),
                                  SizedBox(height: 10.h),
                                  Text(
                                    '更多分享',
                                    style: BaseStyle.fs10,
                                  ),
                                ],
                              ),
                            ],
                          ),
                          SizedBox(height: 16.h),
                          Row(
                            children: [
                              SizedBox(width: 16.w),
                              Padding(
                                padding: EdgeInsets.only(right: 22.w),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      width: 50.w,
                                      height: 50.h,
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(25.r),
                                        color: BaseData.bodyColor,
                                      ),
                                      child: Icon(
                                        Icons.vertical_align_bottom,
                                        size: 28,
                                        color: Colors.grey,
                                      ),
                                    ),
                                    SizedBox(height: 10.h),
                                    Text(
                                      '保存至相册',
                                      style: BaseStyle.fs10,
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(right: 22.w),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      width: 50.w,
                                      height: 50.h,
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(25.r),
                                        color: BaseData.bodyColor,
                                      ),
                                      child: Icon(
                                        IconFont.lianjie,
                                        size: 28,
                                        color: Colors.grey,
                                      ),
                                    ),
                                    SizedBox(height: 10.h),
                                    Text(
                                      '复制链接',
                                      style: BaseStyle.fs10,
                                    ),
                                  ],
                                ),
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    width: 50.w,
                                    height: 50.h,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(25.r),
                                      color: BaseData.bodyColor,
                                    ),
                                    child: Icon(
                                      IconFont.copy,
                                      size: 28,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  SizedBox(height: 10.h),
                                  Text(
                                    '生成图片',
                                    style: BaseStyle.fs10,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                )
              },
              child: Icon(
                IconFont.zhuanfa,
                size: 32,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 4.h),
            Text(
              '1',
              style: BaseStyle.fs12.copyWith(color: Colors.white),
            )
          ],
        ),
        SizedBox(height: 10.h),
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
                child: Image.network(
                  vlogerFace!,
                  fit: BoxFit.cover,
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

    return Stack(
      children: [
        Positioned(
          bottom: 0,
          left: 0,
          child: bottomInfo,
        ),
        Positioned(
          right: 10,
          bottom: 0,
          child: rightInfo,
        ),
      ],
    );
  }
}

class FunctionListItem extends StatelessWidget {
  String function;
  IconData iconData;
  Color bgColor;

  FunctionListItem(this.function, this.iconData, this.bgColor, {super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 50.w,
          height: 50.h,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(25.r),
            color: bgColor,
          ),
          child: Icon(
            iconData,
            size: 32,
            color: Colors.white,
          ),
        ),
        SizedBox(height: 10.h),
        Text(
          function,
          style: BaseStyle.fs10,
        ),
      ],
    );
  }
}

class FunctionList {
  String function;
  IconData iconData;
  Color bgColor;

  FunctionList(this.function, this.iconData, this.bgColor);
}

final List<FunctionList> items = [
  FunctionList('朋友圈', IconFont.pengyouquan, Colors.green),
  FunctionList('微信', IconFont.weixin, Colors.green),
  FunctionList('QQ空间', IconFont.qqkongjian, Colors.orangeAccent),
  FunctionList('QQ', IconFont.QQ, Colors.blue),
  FunctionList('更多分享', Icons.more_horiz, Colors.blueAccent),
];
