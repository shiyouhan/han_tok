// ignore_for_file: depend_on_referenced_packages, prefer_const_constructors, avoid_print, unnecessary_overrides

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:get/get.dart';

import '../../../../main.dart';
import '../../../utils/BirthUtil.dart';
import '../../home/views/home_view.dart';
import '../model/Login.dart';
import '../model/User.dart';

class LoginBottomController extends GetxController {
  Future<SharedPreferences> prefs = SharedPreferences.getInstance();
  var phoneController = TextEditingController().obs;
  var codeController = TextEditingController().obs;

  var isSelected = false.obs;
  var isShowed = false.obs;
  final mobile = '18018384983'.obs;
  final code = ''.obs;
  final location = ''.obs;
  final time = ''.obs;
  final minute = 0.obs;
  final minute1 = ''.obs;
  final loginWay = 0.obs;
  String userId = '';
  String token = '';
  var year = 2000.obs;
  var month = 12.obs;
  var day = 12.obs;
  var age = ''.obs;

  final id = ''.obs;
  final userToken = ''.obs;
  final password = ''.obs;
  final nickname = '请先登录'.obs;
  final hantokNum = 'XXXXXX'.obs;
  final avatar = 'http://img.syhan.top/uPic/nonothing.jpg'.obs;
  final sex = 3.obs;
  final birthday = ''.obs;
  final country = ''.obs;
  final province = ''.obs;
  final city = ''.obs;
  final district = ''.obs;
  final description = '这家伙很懒，什么都没留下~'.obs;
  final canHantokNumBeUpdated = 1.obs;
  final bg = 'http://img.syhan.top/uPic/youhua.jpeg'.obs;

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  void radioSelect(value) => isSelected.value = true;
  void openCode(value) => isShowed.value = true;
  void closeCode(value) => isShowed.value = true;
  void phoneNumber(value) => mobile.value = value;
  void codeNumber(value) => code.value = value;

  //todo:发送验证码
  getVerify() async {
    if (phoneController.value.text.isNotEmpty) {
      await request
          .post('/passport/getSMSCode?mobile=${phoneController.value.text}')
          .then((value) {
        print(value);
      }).catchError((error) {
        EasyLoading.showError('数据解析异常');
        print(error);
      });
    }
  }

  //todo:登录
  login() async {
    Map<String, dynamic> data = {
      "mobile": phoneController.value.text,
      "smsCode": codeController.value.text
    };
    request.post('/passport/login', data: data).then((value) async {
      id.value = Login.fromJson(value).id;
      userToken.value = Login.fromJson(value).userToken;
      var prefs = await SharedPreferences.getInstance();
      prefs.setString('userToken', Login.fromJson(value).userToken);
      prefs.setString('id', Login.fromJson(value).id);
      print(value);
      DateTime dateTime = DateTime.now();
      minute.value = dateTime.minute;
      if (minute.value >= 0 && minute.value < 10) {
        minute1.value = '0${minute.value}';
        time.value =
            '${dateTime.year}.${dateTime.month}.${dateTime.day} ${dateTime.hour}:${minute1.value}:${dateTime.second}';
      } else {
        time.value =
            '${dateTime.year}.${dateTime.month}.${dateTime.day} ${dateTime.hour}:${dateTime.minute}:${dateTime.second}';
      }
      print(time.value);
      loginWay.value = 1;
      print(loginWay.value);
      query();
      Get.to(() => HomeView());
    }).catchError((error) {
      EasyLoading.showError('数据解析异常');
      print(error);
    });
  }

  //todo:获取用户信息
  query() async {
    var prefs = await SharedPreferences.getInstance();
    String id = prefs.getString('id')!;

    request.get('/userInfo/query?userId=$id').then((value) async {
      mobile.value = User.fromJson(value).mobile;
      nickname.value = User.fromJson(value).nickname;
      password.value = User.fromJson(value).password;
      hantokNum.value = User.fromJson(value).hantokNum;
      avatar.value = User.fromJson(value).avatar;
      sex.value = User.fromJson(value).sex;
      birthday.value = User.fromJson(value).birthday;
      country.value = User.fromJson(value).country;
      province.value = User.fromJson(value).province;
      city.value = User.fromJson(value).city;
      district.value = User.fromJson(value).district;
      description.value = User.fromJson(value).description;
      bg.value = User.fromJson(value).bg;
      location.value =
          '${country.value}-${province.value}-${city.value}-${district.value}';
      year.value = int.parse(birthday.value.substring(0, 4));
      month.value = int.parse(birthday.value.substring(6, 7));
      day.value = int.parse(birthday.value.substring(9, 10));
      late DateTime brt = DateTime(year.value, month.value, day.value);
      age.value = BirthUtil.getAge(brt);
      print(value);
    }).catchError((error) {
      EasyLoading.showError('数据解析异常');
      print(error);
    });
  }
}