// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BaseStyle {
  /// 字号
  static TextStyle fs10 = TextStyle(fontSize: 10.sp, color: Colors.black);
  static TextStyle fs12 = TextStyle(fontSize: 12.sp, color: Colors.black);
  static TextStyle fs12G = TextStyle(fontSize: 12.sp, color: Colors.grey);
  static TextStyle fs14 = TextStyle(fontSize: 14.sp, color: Colors.black);
  static TextStyle fs14G = TextStyle(fontSize: 14.sp, color: Colors.grey);
  static TextStyle fs16 = TextStyle(fontSize: 16.sp, color: Colors.black);
  static TextStyle fs16W = TextStyle(fontSize: 16.sp, color: Colors.white);
  static TextStyle fs18 = TextStyle(fontSize: 18.sp, color: Colors.black);
  static TextStyle fs18Wb = TextStyle(
      fontSize: 18.sp, fontWeight: FontWeight.bold, color: Colors.white);
  static TextStyle fs20 = TextStyle(fontSize: 20.sp, color: Colors.black);
  static TextStyle fs20W = TextStyle(fontSize: 20.sp, color: Colors.white);

  /// 样式
  static TextStyle wdStyle = TextStyle(color: Colors.pink, fontSize: 30.sp);

//  正文字体
  static TextStyle testFont = TextStyle(color: Colors.grey);
  static TextStyle testFontBold =
      TextStyle(color: Colors.grey, fontWeight: FontWeight.bold, fontSize: 18);
}
