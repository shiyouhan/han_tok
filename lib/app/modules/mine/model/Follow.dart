// ignore_for_file: no_leading_underscores_for_local_identifiers, file_names

class Follow {
  Follow({
    required this.vlogerId,
    required this.nickname,
    required this.face,
    required this.followed,
  });
  late final String vlogerId;
  late final String nickname;
  late final String face;
  late final bool followed;

  Follow.fromJson(Map<String, dynamic> json) {
    vlogerId = json['vlogerId'];
    nickname = json['nickname'];
    face = json['face'];
    followed = json['followed'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['vlogerId'] = vlogerId;
    _data['nickname'] = nickname;
    _data['face'] = face;
    _data['followed'] = followed;
    return _data;
  }
}
