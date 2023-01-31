import 'dart:io';

import 'package:get/get.dart';

import '../../../../modules/index/controllers/follow_controller.dart';

Socket? socket;

class VideoFollow {
  VideoFollow({
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

  static List<VideoFollow> fetchVideo() {
    FollowController followController = Get.put(FollowController());
    List<VideoFollow> list = followController.followList
        .map((e) => VideoFollow(
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
            play: true))
        .toList();
    return list;
  }
}
