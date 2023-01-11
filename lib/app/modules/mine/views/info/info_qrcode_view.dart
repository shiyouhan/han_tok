// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../../../../data/base_style.dart';
import '../../../login/controllers/login_bottom_controller.dart';

class InfoQrcodeView extends GetView {
  const InfoQrcodeView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    LoginBottomController loginController = Get.put(LoginBottomController());
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '换样式',
          style: BaseStyle.fs18,
        ),
        elevation: 0,
        centerTitle: true,
      ),
      body: Center(
        child: Container(
          padding: EdgeInsets.all(15),
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(16.0))),
          child: QrImage(
            backgroundColor: Colors.grey.withOpacity(0.2),
            foregroundColor: Colors.grey,
            data: loginController.hantokNum.value,
            gapless: false,
            size: size.width * 0.7,
            embeddedImage: NetworkImage(loginController.avatar.value),
            embeddedImageStyle: QrEmbeddedImageStyle(size: Size(50.w, 50.w)),
          ),
        ),
      ),
    );
  }
}
