// ignore_for_file: no_leading_underscores_for_local_identifiers

class IndexList {
  IndexList({
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

  late final String vlogId;
  late final String vlogerId;
  late final String vlogerFace;
  late final String vlogerName;
  late final String content;
  late final String url;
  late final String cover;
  late final int width;
  late final int height;
  late final int likeCounts;
  late final int commentsCounts;
  late final int isPrivate;
  late final bool doIFollowVloger;
  late final bool doILikeThisVlog;
  late final bool play;

  IndexList.fromJson(Map<String, dynamic> json) {
    vlogId = json['vlogId'];
    vlogerId = json['vlogerId'];
    vlogerFace = json['vlogerFace'];
    vlogerName = json['vlogerName'];
    content = json['content'];
    url = json['url'];
    cover = json['cover'];
    width = json['width'];
    height = json['height'];
    likeCounts = json['likeCounts'];
    commentsCounts = json['commentsCounts'];
    isPrivate = json['isPrivate'];
    doIFollowVloger = json['doIFollowVloger'];
    doILikeThisVlog = json['doILikeThisVlog'];
    play = json['play'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['vlogId'] = vlogId;
    _data['vlogerId'] = vlogerId;
    _data['vlogerFace'] = vlogerFace;
    _data['vlogerName'] = vlogerName;
    _data['content'] = content;
    _data['url'] = url;
    _data['cover'] = cover;
    _data['width'] = width;
    _data['height'] = height;
    _data['likeCounts'] = likeCounts;
    _data['commentsCounts'] = commentsCounts;
    _data['isPrivate'] = isPrivate;
    _data['doIFollowVloger'] = doIFollowVloger;
    _data['doILikeThisVlog'] = doILikeThisVlog;
    _data['play'] = play;
    return _data;
  }
}
