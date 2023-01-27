// ignore_for_file: avoid_print, prefer_const_constructors, prefer_const_literals_to_create_immutables, use_build_context_synchronously, library_prefixes, depend_on_referenced_packages

import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:dio/dio.dart' as DIO;
import 'package:dio/dio.dart';
import 'package:flutter/services.dart';
import 'package:flutter_baidu_mapapi_base/flutter_baidu_mapapi_base.dart';
import 'package:flutter_bmflocation/flutter_bmflocation.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:han_tok/app/modules/mine/controllers/mine_count_controller.dart';
import 'package:han_tok/app/modules/mine/controllers/mine_fan_controller.dart';
import 'package:han_tok/app/modules/mine/controllers/mine_follow_controller.dart';
import 'package:images_picker/images_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../main.dart';
import '../../../data/base_style.dart';
import '../../../data/theme_data.dart';
import '../../../utils/Iconfont.dart';
import '../../login/controllers/login_bottom_controller.dart';
import '../controllers/composition_controller.dart';
import '../controllers/mine_controller.dart';
import 'count/mine_count_view.dart';
import 'info/info_desc_view.dart';
import 'info/mine_info_view.dart';
import 'setting/setting_view.dart';
import 'top/search_view.dart';
import 'top/visit_view.dart';
import 'video/collect_view.dart';
import 'video/composition_view.dart';
import 'video/like_view.dart';
import 'video/private_view.dart';

class MineView extends GetView<MineController> {
  const MineView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: VideoTabBar(),
    );
  }
}

class VideoTabBar extends StatefulWidget {
  const VideoTabBar({Key? key}) : super(key: key);

  @override
  State<VideoTabBar> createState() => _VideoTabBarState();
}

