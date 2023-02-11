// ignore_for_file: no_leading_underscores_for_local_identifiers

class MessageFour {
  MessageFour({
    required this.id,
    required this.fromUserId,
    required this.fromNickname,
    required this.fromFace,
    required this.toUserId,
    required this.msgType,
    required this.msgContent,
    required this.createTime,
  });
  late final String id;
  late final String fromUserId;
  late final String fromNickname;
  late final String fromFace;
  late final String toUserId;
  late final int msgType;
  late final MsgContent msgContent;
  late final String createTime;

  MessageFour.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    fromUserId = json['fromUserId'];
    fromNickname = json['fromNickname'];
    fromFace = json['fromFace'];
    toUserId = json['toUserId'];
    msgType = json['msgType'];
    msgContent = MsgContent.fromJson(json['msgContent']);
    createTime = json['createTime'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['fromUserId'] = fromUserId;
    _data['fromNickname'] = fromNickname;
    _data['fromFace'] = fromFace;
    _data['toUserId'] = toUserId;
    _data['msgType'] = msgType;
    _data['msgContent'] = msgContent.toJson();
    _data['createTime'] = createTime;
    return _data;
  }
}

class MsgContent {
  MsgContent({
    required this.vlogId,
    required this.commentId,
    required this.commentContent,
    required this.vlogCover,
    required this.url,
  });
  late final String vlogId;
  late final String commentId;
  late final String commentContent;
  late final String vlogCover;
  late final String url;

  MsgContent.fromJson(Map<String, dynamic> json) {
    vlogId = json['vlogId'];
    commentId = json['commentId'];
    commentContent = json['commentContent'];
    vlogCover = json['vlogCover'];
    url = json['url'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['vlogId'] = vlogId;
    _data['commentId'] = commentId;
    _data['commentContent'] = commentContent;
    _data['vlogCover'] = vlogCover;
    _data['url'] = url;
    return _data;
  }
}
