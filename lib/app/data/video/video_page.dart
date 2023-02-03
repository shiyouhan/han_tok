// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, depend_on_referenced_packages, avoid_print, prefer_interpolation_to_compose_strings

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:han_tok/app/utils/DataUtil.dart';
import 'package:han_tok/app/utils/DateUtil.dart';
import 'package:like_button/like_button.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';

import 'package:han_tok/app/data/base_data.dart';
import 'package:han_tok/app/data/base_style.dart';
import 'package:han_tok/app/data/video/controller/video_controller.dart';
import 'package:han_tok/app/data/video/user_info.dart';

import '../../../main.dart';
import '../../modules/mine/controllers/mine_controller.dart';
import '../../modules/mine/model/Video.dart';
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
    this.hidePauseIcon = false,
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
                  Icons.play_arrow_rounded,
                  size: 100.0,
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

class VideoUserInfo extends StatefulWidget {
  final String? desc;
  final String? vlogId;
  final String? vlogerId;
  final String? vlogerName;
  final String? vlogerFace;
  final int? likeCounts;
  final int? commentsCounts;
  final bool? doILikeThisVlog;
  const VideoUserInfo({
    Key? key,
    this.vlogId,
    this.vlogerId,
    this.vlogerFace,
    this.vlogerName,
    this.desc,
    this.likeCounts,
    this.commentsCounts,
    this.doILikeThisVlog,
  }) : super(key: key);

  @override
  State<VideoUserInfo> createState() => _VideoUserInfoState();
}

