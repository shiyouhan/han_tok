// ignore_for_file: prefer_void_to_null, no_leading_underscores_for_local_identifiers

class User {
  User({
    required this.id,
    required this.mobile,
    required this.password,
    required this.nickname,
    required this.hantokNum,
    required this.avatar,
    required this.sex,
    required this.birthday,
    required this.country,
    required this.province,
    required this.city,
    required this.district,
    required this.description,
    required this.bg,
    required this.canHantokNumBeUpdated,
    required this.createdTime,
    required this.updatedTime,
    this.userToken,
    required this.myFollowsCounts,
    required this.myFansCounts,
    required this.totalLikeMeCounts,
  });
  late final String id;
  late final String mobile;
  late final String password;
  late final String nickname;
  late final String hantokNum;
  late final String avatar;
  late final int sex;
  late final String birthday;
  late final String country;
  late final String province;
  late final String city;
  late final String district;
  late final String description;
  late final String bg;
  late final int canHantokNumBeUpdated;
  late final String createdTime;
  late final String updatedTime;
  late final Null userToken;
  late final int myFollowsCounts;
  late final int myFansCounts;
  late final int totalLikeMeCounts;

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    mobile = json['mobile'];
    password = json['password'];
    nickname = json['nickname'];
    hantokNum = json['hantokNum'];
    avatar = json['avatar'];
    sex = json['sex'];
    birthday = json['birthday'];
    country = json['country'];
    province = json['province'];
    city = json['city'];
    district = json['district'];
    description = json['description'];
    bg = json['bg'];
    canHantokNumBeUpdated = json['canHantokNumBeUpdated'];
    createdTime = json['createdTime'];
    updatedTime = json['updatedTime'];
    userToken = json['userToken'];
    myFollowsCounts = json['myFollowsCounts'];
    myFansCounts = json['myFansCounts'];
    totalLikeMeCounts = json['totalLikeMeCounts'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['mobile'] = mobile;
    _data['password'] = password;
    _data['nickname'] = nickname;
    _data['hantokNum'] = hantokNum;
    _data['avatar'] = avatar;
    _data['sex'] = sex;
    _data['birthday'] = birthday;
    _data['country'] = country;
    _data['province'] = province;
    _data['city'] = city;
    _data['district'] = district;
    _data['description'] = description;
    _data['bg'] = bg;
    _data['canHantokNumBeUpdated'] = canHantokNumBeUpdated;
    _data['createdTime'] = createdTime;
    _data['updatedTime'] = updatedTime;
    _data['userToken'] = userToken;
    _data['myFollowsCounts'] = myFollowsCounts;
    _data['myFansCounts'] = myFansCounts;
    _data['totalLikeMeCounts'] = totalLikeMeCounts;
    return _data;
  }
}
