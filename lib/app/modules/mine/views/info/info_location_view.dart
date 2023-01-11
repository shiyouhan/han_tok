// ignore_for_file: prefer_const_constructors, avoid_print, library_prefixes

import 'dart:io';

import 'package:city_pickers/meta/province.dart';
import 'package:flutter/material.dart';
import 'package:city_pickers/city_pickers.dart';
import 'package:flutter_baidu_mapapi_base/flutter_baidu_mapapi_base.dart';
import 'package:flutter_bmflocation/flutter_bmflocation.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../../data/base_style.dart' as ST;
import '../../../../data/theme_data.dart';
import '../../../login/controllers/login_bottom_controller.dart';
import '../../controllers/info_location_controller.dart';

class InfoLocationView extends StatefulWidget {
  const InfoLocationView({Key? key}) : super(key: key);

  @override
  State<InfoLocationView> createState() => _InfoLocationViewState();
}

class _InfoLocationViewState extends State<InfoLocationView> {
  InfoLocationController controller = Get.put(InfoLocationController());
  LoginBottomController loginController = Get.put(LoginBottomController());
  final LocationFlutterPlugin _myLocPlugin = LocationFlutterPlugin();

  Map result = {};

  String province1 = '省';
  String city1 = '市';
  String area = '';

  String country = '中国';
  String province = '';
  String city = '';
  String district = '';

  @override
  void initState() {
    super.initState();
    _myLocPlugin.startLocation();
    requestPermission();

    /// 设置用户是否同意SDK隐私协议
    /// since 3.1.0 开发者必须设置
    BMFMapSDK.setAgreePrivacy(true);
    _myLocPlugin.setAgreePrivacy(true);

    // 百度地图sdk初始化鉴权
    if (Platform.isIOS) {
      _myLocPlugin.authAK('YGyNATp3fEQM5bSNczzrGiaqSPOAm9QT');
      BMFMapSDK.setApiKeyAndCoordType(
          'YGyNATp3fEQM5bSNczzrGiaqSPOAm9QT', BMF_COORD_TYPE.BD09LL);
    } else if (Platform.isAndroid) {
      // Android 目前不支持接口设置Apikey,
      // 请在主工程的Manifest文件里设置，详细配置方法请参考官网(https://lbsyun.baidu.com/)demo
      BMFMapSDK.setCoordType(BMF_COORD_TYPE.BD09LL);
    }

    locationAction();

    ///接受定位回调
    _myLocPlugin.seriesLocationCallback(callback: (BaiduLocation result) {
      if (mounted) {
        setState(() {
          controller.country.value = result.country!;
          controller.province.value = result.province!;
          controller.city.value = result.city!;
          controller.district.value = result.district!;
          province1 = result.province!;
          city1 = result.city!;
          // this.result = result.getMap();
        });
      }
    });
  }

  void locationAction() async {
    /// 设置android端和ios端定位参数
    /// android 端设置定位参数
    /// ios 端设置定位参数
    Map iosMap = _initIOSOptions().getMap();
    Map androidMap = _initAndroidOptions().getMap();

    await _myLocPlugin.prepareLoc(androidMap, iosMap);
  }

  // 动态申请定位权限
  void requestPermission() async {
    // 申请权限
    bool hasLocationPermission = await requestLocationPermission();
    if (hasLocationPermission) {
      // 权限申请通过
    } else {}
  }

  /// 申请定位权限
  /// 授予定位权限返回true， 否则返回false
  Future<bool> requestLocationPermission() async {
    //获取当前的权限
    var status = await Permission.location.status;
    if (status == PermissionStatus.granted) {
      //已经授权
      return true;
    } else {
      //未授权则发起一次申请
      status = await Permission.location.request();
      if (status == PermissionStatus.granted) {
        return true;
      } else {
        return false;
      }
    }
  }

  /// 设置地图参数
  BaiduLocationAndroidOption _initAndroidOptions() {
    BaiduLocationAndroidOption options = BaiduLocationAndroidOption(
        locationMode: BMFLocationMode.hightAccuracy,
        isNeedAddress: true,
        isNeedAltitude: true,
        isNeedLocationPoiList: true,
        isNeedNewVersionRgc: true,
        isNeedLocationDescribe: true,
        openGps: true,
        scanspan: 4000, //这里如果设置为 0 就是单次定位
        coordType: BMFLocationCoordType.bd09ll);
    return options;
  }

