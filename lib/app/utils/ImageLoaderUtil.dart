// ignore_for_file: avoid_print

import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'dart:ui';

import 'package:crypto/crypto.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';

/// 图片加载工具类
class ImageLoaderUtil {

  //私有化构造
  ImageLoaderUtil._();

  //单例模式创建
  static final ImageLoaderUtil imageLoader = ImageLoaderUtil._();

  // 将一个Widget转为image.Image对象
  Future<ui.Image> getImageFromWidget(GlobalKey globalKey) async {
    // globalKey为需要图像化的widget的key
    RenderRepaintBoundary? boundary =
    globalKey.currentContext?.findRenderObject() as RenderRepaintBoundary?;
    // 转换为图像
    ui.Image img = await boundary!.toImage();
    return img;
  }

  ///将指定的文件保存到目录空间中。
  ///[image] 这里是使用的ui包下的Image
  ///[picName] 保存到本地的文件（图片）文件名，如test_image
  ///[endFormat]保存到本地的文件（图片）文件格式，如png，
  ///[isReplace]当本地存在同名的文件（图片）时，true就是替换
  ///[isEncode]对保存的文件（图片）进行编码
  ///  最终保存到本地的文件 （图片）的名称为 picName.endFormat
  Future<String> saveImageByUIImage(ui.Image image,
      {String? picName,
        String endFormat = "png",
        bool isReplace = true,
        bool isEncode = true}) async {
    ///获取本地磁盘路径
    /*
     * 在Android平台中获取的是/data/user/0/com.studyyoun.flutterbookcode/app_flutter
     * 此方法在在iOS平台获取的是Documents路径
     */
    Directory appDocDir = await getApplicationDocumentsDirectory();
    String appDocPath = appDocDir.path;

    ///拼接目录
    if (picName == null || picName.trim().isEmpty) {
      ///当用户没有指定picName时，取当前的时间命名
      picName = "${DateTime.now().millisecond.toString()}.$endFormat";
    } else {
      picName = "$picName.$endFormat";
    }

    if (isEncode) {
      ///对保存的图片名字加密
      picName = md5.convert(utf8.encode(picName)).toString();
    }

    appDocPath = "$appDocPath/$picName";

    ///校验图片是否存在
    var file = File(appDocPath);
    bool exist = await file.exists();
    if (exist) {
      if (isReplace) {
        ///如果图片存在就进行删除替换
        ///如果新的图片加载失败，那么旧的图片也被删除了
        await file.delete();
      } else {
        ///如果图片存在就不进行下载
        return "";
      }
    }
    ByteData? byteData = await image.toByteData(format: ImageByteFormat.png);
    Uint8List pngBytes = byteData!.buffer.asUint8List();
    print("保存的图片路径 $appDocPath");

    ///将Uint8List的数据格式保存
    await File(appDocPath).writeAsBytes(pngBytes);

    return appDocPath;
  }
}