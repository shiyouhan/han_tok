// ignore_for_file: unnecessary_overrides, avoid_print

import 'package:get/get.dart';
import 'package:device_info_plus/device_info_plus.dart';

class AccountDeviceController extends GetxController {
  final deviceName = ''.obs;

  @override
  void onInit() {
    getDeviceInfo();
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

  void getDeviceInfo() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();

    // 安卓系统
    // AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
    // print('设备唯一标识: ${androidInfo.device}');
    // 更多信息请查看 AndroidDeviceInfo 类中的定义

    // 苹果系统
    IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
    deviceName.value = iosInfo.name.toString();
    print('设备唯一标识：${iosInfo.name}');
    // 更多信息请查看 IosDeviceInfo 类中的定义
  }
}
