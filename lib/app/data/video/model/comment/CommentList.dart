// ignore_for_file: prefer_void_to_null

class CommentList {
  CommentList({
    this.id,
    required this.commentId,
    required this.vlogerId,
    required this.fatherCommentId,
    required this.vlogId,
    required this.commentUserId,
    required this.commentUserNickname,
    required this.commentUserFace,
    required this.content,
    required this.likeCounts,
    this.replyedUserNickname,
    required this.createTime,
    required this.isLike,
  });
  late final Null id;
  late final String commentId;
  late final String vlogerId;
  late final String fatherCommentId;
  late final String vlogId;
  late final String commentUserId;
  late final String commentUserNickname;
  late final String commentUserFace;
  late final String content;
  late final int likeCounts;
  late final String? replyedUserNickname;
  late final String createTime;
  late final int isLike;

  CommentList.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    commentId = json['commentId'];
    vlogerId = json['vlogerId'];
    fatherCommentId = json['fatherCommentId'];
    vlogId = json['vlogId'];
    commentUserId = json['commentUserId'];
    commentUserNickname = json['commentUserNickname'];
    commentUserFace = json['commentUserFace'];
    content = json['content'];
    likeCounts = json['likeCounts'];
    replyedUserNickname = json['replyedUserNickname'];
    createTime = json['createTime'];
    isLike = json['isLike'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['commentId'] = commentId;
    _data['vlogerId'] = vlogerId;
    _data['fatherCommentId'] = fatherCommentId;
    _data['vlogId'] = vlogId;
    _data['commentUserId'] = commentUserId;
    _data['commentUserNickname'] = commentUserNickname;
    _data['commentUserFace'] = commentUserFace;
    _data['content'] = content;
    _data['likeCounts'] = likeCounts;
    _data['replyedUserNickname'] = replyedUserNickname;
    _data['createTime'] = createTime;
    _data['isLike'] = isLike;
    return _data;
  }
}