  BaiduLocationIOSOption _initIOSOptions() {
    BaiduLocationIOSOption options = BaiduLocationIOSOption(
        coordType: BMFLocationCoordType.bd09ll,
        desiredAccuracy: BMFDesiredAccuracy.best,
        allowsBackgroundLocationUpdates: true,
        pausesLocationUpdatesAutomatically: false);
    return options;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        title: Text(
          '选择地区',
          style: ST.BaseStyle.fs16.copyWith(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        leading: GestureDetector(
          onTap: () => {
            if (controller.isChange.value == false && province != '')
              {
                EasyLoading.showToast('请先提交您的选择！'),
              }
            else
              {
                Get.back(),
              }
          },
          child: Icon(Icons.arrow_back_ios),
        ),
        actions: [
          Center(
            child: Padding(
              padding: EdgeInsets.only(right: 16.w),
              child: GestureDetector(
                onTap: () => controller.modifyLoc(),
                child: Text(
                  '保存',
                  style: ST.BaseStyle.fs16.copyWith(
                    color: province == '' ? Color(0XF8FA9FB7) : Colors.red,
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
                padding: EdgeInsets.only(top: 50.w, bottom: 25.w),
                child: GestureDetector(
                  onTap: () => controller.cleanLocation(),
                  child: Text(
                    '暂不设置',
                    style: ST.BaseStyle.fs16,
                  ),
                )),
            Container(
              height: 1,
              color: Config.primarySwatchColor.shade50,
            ),
            Padding(
              padding: EdgeInsets.only(top: 20.w, bottom: 26.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.location_on,
                        size: 16,
                        color: Colors.grey,
                      ),
                      SizedBox(width: 4.w),
                      Text(
                        '当前位置',
                        style: ST.BaseStyle.fs12G,
                      ),
                    ],
                  ),
                  SizedBox(height: 16.h),
                  GestureDetector(
                    onTap: () => controller.nowLocation(),
                    child: Text(
                      '${province1.substring(0, province1.lastIndexOf('省'))} · ${city1.substring(0, city1.lastIndexOf('市'))}',
                      style: ST.BaseStyle.fs14,
                    ),
                  )
                ],
              ),
            ),
            Container(
              height: 1,
              color: Config.primarySwatchColor.shade50,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  child: Text(
                    '其他地区',
                    style: ST.BaseStyle.fs12G,
                  ),
                ),
                ListTile(
                  onTap: () async {
                    Result? result = await CityPickers.showCityPicker(
                      context: context,
                      height: 300,
                      itemExtent: 50,
                      barrierDismissible: true,
                      barrierOpacity: 0.1,
                      // 用户自定义取消按钮
                      cancelWidget: GestureDetector(
                        onTap: () => {
                          country = '',
                          province = '',
                          city = '',
                          district = '',
                          Get.back(),
                        },
                        child: Text(
                          "取消",
                          style: ST.BaseStyle.fs16,
                        ),
                      ),
                      // 用户自定义确认按钮
                      confirmWidget: Text(
                        "确定",
                        style: ST.BaseStyle.fs16.copyWith(color: Colors.red),
                      ),
                      citiesData: citiesData,
                    );
                    // print("${result?.provinceName}-${result?.cityName}-${result?.areaName}");
                    province = result!.provinceName.toString();
                    city = result.cityName.toString();
                    district = result.areaName.toString();
                    loginController.province.value =
                        result.provinceName.toString();
                    loginController.city.value = result.cityName.toString();
                    loginController.district.value = result.areaName.toString();
                    print('$province-$city-$district');
                    setState(() {
                      area =
                          "${result.provinceName}-${result.cityName}-${result.areaName}";
                    });
                  },
                  title: Text('中国', style: ST.BaseStyle.fs14),
                  trailing: Icon(
                    Icons.arrow_forward_ios,
                    size: 16,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 10),
                  child: Text(
                    '注：选择其他地区地址请点击右上角完成提交',
                    style: ST.BaseStyle.fs12G,
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
