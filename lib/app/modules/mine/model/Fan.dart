// ignore_for_file: no_leading_underscores_for_local_identifiers, file_names

class Fan {
  Fan({
    required this.fanId,
    required this.nickname,
    required this.face,
    required this.friend,
  });
  late final String fanId;
  late final String nickname;
  late final String face;
  late final bool friend;

  Fan.fromJson(Map<String, dynamic> json) {
    fanId = json['fanId'];
    nickname = json['nickname'];
    face = json['face'];
    friend = json['friend'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['fanId'] = fanId;
    _data['nickname'] = nickname;
    _data['face'] = face;
    _data['friend'] = friend;
    return _data;
  }
}