class _VideoUserInfoState extends State<VideoUserInfo>
    with WidgetsBindingObserver {
  VideoController videoController = Get.put(VideoController());
  MineController mineController = Get.put(MineController());
  //TextEditingController commentController = TextEditingController();
  FocusNode focusNode = FocusNode();

  //TODO:查看是否关注
  queryFollow() async {
    var prefs = await SharedPreferences.getInstance();
    String id = prefs.getString('id')!;

    if (widget.vlogerId == id) {
      videoController.isMine.value = true;
    } else {
      videoController.isMine.value = false;
      request
          .get(
              '/fans/queryDoIFollowVloger?vlogerId=${widget.vlogerId}&myId=$id')
          .then((value) async {
        videoController.followed.value = value;
        print(value);
      }).catchError((error) {
        EasyLoading.showError('数据解析异常');
        print(error);
      });
    }
  }

  //TODO:关注用户
  follow() async {
    var prefs = await SharedPreferences.getInstance();
    String id = prefs.getString('id')!;
    String token = prefs.getString('userToken')!;

    Map<String, dynamic> headers = {
      "headerUserId": id,
      "headerUserToken": token,
    };

    request
        .post('/fans/follow?vlogerId=${widget.vlogerId}&myId=$id',
            headers: headers)
        .then((value) async {
      videoController.followed.value = true;
      videoController.renew();
      print(value);
    }).catchError((error) {
      EasyLoading.showError('数据解析异常');
      print(error);
    });
  }

  //todo:获取视频详情
  getDetail() async {
    var prefs = await SharedPreferences.getInstance();
    String id = prefs.getString('id')!;

    request
        .get('/vlog/detail?userId=$id&vlogId=${widget.vlogId}')
        .then((value) async {
      videoController.doILikeThisVlog.value =
          Video.fromJson(value).doILikeThisVlog;
      videoController.likeCounts.value = Video.fromJson(value).likeCounts;
      print(value);
    }).catchError((error) {
      EasyLoading.showError('数据解析异常');
      print(error);
    });
  }

  //TODO:点赞
  Future<bool> changeData(status) async {
    like();
    return Future.value(!status);
  }

  //TODO:视频点赞
  like() async {
    var prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('userToken')!;
    String id = prefs.getString('id')!;

    Map<String, dynamic> headers = {
      "headerUserId": id,
      "headerUserToken": token,
    };
    request
        .post(
            '/vlog/like?userId=$id&vlogId=${widget.vlogId}&vlogerId=${widget.vlogerId}',
            headers: headers)
        .then((value) {
      print(value);
      videoController.doILikeThisVlog.value = true;
      getDetail();
      mineController.renewLike();
    }).catchError((error) {
      EasyLoading.showError('数据解析异常');
      print(error);
    });
  }

  //TODO:视频取消点赞
  unlike() async {
    var prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('userToken')!;
    String id = prefs.getString('id')!;

    Map<String, dynamic> headers = {
      "headerUserId": id,
      "headerUserToken": token,
    };
    request
        .post(
            '/vlog/unlike?userId=$id&vlogId=${widget.vlogId}&vlogerId=${widget.vlogerId}',
            headers: headers)
        .then((value) {
      print(value);
      videoController.doILikeThisVlog.value = false;
      getDetail();
      mineController.renewLike();
    }).catchError((error) {
      EasyLoading.showError('数据解析异常');
      print(error);
    });
  }

  getRefresh() async {
    print('页面刷新');
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
  void initState() {
    videoController.vlogId.value = widget.vlogId!;
    videoController.vlogerId.value = widget.vlogerId!;
    getDetail();
    queryFollow();
    videoController.renewComment();
    videoController.commentController = TextEditingController();
    focusNode.addListener(() {
      if (focusNode.hasFocus) {
        print('得到焦点');
      } else {
        print('失去焦点');
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    focusNode.dispose();
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
              Text(
                '${widget.vlogerName}',
                style: BaseStyle.fs16W.copyWith(fontWeight: FontWeight.w600),
              ),
              SizedBox(width: 6.w),
              Container(
                decoration: BoxDecoration(
                  color: BaseData.bodyColor.withOpacity(.2),
                  borderRadius: BorderRadius.circular(2.r),
                ),
                padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 1.h),
                child: Obx(() => videoController.isMine.value == true
                    ? Text(
                        '自己',
                        style: BaseStyle.fs12G,
                      )
                    : Container()),
              )
            ],
          ),
          Container(
            width: size.width * 0.7,
            padding: EdgeInsets.symmetric(vertical: 6),
            child: Text(
              '${widget.desc}',
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
                // onTap: () => Get.to(() => UserInfo(vlogerId: widget.vlogerId)),
                onTap: () => Navigator.of(context)
                    .push(
                      MaterialPageRoute(
                          builder: (_) => UserInfo(vlogerId: widget.vlogerId)),
                    )
                    .then((val) => val ? getRefresh() : null),
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
                      widget.vlogerFace!,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              Obx(
                () => videoController.isMine.value == false
                    ? Obx(
                        () => videoController.followed.value == false
                            ? Positioned(
                                left: 14,
                                bottom: 0,
                                child: GestureDetector(
                                  onTap: () => follow(),
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
              )
            ],
          ),
        ),
        SizedBox(height: 10.h),
        Column(
          children: [
            Obx(
              () => videoController.doILikeThisVlog.value == false
                  ? LikeButton(
                      size: 40,
                      circleColor: CircleColor(
                          start: Color(0XF8FA9FB7), end: Colors.red),
                      bubblesColor: BubblesColor(
                        dotPrimaryColor: Color(0XF8FA9FB7),
                        dotSecondaryColor: Colors.red,
                      ),
                      onTap: (isLiked) {
                        return changeData(isLiked);
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
                      onTap: () => unlike(),
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
                DataUtil().generator(videoController.likeCounts.value),
                style: BaseStyle.fs12.copyWith(color: Colors.white),
              ),
            ),
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
                                            '${videoController.commentList.length}条评论',
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
                                          child: videoController
                                                  .commentList.isEmpty
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
                                                        videoController
                                                            .commentList
                                                            .map(
                                                              (element) =>
                                                                  GestureDetector(
                                                                      onLongPress:
                                                                          () =>
                                                                              {
                                                                                videoController.commentId.value = element.commentId,
                                                                                videoController.commentUserId.value = element.commentUserId,
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
                                                                                                videoController.fatherCommentId.value = element.commentId,
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
                                                                                                        videoController.commentId.value = element.commentId,
                                                                                                        videoController.like(),
                                                                                                      },
                                                                                                      child: Icon(Icons.favorite_border, size: 14, color: Colors.grey),
                                                                                                    )
                                                                                                  : GestureDetector(
                                                                                                      onTap: () => {
                                                                                                        videoController.commentId.value = element.commentId,
                                                                                                        videoController.unLike(),
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
                                        // videoController.fatherComment.value !=
                                        //         ''
                                        //     ? ('@' +
                                        //         videoController
                                        //             .fatherComment.value)
                                        //     : '善语结善缘，恶言伤人心',
                                        hintStyle: BaseStyle.fs14G,
                                        border: InputBorder.none,
                                        suffixIcon: Icon(Icons.alternate_email),
                                      ),
                                      controller:
                                          videoController.commentController,
                                      onChanged: (value) {
                                        videoController.commentStr(value);
                                      },
                                      onSubmitted: (value) {
                                        videoController.commentCreate();
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
              videoController.commentList.isEmpty
                  ? '抢首评'
                  : DataUtil().generator(videoController.commentList.length),
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
              '收藏',
              style: BaseStyle.fs12.copyWith(color: Colors.white),
            )
          ],
        ),
        SizedBox(height: 10.h),
        Column(
          children: [
            GestureDetector(
              onTap: () => {
                videoController.renew(),
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
                            alignment: Alignment.topLeft,
                            padding: EdgeInsets.only(left: 16.w),
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Obx(() => Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: videoController.followList
                                        .map(
                                          (element) => Padding(
                                            padding:
                                                EdgeInsets.only(right: 22.w),
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
                                                        BorderRadius.circular(
                                                            25.r),
                                                    child: Image.network(element
                                                        .face
                                                        .toString()),
                                                  ),
                                                ),
                                                SizedBox(height: 10.h),
                                                Container(
                                                  height: 40.h,
                                                  width: 50.w,
                                                  alignment:
                                                      Alignment.topCenter,
                                                  child: Text(
                                                    element.nickname.toString(),
                                                    style: BaseStyle.fs10,
                                                    textAlign: TextAlign.center,
                                                    maxLines: 2,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    softWrap: true,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        )
                                        .toList(),
                                  )),
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
              '分享',
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
                  widget.vlogerFace!,
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

  Widget buildBottomSheetWidget(BuildContext context) {
    VideoController videoController = Get.put(VideoController());
    return SafeArea(
      child: Container(
        height: 50.h,
        margin: EdgeInsets.symmetric(horizontal: 10.w),
        child: Column(
          children: [
            GestureDetector(
              onTap: () {
                videoController.delete();
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

class FunctionListItem extends StatelessWidget {
  final String function;
  final IconData iconData;
  final Color bgColor;

  const FunctionListItem(this.function, this.iconData, this.bgColor,
      {super.key});

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
