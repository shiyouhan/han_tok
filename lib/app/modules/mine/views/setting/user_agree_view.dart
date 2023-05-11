import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:han_tok/app/modules/mine/controllers/user_agree_controller.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../../../data/base_style.dart';

class UserAgreeView extends GetView {
  const UserAgreeView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    UserAgreeController controller = Get.put(UserAgreeController());
    return Scaffold(
        appBar: AppBar(
          title: Text('用户协议',style: BaseStyle.fs16,),
          elevation: 0,
          centerTitle: true,
        ),
        body: WebViewWidget(
          controller: controller.webController,
        )
    );
  }
}
