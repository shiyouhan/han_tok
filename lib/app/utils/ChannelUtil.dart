// ignore_for_file: prefer_const_constructors, file_names

import 'package:flutter/services.dart';

class ChannelUtil {
  static final MethodChannel _methodChannel = MethodChannel('CommonChannel');

  static closeCamera() {
    _methodChannel.invokeMethod("closeCamera");
  }
}
