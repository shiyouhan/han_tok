// ignore_for_file: avoid_print, prefer_const_constructors, depend_on_referenced_packages

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:get/get.dart';

import '../../../../../main.dart';
import '../../../../data/base_style.dart';
import '../../../login/controllers/login_bottom_controller.dart';
import '../../controllers/info_num_controller.dart';

class InfoNumView extends StatefulWidget {
  const InfoNumView({Key? key}) : super(key: key);

  @override
  State<InfoNumView> createState() => _InfoNumViewState();
}

class _InfoNumViewState extends State<InfoNumView> {
  TextEditingController numController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    LoginBottomController loginController = Get.put(LoginBottomController());
    InfoNumController controller = Get.put(InfoNumController());

    num number = numController.value.text.length;

    void numStr(value) => {
          loginController.hantokNum.value = value,
          if (numController.text.isNotEmpty)
            {
              controller.isChange.value = true,
            }
          else
            controller.isChange.value = false,
        };
    void textClean() => {
          numController.clear(),
          controller.isChange.value = false,
          setState(() {
            number = 0;
          }),
        };

    //TODO:修改HanTok号
    modifyNum() async {
      var prefs = await SharedPreferences.getInstance();
      String token = prefs.getString('userToken')!;
      String id = prefs.getString('id')!;

      Map<String, dynamic> headers = {
        "headerUserId": id,
        "headerUserToken": token,
      };
      Map<String, dynamic> data = {
        "id": id,
        "hantokNum": numController.text,
      };
      request
          .post('/userInfo/modifyUserInfo?type=3', headers: headers, data: data)
          .then((value) {
        print(value);
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
            '修改HanTok号',
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
                        modifyNum(),
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
                  '修改HanTok号',
                  style: BaseStyle.fs14G.copyWith(fontWeight: FontWeight.bold),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextFormField(
                    cursorColor: Colors.red,
                    decoration: InputDecoration(
                      hintText: loginController.hantokNum.value,
                      suffixIcon: IconButton(
                        icon: Icon(
                          Icons.cancel,
                          color: Colors.grey.shade300,
                        ),
                        onPressed: () => textClean(),
                      ),
                    ),
                    controller: numController,
                    onChanged: (value) {
                      numStr(value);
                      setState(() {
                        number = value.toString().length;
                      });
                      print(number);
                      print(controller.isChange.value);
                    },
                  ),
                  SizedBox(height: 6.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          '最多12个字，只允许包含字母、数字、下划线和点，只能修改一次',
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
              )
            ],
          ),
        ));
  }
}
