class PublicList {
  PublicList({
    required this.id,
    required this.vlogerId,
    required this.url,
    required this.cover,
    required this.title,
    required this.width,
    required this.height,
    required this.likeCounts,
    required this.commentsCounts,
    required this.isPrivate,
    required this.createdTime,
    required this.updatedTime,
  });
  late final String id;
  late final String vlogerId;
  late final String url;
  late final String cover;
  late final String title;
  late final int width;
  late final int height;
  late final int likeCounts;
  late final int commentsCounts;
  late final int isPrivate;
  late final String createdTime;
  late final String updatedTime;

  PublicList.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    vlogerId = json['vlogerId'];
    url = json['url'];
    cover = json['cover'];
    title = json['title'];
    width = json['width'];
    height = json['height'];
    likeCounts = json['likeCounts'];
    commentsCounts = json['commentsCounts'];
    isPrivate = json['isPrivate'];
    createdTime = json['createdTime'];
    updatedTime = json['updatedTime'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['vlogerId'] = vlogerId;
    _data['url'] = url;
    _data['cover'] = cover;
    _data['title'] = title;
    _data['width'] = width;
    _data['height'] = height;
    _data['likeCounts'] = likeCounts;
    _data['commentsCounts'] = commentsCounts;
    _data['isPrivate'] = isPrivate;
    _data['createdTime'] = createdTime;
    _data['updatedTime'] = updatedTime;
    return _data;
  }
}
