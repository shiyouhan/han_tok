import 'dart:io';

import 'package:get/get.dart';

import '../../../../modules/index/controllers/recommend_controller.dart';

Socket? socket;

class Video {
  Video({
    required this.vlogId,
    required this.vlogerId,
    required this.vlogerFace,
    required this.vlogerName,
    required this.content,
    required this.url,
    required this.cover,
    required this.width,
    required this.height,
    required this.likeCounts,
    required this.commentsCounts,
    required this.isPrivate,
    required this.doIFollowVloger,
    required this.doILikeThisVlog,
    required this.play,
  });

  final String vlogId;
  final String vlogerId;
  final String vlogerFace;
  final String vlogerName;
  final String content;
  final String url;
  final String cover;
  final int width;
  final int height;
  final int likeCounts;
  final int commentsCounts;
  final int isPrivate;
  final bool doIFollowVloger;
  final bool doILikeThisVlog;
  final bool play;

  static List<Video> fetchVideo() {
    RecommendController recommendController = Get.put(RecommendController());
    List<Video> list = recommendController.videoList
        .map((e) => Video(
            vlogId: e.vlogId.toString(),
            vlogerId: e.vlogerId.toString(),
            vlogerFace: e.vlogerFace.toString(),
            vlogerName: e.vlogerName.toString(),
            content: e.content.toString(),
            url: e.url.toString(),
            cover: e.cover.toString(),
            width: 100,
            height: 100,
            likeCounts: e.likeCounts,
            commentsCounts: e.commentsCounts,
            isPrivate: e.isPrivate,
            doIFollowVloger: e.doIFollowVloger,
            doILikeThisVlog: e.doILikeThisVlog,
            play: e.play))
        .toList();
    return list;
  }
}
