// ignore_for_file: no_leading_underscores_for_local_identifiers

class MessageOne {
  MessageOne({
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

  MessageOne.fromJson(Map<String, dynamic> json) {
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
    required this.isFriend,
  });
  late final bool isFriend;

  MsgContent.fromJson(Map<String, dynamic> json) {
    isFriend = json['isFriend'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['isFriend'] = isFriend;
    return _data;
  }
}
