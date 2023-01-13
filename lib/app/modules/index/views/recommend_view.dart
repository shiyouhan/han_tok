// ignore_for_file: prefer_const_constructors, library_prefixes

import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:han_tok/app/data/video/video.dart';
import 'package:han_tok/app/data/video/video_button.dart';
import 'package:han_tok/app/data/video/video_comment.dart';
import 'package:safemap/safemap.dart';
import 'package:video_player/video_player.dart';

import '../../../data/video/controller/video_list_controller.dart';
import '../../../data/video/video_page.dart';
import '../../../data/video/video_scaffold.dart';
import '../controllers/recommend_controller.dart';

import 'package:han_tok/app/data/video/bottomSheet.dart' as CustomBottomSheet;

class RecommendView extends GetView {
  const RecommendView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    RecommendController controller = Get.put(RecommendController());
    return Scaffold(
      body: Obx(() => controller.videoList.isEmpty
          ? Container(color: Colors.black)
          : RecommendPage()),
    );
  }
}

class RecommendPage extends StatefulWidget {
  const RecommendPage({super.key});

  @override
  State<RecommendPage> createState() => _RecommendPageState();
}

class _RecommendPageState extends State<RecommendPage>
    with WidgetsBindingObserver {
  VideoScaffoldController tkController = VideoScaffoldController();

  final PageController _pageController = PageController();

  final VideoListController _videoListController = VideoListController();

  /// 记录点赞
  Map<int, bool> favoriteMap = {};

  List<Video> videoDataList = [];

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    if (state != AppLifecycleState.resumed) {
      _videoListController.currentPlayer.pause();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _videoListController.currentPlayer.pause();
    super.dispose();
  }

  @override
  void initState() {
    videoDataList = Video.fetchVideo();
    WidgetsBinding.instance.addObserver(this);
    _videoListController.init(
      pageController: _pageController,
      initialList: videoDataList
          .map(
            (e) => VPVideoController(
              videoInfo: e,
              builder: () => VideoPlayerController.network(e.url),
            ),
          )
          .toList(),
      videoProvider: (int index, List<VPVideoController> list) async {
        return videoDataList
            .map(
              (e) => VPVideoController(
                videoInfo: e,
                builder: () => VideoPlayerController.network(e.url),
              ),
            )
            .toList();
      },
    );
    _videoListController.addListener(() {
      if (mounted) {
        setState(() {});
      }
    });
    tkController.addListener(
      () {
        if (tkController.value == VideoPagePosition.middle) {
          _videoListController.currentPlayer.play();
        } else {
          _videoListController.currentPlayer.pause();
        }
      },
    );

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // Widget? currentPage;

    // switch (tabBarType) {
    //   case TikTokPageTag.home:
    //     break;
    //   case TikTokPageTag.follow:
    //     currentPage = FollowPage();
    //     break;
    //   case TikTokPageTag.msg:
    //     currentPage = MsgPage();
    //     break;
    //   case TikTokPageTag.me:
    //     currentPage = UserPage(isSelfPage: true);
    //     break;
    // }
    // double a = MediaQuery.of(context).size.aspectRatio;
    // bool hasBottomPadding = a < 0.55;

    // bool hasBackground = hasBottomPadding;
    // hasBackground = tabBarType != TikTokPageTag.home;
    // if (hasBottomPadding) {
    //   hasBackground = true;
    // }
    // Widget tikTokTabBar = TikTokTabBar(
    //   // hasBackground: hasBackground,
    //   // current: tabBarType,
    //   onTabSwitch: (type) async {
    //     setState(() {
    //       // tabBarType = type;
    //       if (type == TikTokPageTag.home) {
    //         _videoListController.currentPlayer.play();
    //       } else {
    //         _videoListController.currentPlayer.pause();
    //       }
    //     });
    //   },
    //   // onAddButton: () {
    //   //   Navigator.of(context).push(
    //   //     MaterialPageRoute(
    //   //       fullscreenDialog: true,
    //   //       builder: (context) => CameraPage(),
    //   //     ),
    //   //   );
    //   // },
    // );

    // var userPage = UserPage(
    //   isSelfPage: false,
    //   canPop: true,
    //   onPop: () {
    //     tkController.animateToMiddle();
    //   },
    // );
    // var searchPage = SearchPage(
    //   onPop: tkController.animateToMiddle,
    // );

    // var header = tabBarType == TikTokPageTag.home
    //     ? TikTokHeader(
    //         onSearch: () {
    //           tkController.animateToLeft();
    //         },
    //       )
    //     : Container();

    // 组合
    return VideoScaffold(
      controller: tkController,
      // hasBottomPadding: hasBackground,
      // tabBar: tikTokTabBar,
      // header: header,
      // leftPage: searchPage,
      // rightPage: userPage,
      // enableGesture: tabBarType == TikTokPageTag.home,
      // onPullDownRefresh: _fetchData,
      page: Stack(
        // index: currentPage == null ? 0 : 1,
        children: <Widget>[
          PageView.builder(
            key: Key('home'),
            controller: _pageController,
            scrollDirection: Axis.vertical,
            itemCount: _videoListController.videoCount,
            itemBuilder: (context, i) {
              // 拼一个视频组件出来
              // bool isF = SafeMap(favoriteMap)[i].boolean;
              var player = _videoListController.playerOfIndex(i)!;
              var data = player.videoInfo!;

              Widget currentVideo = Center(
                child: AspectRatio(
                  aspectRatio: player.controller.value.aspectRatio,
                  child: VideoPlayer(player.controller),
                ),
              );

              currentVideo = VideoPage(
                // 手势播放与自然播放都会产生暂停按钮状态变化，待处理
                hidePauseIcon: !player.showPauseIcon.value,
                // aspectRatio: deviceRatio,
                key: Key('${data.url}$i'),
                tag: data.url,
                userInfoWidget: VideoUserInfo(
                  desc: data.content,
                  vlogerId: data.vlogerId,
                  vlogerFace: data.vlogerFace,
                  vlogerName: data.vlogerName,
                ),
                onSingleTap: () async {
                  if (player.controller.value.isPlaying) {
                    await player.pause();
                  } else {
                    await player.play();
                  }
                  setState(() {});
                },
                onAddFavorite: () {
                  setState(() {
                    favoriteMap[i] = true;
                  });
                },
                // rightButtonColumn: buttons,
                video: currentVideo, bottomPadding: 0,
              );
              return currentVideo;
            },
          ),
          // currentPage ?? Container(),
        ],
      ),
    );
  }
}
