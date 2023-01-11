// ignore_for_file: prefer_const_constructors, use_build_context_synchronously, avoid_print

import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';
import 'package:images_picker/images_picker.dart';

import '../../../login/controllers/login_bottom_controller.dart';

class InfoAvatarView extends GetView {
  const InfoAvatarView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    LoginBottomController loginController = Get.put(LoginBottomController());

    Future<File> downloadFile(String url) async {
      Dio simple = Dio();
      String savePath = '${Directory.systemTemp.path}/${url.split('/').last}';
      await simple.download(url, savePath,
          options: Options(responseType: ResponseType.bytes));
      print(savePath);
      File file = File(savePath);
      return file;
    }

    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: GestureDetector(
        onTap: () => Get.back(),
        child: Container(
            color: Colors.black,
            child: Stack(
              children: [
                Center(
                  child: SizedBox(
                    width: size.width,
                    height: size.width,
                    child: Obx(
                      () => Image.network(
                        loginController.avatar.value,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 40,
                  right: 20,
                  child: GestureDetector(
                    onTap: () async {
                      File file =
                          await downloadFile(loginController.avatar.value);
                      bool res = await ImagesPicker.saveImageToAlbum(file,
                          albumName: "chaves");
                      print(res);
                      Navigator.of(context).pop();
                    },
                    child: Container(
                      width: 28.w,
                      height: 28.h,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4.r),
                        color: Colors.grey.withOpacity(0.2),
                      ),
                      child: Icon(
                        Icons.vertical_align_bottom,
                        size: 28,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            )),
      ),
    );
  }
}