class _VideoTabBarState extends State<VideoTabBar>
    with SingleTickerProviderStateMixin {
  final LocationFlutterPlugin _myLocPlugin = LocationFlutterPlugin();
  LoginBottomController loginController = Get.put(LoginBottomController());
  MineController controller = Get.put(MineController());
  MineCountController countController = Get.put(MineCountController());
  MineFollowController followController = Get.put(MineFollowController());
  MineFanController fanController = Get.put(MineFanController());
  CompositionController compositionController =
      Get.put(CompositionController());
  late TabController _tabController;
  String? path;
  late ScrollController _scrollController;
  var kExpandedHeight = 400;
  String city = '';

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()..addListener(() => setState(() {}));
    _tabController = TabController(length: 4, vsync: this);
    // _myLocPlugin.startLocation();
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
          // country = result.country!;
          // province = result.province!;
          city = result.city!;
          controller.city.value = result.city!;
          // print(result.city!);
          // district = result.district!;
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

  bool get _showTitle {
    return _scrollController.hasClients &&
        _scrollController.offset > kExpandedHeight - kToolbarHeight;
  }

  // 上传背景图
  uploadBg(List<Media>? res) async {
    if (res != null) {
      String? path = res[0].path;
      print(path);

      var formData = DIO.FormData.fromMap(
          {'file': await DIO.MultipartFile.fromFile(path)});
      var prefs = await SharedPreferences.getInstance();
      String token = prefs.getString('userToken')!;
      String id = prefs.getString('id')!;
      Map<String, dynamic> headers = {
        "headerUserId": id,
        "headerUserToken": token,
      };
      request
          .post('/userInfo/upload?userId=$id&type=1',
              headers: headers, data: formData)
          .then((value) {
        // print(value);
        loginController.query();
      }).catchError((_) {
        EasyLoading.showError('数据解析异常');
      });
    }
  }

  // 上传头像
  uploadAvatar(List<Media>? res) async {
    if (res != null) {
      String? path = res[0].path;
      print(path);

      var formData = DIO.FormData.fromMap(
          {'file': await DIO.MultipartFile.fromFile(path)});
      var prefs = await SharedPreferences.getInstance();
      String token = prefs.getString('userToken')!;
      String id = prefs.getString('id')!;
      Map<String, dynamic> headers = {
        "headerUserId": id,
        "headerUserToken": token,
      };
      request
          .post('/userInfo/upload?userId=$id&type=2',
              headers: headers, data: formData)
          .then((value) {
        // print(value);
        loginController.query();
      }).catchError((_) {
        EasyLoading.showError('数据解析异常');
      });
    }
  }

  Future<File> downloadFile(String url) async {
    Dio simple = Dio();
    String savePath = '${Directory.systemTemp.path}/${url.split('/').last}';
    await simple.download(url, savePath,
        options: Options(responseType: ResponseType.bytes));
    print(savePath);
    File file = File(savePath);
    return file;
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final paddingTop = MediaQueryData.fromWindow(window).padding.top;
    LoginBottomController loginController = Get.put(LoginBottomController());

    return NestedScrollView(
      controller: _scrollController,
      physics:
          const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
      headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
        return <Widget>[
          SliverAppBar(
            pinned: true,
            // stretch: true,
            floating: false,
            // snap: true,
            expandedHeight: size.height / 2,
            backgroundColor: Colors.white,
            elevation: 1,
            forceElevated: true,
            title: _showTitle
                ? Obx(
                    () => Text(
                      loginController.nickname.value,
                      style:
                          BaseStyle.fs16.copyWith(fontWeight: FontWeight.bold),
                    ),
                  )
                : Text(''),
            centerTitle: true,
            leading: Container(),
            actions: [
              GestureDetector(
                onTap: () => Get.to(() => VisitView()),
                child: _showTitle
                    ? Icon(
                        Icons.person,
                        color: Colors.black,
                      )
                    : CircleAvatar(
                        radius: 16.r,
                        backgroundColor: Colors.grey.withOpacity(0.5),
                        child: Icon(
                          Icons.person,
                          color: Colors.white,
                        ),
                      ),
              ),
              SizedBox(width: 12.w),
              GestureDetector(
                onTap: () => Get.to(() => SearchView()),
                child: _showTitle
                    ? Icon(
                        Icons.search,
                        color: Colors.black,
                      )
                    : CircleAvatar(
                        radius: 16.r,
                        backgroundColor: Colors.grey.withOpacity(0.5),
                        child: Icon(
                          Icons.search,
                          color: Colors.white,
                        ),
                      ),
              ),
              SizedBox(width: 12.w),
              GestureDetector(
                onTap: () => Get.to(() => SettingView()),
                child: _showTitle
                    ? Icon(
                        Icons.settings,
                        color: Colors.black,
                      )
                    : CircleAvatar(
                        radius: 16.r,
                        backgroundColor: Colors.grey.withOpacity(0.5),
                        child: Icon(
                          Icons.settings,
                          color: Colors.white,
                        ),
                      ),
              ),
              SizedBox(width: 15.w),
            ],
            flexibleSpace: FlexibleSpaceBar(
              collapseMode: CollapseMode.pin,
              background: Stack(
                children: [
                  Positioned(
                    child: Column(
                      children: [
                        GestureDetector(
                          onTap: () => showModalBottomSheet(
                            isScrollControlled: true,
                            context: context,
                            builder: (BuildContext context) {
                              return Container(
                                color: Colors.black,
                                child: SizedBox(
                                  height: size.height,
                                  child: Stack(
                                    children: [
                                      Positioned(
                                          top: paddingTop + 10.h,
                                          left: 16.w,
                                          child: GestureDetector(
                                            onTap: () => Get.back(),
                                            child: Icon(
                                              Icons.clear,
                                              size: 28,
                                              color: Colors.white,
                                            ),
                                          )),
                                      Obx(
                                        () => Center(
                                          child: SizedBox(
                                            width: size.width,
                                            child: Image.network(
                                              loginController.bg.value,
                                              fit: BoxFit.contain,
                                            ),
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                        bottom: 60,
                                        child: Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 16.w),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              GestureDetector(
                                                onTap: () async {
                                                  List<Media>? res =
                                                      await ImagesPicker.pick(
                                                    count: 1,
                                                    pickType: PickType.all,
                                                    language: Language.System,
                                                    maxTime: 30,
                                                    // maxSize: 500,
                                                    cropOpt: CropOption(
                                                      // aspectRatio: CropAspectRatio.wh16x9,
                                                      cropType: CropType.circle,
                                                    ),
                                                  );
                                                  print(res);
                                                  if (res != null) {
                                                    print(res
                                                        .map((e) => e.path)
                                                        .toList());
                                                    setState(() {
                                                      path = res[0].thumbPath!;
                                                    });
                                                  }
                                                  uploadBg(res);
                                                  Navigator.of(context).pop();
                                                },
                                                child: Container(
                                                  width: (size.width - 42) / 2,
                                                  alignment: Alignment.center,
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            2.r),
                                                    color: Colors.grey
                                                        .withOpacity(0.2),
                                                  ),
                                                  padding: EdgeInsets.symmetric(
                                                      vertical: 15),
                                                  child: Text(
                                                    '更换背景',
                                                    style: BaseStyle.fs16W,
                                                  ),
                                                ),
                                              ),
                                              SizedBox(width: 10.w),
                                              GestureDetector(
                                                onTap: () async {
                                                  File file =
                                                      await downloadFile(
                                                          loginController
                                                              .bg.value);
                                                  bool res = await ImagesPicker
                                                      .saveImageToAlbum(file,
                                                          albumName: "chaves");
                                                  print(res);
                                                  Navigator.of(context).pop();
                                                  EasyLoading.showToast('下载成功');
                                                },
                                                child: Container(
                                                  width: (size.width - 42) / 2,
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            2.r),
                                                    color: Colors.grey
                                                        .withOpacity(0.2),
                                                  ),
                                                  padding: EdgeInsets.symmetric(
                                                      vertical: 15),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Icon(
                                                        Icons
                                                            .vertical_align_bottom,
                                                        size: 20,
                                                        color: Colors.white,
                                                      ),
                                                      SizedBox(width: 4.w),
                                                      Text(
                                                        '下载',
                                                        style: BaseStyle.fs16W,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                          child: ShaderMask(
                            shaderCallback: (Rect bounds) {
                              return LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  Colors.white.withOpacity(.9),
                                  Colors.white,
                                  Colors.black.withOpacity(.8)
                                ],
                              ).createShader(bounds);
                            },
                            child: Obx(
                              () => Image.network(
                                loginController.bg.value,
                                width: size.width,
                                height: size.height * 0.3,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(height: size.height * 0.14),
                      SizedBox(
                        width: size.width,
                        child: Row(
                          children: [
                            SizedBox(width: 14),
                            GestureDetector(
                              onTap: () => showModalBottomSheet(
                                isScrollControlled: true,
                                context: context,
                                builder: (BuildContext context) {
                                  return Container(
                                    color: Colors.black,
                                    child: SizedBox(
                                      height: size.height,
                                      child: Stack(
                                        children: [
                                          Positioned(
                                            top: paddingTop + 10.h,
                                            left: 16.w,
                                            child: GestureDetector(
                                              onTap: () => Get.back(),
                                              child: Icon(
                                                Icons.clear,
                                                size: 28,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                          Obx(
                                            () => Padding(
                                              padding: EdgeInsets.only(
                                                  top: 100 + paddingTop),
                                              child: SizedBox(
                                                width: size.width,
                                                height: size.width,
                                                child: Image.network(
                                                  loginController.avatar.value,
                                                  fit: BoxFit.fill,
                                                ),
                                              ),
                                            ),
                                          ),
                                          Positioned(
                                            bottom: 40,
                                            child: Container(
                                              width: size.width - 32.w,
                                              margin: EdgeInsets.symmetric(
                                                  horizontal: 16.w),
                                              decoration: BoxDecoration(
                                                color: Colors.grey
                                                    .withOpacity(0.2),
                                                borderRadius:
                                                    BorderRadius.circular(5.r),
                                              ),
                                              child: Column(
                                                children: [
                                                  ListTile(
                                                    onTap: () async {
                                                      List<Media>? res =
                                                          await ImagesPicker
                                                              .pick(
                                                        count: 1,
                                                        pickType: PickType.all,
                                                        language:
                                                            Language.System,
                                                        maxTime: 30,
                                                        // maxSize: 500,
                                                        cropOpt: CropOption(
                                                          // aspectRatio: CropAspectRatio.wh16x9,
                                                          cropType:
                                                              CropType.circle,
                                                        ),
                                                      );
                                                      print(res);
                                                      uploadAvatar(res);
                                                      if (res != null) {
                                                        print(res
                                                            .map((e) => e.path)
                                                            .toList());
                                                        setState(() {
                                                          path =
                                                              res[0].thumbPath!;
                                                        });
                                                      }
                                                      Navigator.of(context)
                                                          .pop();
                                                    },
                                                    title: Text(
                                                      '更换头像',
                                                      style: BaseStyle.fs16W,
                                                    ),
                                                    trailing: Icon(
                                                      IconFont.bianji,
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                  Container(
                                                      height: 1,
                                                      color: Config
                                                          .primarySwatchColor
                                                          .shade50
                                                          .withOpacity(.3)),
                                                  ListTile(
                                                    onTap: () async {
                                                      File file =
                                                          await downloadFile(
                                                              loginController
                                                                  .avatar
                                                                  .value);
                                                      bool res =
                                                          await ImagesPicker
                                                              .saveImageToAlbum(
                                                                  file,
                                                                  albumName:
                                                                      "chaves");
                                                      print(res);
                                                      Navigator.of(context)
                                                          .pop();
                                                      EasyLoading.showToast(
                                                          '下载成功');
                                                    },
                                                    title: Text(
                                                      '保存头像',
                                                      style: BaseStyle.fs16W,
                                                    ),
                                                    trailing: Icon(
                                                      Icons
                                                          .vertical_align_bottom,
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                  Container(
                                                      height: 1,
                                                      color: Config
                                                          .primarySwatchColor
                                                          .shade50
                                                          .withOpacity(.3)),
                                                  ListTile(
                                                    // onTap: () => Get.to(
                                                    //     () => InfoQrcodeView()),
                                                    title: Text(
                                                      '查看HanTok码',
                                                      style: BaseStyle.fs16W,
                                                    ),
                                                    trailing: Icon(
                                                      Icons.qr_code,
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                              child: Container(
                                width: 80.w,
                                height: 80.h,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(40.r),
                                  border: Border.all(
                                    width: 2.w,
                                    color: Colors.white,
                                  ),
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(40.r),
                                  child: Obx(
                                    () => Image.network(
                                      loginController.avatar.value,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(width: 16.w),
                            Obx(
                              () => Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    loginController.nickname.value,
                                    style: BaseStyle.fs20W
                                        .copyWith(fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(height: 2.h),
                                  Row(
                                    children: [
                                      GestureDetector(
                                        onTap: () => {
                                          Clipboard.setData(ClipboardData(
                                              text: loginController
                                                  .hantokNum.value)),
                                          EasyLoading.showToast(
                                              '已复制HanTok号：${loginController.hantokNum.value}'),
                                        },
                                        child: Text(
                                          'HanTok号：${loginController.hantokNum.value}',
                                          // '抖音号： 1755888613',
                                          style: BaseStyle.fs12
                                              .copyWith(color: Colors.white),
                                        ),
                                      ),
                                      SizedBox(width: 2.w),
                                      GestureDetector(
                                        // onTap: () =>
                                        //     Get.to(() => InfoQrcodeView()),
                                        child: Icon(
                                          Icons.qr_code,
                                          size: 12,
                                          color: Colors.white,
                                        ),
                                      )
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 16.h),
                      Container(
                        width: size.width,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(10.r),
                            topRight: Radius.circular(10.r),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 16),
                              child: Column(
                                children: [
                                  SizedBox(height: 18.h),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Obx(
                                            () => Text(
                                              controller.praised.value
                                                  .toString(),
                                              style: BaseStyle.fs16.copyWith(
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                          SizedBox(width: 5.h),
                                          Text(
                                            '获赞',
                                            style: BaseStyle.fs16,
                                          ),
                                        ],
                                      ),
                                      SizedBox(width: 18.h),
                                      InkWell(
                                        onTap: () => {
                                          countController.friend(),
                                          Get.to(() => MineCountView()),
                                        },
                                        child: Row(
                                          children: [
                                            Text(
                                              '0',
                                              style: BaseStyle.fs16.copyWith(
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            SizedBox(width: 5.h),
                                            Text(
                                              '朋友',
                                              style: BaseStyle.fs16,
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(width: 18.h),
                                      InkWell(
                                        onTap: () => {
                                          countController.follow(),
                                          Get.to(() => MineCountView()),
                                        },
                                        child: Row(
                                          children: [
                                            Obx(
                                              () => Text(
                                                controller.followList.length
                                                    .toString(),
                                                style: BaseStyle.fs16.copyWith(
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ),
                                            SizedBox(width: 5.h),
                                            Text(
                                              '关注',
                                              style: BaseStyle.fs16,
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(width: 18.h),
                                      InkWell(
                                        onTap: () => {
                                          countController.fan(),
                                          Get.to(() => MineCountView()),
                                        },
                                        child: Row(
                                          children: [
                                            Obx(
                                              () => Text(
                                                fanController.fanList.length
                                                    .toString(),
                                                style: BaseStyle.fs16.copyWith(
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ),
                                            SizedBox(width: 5.h),
                                            Text(
                                              '粉丝',
                                              style: BaseStyle.fs16,
                                            ),
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                  SizedBox(height: 12.h),
                                  Obx(
                                    () => GestureDetector(
                                      onTap: () => Get.to(() => InfoDescView()),
                                      child: loginController
                                                  .description.value ==
                                              '这家伙很懒，什么都没留下~'
                                          ? Row(
                                              children: [
                                                Text(
                                                  '点击添加介绍，让大家认识你',
                                                  style: BaseStyle.fs14,
                                                  maxLines: 3,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                                Row(
                                                  children: [
                                                    SizedBox(width: 5.w),
                                                    Icon(
                                                      Icons.border_color,
                                                      size: 12,
                                                      color: Colors.grey,
                                                    ),
                                                  ],
                                                )
                                              ],
                                            )
                                          : Row(
                                              children: [
                                                Expanded(
                                                  child: Obx(
                                                    () => Text(
                                                      // descController.desc.isNotEmpty
                                                      //     ? descController.desc.value
                                                      //     : '点击添加介绍，让大家认识你',
                                                      loginController
                                                                  .description
                                                                  .value ==
                                                              '这家伙很懒，什么都没留下~'
                                                          ? '点击添加介绍，让大家认识你'
                                                          : loginController
                                                              .description
                                                              .value,
                                                      style: BaseStyle.fs14,
                                                      maxLines: 3,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                    ),
                                                  ),
                                                )
                                              ],
                                            ),
                                    ),
                                  ),
                                  SizedBox(height: 12.h),
                                  Row(
                                    children: [
                                      Obx(
                                        () => GestureDetector(
                                          // onTap: () => Get.to(MineInfoView()),
                                          child: loginController.sex.value == 2
                                              ? Container(
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: 10,
                                                      vertical: 2),
                                                  decoration: BoxDecoration(
                                                    color: Config
                                                        .primarySwatchColor
                                                        .shade50,
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                2.r)),
                                                  ),
                                                  child: Row(
                                                    children: [
                                                      Icon(
                                                        Icons.add,
                                                        size: 12,
                                                      ),
                                                      SizedBox(width: 5.w),
                                                      Text(
                                                        '添加年龄、所在地等标签',
                                                        style: BaseStyle.fs12,
                                                      ),
                                                    ],
                                                  ),
                                                )
                                              : Row(
                                                  children: [
                                                    Obx(
                                                      () =>
                                                          loginController.sex
                                                                      .value ==
                                                                  3
                                                              ? Container()
                                                              : Container(
                                                                  padding: EdgeInsets
                                                                      .symmetric(
                                                                          horizontal:
                                                                              10,
                                                                          vertical:
                                                                              2),
                                                                  decoration:
                                                                      BoxDecoration(
                                                                    color: Config
                                                                        .primarySwatchColor
                                                                        .shade50,
                                                                    borderRadius:
                                                                        BorderRadius.all(
                                                                            Radius.circular(2.r)),
                                                                  ),
                                                                  child: Row(
                                                                    children: [
                                                                      Icon(
                                                                          loginController.sex.value == 1
                                                                              ? IconFont
                                                                                  .nan
                                                                              : IconFont
                                                                                  .nv,
                                                                          color: loginController.sex.value == 1
                                                                              ? Colors.blueAccent
                                                                              : Colors.red,
                                                                          size: 12),
                                                                      SizedBox(
                                                                          width:
                                                                              2.w),
                                                                      Text(
                                                                        loginController.birthday.isEmpty
                                                                            ? (loginController.sex.value == 1
                                                                                ? '男'
                                                                                : '女')
                                                                            : loginController.age.value,
                                                                        style: BaseStyle
                                                                            .fs12,
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                    ),
                                                    Obx(() => loginController
                                                                .sex.value ==
                                                            3
                                                        ? Container()
                                                        : SizedBox(
                                                            width: 10.w)),
                                                    Obx(
                                                      () => loginController
                                                                  .country
                                                                  .value ==
                                                              ''
                                                          ? Container(
                                                              padding: EdgeInsets
                                                                  .symmetric(
                                                                      horizontal:
                                                                          4,
                                                                      vertical:
                                                                          1),
                                                              decoration:
                                                                  BoxDecoration(
                                                                color: Config
                                                                    .primarySwatchColor
                                                                    .shade50,
                                                                borderRadius: BorderRadius
                                                                    .all(Radius
                                                                        .circular(
                                                                            2.r)),
                                                              ),
                                                              child: Row(
                                                                children: [
                                                                  Icon(
                                                                    Icons.add,
                                                                    size: 12,
                                                                  ),
                                                                  SizedBox(
                                                                      width:
                                                                          5.w),
                                                                  Obx(
                                                                    () => Text(
                                                                      loginController.age.value == '' &&
                                                                              loginController.country.value ==
                                                                                  ''
                                                                          ? '添加年龄、所在地等标签'
                                                                          : (loginController.country.value == '' && loginController.age.value != ''
                                                                              ? '添加所在地标签'
                                                                              : '添加年龄'),
                                                                      style: BaseStyle
                                                                          .fs12,
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            )
                                                          : (loginController
                                                                      .country
                                                                      .value !=
                                                                  ''
                                                              ? Container(
                                                                  padding: EdgeInsets
                                                                      .symmetric(
                                                                          horizontal:
                                                                              4,
                                                                          vertical:
                                                                              1),
                                                                  decoration:
                                                                      BoxDecoration(
                                                                    color: Config
                                                                        .primarySwatchColor
                                                                        .shade50,
                                                                    borderRadius:
                                                                        BorderRadius.all(
                                                                            Radius.circular(2.r)),
                                                                  ),
                                                                  child: Text(
                                                                    // '${loginController.province.value.substring(0, loginController.province.value.lastIndexOf('省'))} · ${loginController.city.value.substring(0, loginController.city.value.lastIndexOf('市'))}',
                                                                    '${loginController.province.value} · ${loginController.city.value}',
                                                                    style:
                                                                        BaseStyle
                                                                            .fs12,
                                                                  ),
                                                                )
                                                              : Container()),
                                                    ),
                                                  ],
                                                ),
                                        ),
                                      ),
                                      Spacer(),
                                    ],
                                  ),
                                  SizedBox(height: 12.h),
                                  Row(
                                    children: [
                                      GestureDetector(
                                        onTap: () =>
                                            Get.to(() => MineInfoView()),
                                        child: Container(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 55, vertical: 6),
                                          decoration: BoxDecoration(
                                            color: Config
                                                .primarySwatchColor.shade50,
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(5.r)),
                                          ),
                                          child: Text(
                                            '编辑资料',
                                            style: BaseStyle.fs16.copyWith(
                                                fontWeight: FontWeight.w500),
                                          ),
                                        ),
                                      ),
                                      Spacer(),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 60.h),
                    ],
                  ),
                ],
              ),
            ),
            bottom: TabBar(
              labelColor: Color(0xff151822),
              labelStyle: BaseStyle.fs16.copyWith(fontWeight: FontWeight.w600),
              unselectedLabelStyle: BaseStyle.fs16,
              unselectedLabelColor: Color(0xff77767c),
              indicatorColor: Colors.black,
              controller: _tabController,
              tabs: [
                Tab(text: '作品'),
                Padding(
                  padding: EdgeInsets.all(4),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('私密'),
                      SizedBox(width: 2.w),
                      Icon(
                        Icons.lock_outline,
                        color: Colors.grey,
                        size: 14,
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(4),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('收藏'),
                      SizedBox(width: 4.w),
                      Icon(
                        Icons.lock_outline,
                        color: Colors.grey,
                        size: 14,
                      )
                    ],
                  ),
                ),
                Tab(text: '喜欢'),
              ],
            ),
          )
        ];
      },
      body: TabBarView(
        controller: _tabController,
        children: [
          CompositionView(),
          PrivateView(),
          CollectView(),
          LikeView(),
        ],
      ),
    );
  }
}
