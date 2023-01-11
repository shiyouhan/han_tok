// ignore_for_file: avoid_print, prefer_const_constructors, depend_on_referenced_packages

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:get/get.dart';

import '../../../../../main.dart';
import '../../../../data/base_style.dart';
import '../../../login/controllers/login_bottom_controller.dart';
import '../../controllers/info_nickname_controller.dart';

class InfoNicknameView extends StatefulWidget {
  const InfoNicknameView({Key? key}) : super(key: key);

  @override
  State<InfoNicknameView> createState() => _InfoNicknameViewState();
}

class _InfoNicknameViewState extends State<InfoNicknameView> {
  TextEditingController nicknameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    LoginBottomController loginController = Get.put(LoginBottomController());
    InfoNicknameController controller = Get.put(InfoNicknameController());
    num number = nicknameController.text.length;

    void nicknameStr(value) => {
          loginController.nickname.value = value,
          if (nicknameController.text.isNotEmpty)
            {
              controller.isChange.value = true,
            }
          else
            controller.isChange.value = false,
        };
    void textClean() => {
          nicknameController.clear(),
          controller.isChange.value = false,
          setState(() {
            number = 0;
          }),
        };

    // 修改昵称
    modifyNickname() async {
      var prefs = await SharedPreferences.getInstance();
      String token = prefs.getString('userToken')!;
      String id = prefs.getString('id')!;

      Map<String, dynamic> headers = {
        "headerUserId": id,
        "headerUserToken": token,
      };
      Map<String, dynamic> data = {
        "id": id,
        "nickname": nicknameController.text,
      };
      request
          .post('/userInfo/modifyUserInfo?type=2', headers: headers, data: data)
          .then((value) {
        print(value);
        loginController.query();
        Get.back();
        EasyLoading.showToast('设置成功');
      }).catchError((error) {
        EasyLoading.showError('数据解析异常');
        print(error);
      });
    }

    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        title: Text(
          '修改名字',
          style: BaseStyle.fs18,
        ),
        centerTitle: true,
        actions: [
          Center(
            child: Padding(
              padding: EdgeInsets.only(right: 16.w),
              child: GestureDetector(
                onTap: () => {
                  if (number <= 12 && number >= 0)
                    {
                      modifyNickname(),
                    }
                  else
                    {
                      EasyLoading.showToast('输入不符合要求!'),
                    }
                },
                child: Obx(
                  () => Text(
                    '保存',
                    style: BaseStyle.fs16.copyWith(
                      color: controller.isChange.value == false
                          ? Color(0XF8FA9FB7)
                          : Colors.red,
                    ),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(vertical: 16.w),
              child: Text(
                '我的名字',
                style: BaseStyle.fs14G.copyWith(fontWeight: FontWeight.bold),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  cursorColor: Colors.red,
                  decoration: InputDecoration(
                    hintText: loginController.nickname.value,
                    suffixIcon: IconButton(
                      icon: Icon(
                        Icons.cancel,
                        color: Colors.grey.shade300,
                      ),
                      onPressed: () => textClean(),
                    ),
                  ),
                  controller: nicknameController,
                  onChanged: (value) {
                    nicknameStr(value);
                    print(value);
                    setState(() {
                      number = value.toString().length;
                    });
                  },
                ),
                SizedBox(height: 6.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        '名字最多12位',
                        style: BaseStyle.fs12G,
                      ),
                    ),
                    Text(
                      '$number/12',
                      style: number > 12
                          ? BaseStyle.fs12G.copyWith(color: Colors.red)
                          : BaseStyle.fs12G,
                    ),
                  ],
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
