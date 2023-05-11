import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:han_tok/app/data/base_style.dart';
import 'package:han_tok/app/modules/mine/controllers/privacy_policy_controller.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PrivacyPolicyView extends GetView {
  const PrivacyPolicyView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    PrivacyPolicyController controller = Get.put(PrivacyPolicyController());
    return Scaffold(
      appBar: AppBar(
        title: Text('隐私政策简明版',style: BaseStyle.fs16,),
        elevation: 0,
        centerTitle: true,
      ),
      body: WebViewWidget(
        controller: controller.webController,
      )
    );
  }
}
