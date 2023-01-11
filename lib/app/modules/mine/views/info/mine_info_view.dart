// ignore_for_file: prefer_const_constructors, depend_on_referenced_packages, library_prefixes, avoid_print, use_build_context_synchronously

import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_baidu_mapapi_base/flutter_baidu_mapapi_base.dart';
import 'package:flutter_bmflocation/flutter_bmflocation.dart';

import 'package:dio/dio.dart' as DIO;
import 'package:dio/dio.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_pickers/pickers.dart';
import 'package:flutter_pickers/style/picker_style.dart';
import 'package:flutter_pickers/time_picker/model/date_mode.dart';
import 'package:flutter_pickers/time_picker/model/pduration.dart';
import 'package:flutter_pickers/time_picker/model/suffix.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:images_picker/images_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../../main.dart';
import '../../../../data/base_data.dart';
import '../../../../data/base_style.dart';
import '../../../../data/theme_data.dart';
import '../../../../utils/BirthUtil.dart';
import '../../../login/controllers/login_bottom_controller.dart';
import '../../controllers/info_location_controller.dart';
import '../../controllers/mine_info_controller.dart';
import 'info_avatar_view.dart';
import 'info_desc_view.dart';
import 'info_location_view.dart';
import 'info_nickname_view.dart';
import 'info_num_view.dart';
import 'info_qrcode_view.dart';

class MineInfoView extends GetView {
  const MineInfoView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: InfoView(),
    );
  }
}

class InfoView extends StatefulWidget {
  const InfoView({Key? key}) : super(key: key);

  @override
  State<InfoView> createState() => _InfoViewState();
}

class _InfoViewState extends State<InfoView>
    with SingleTickerProviderStateMixin {
  LoginBottomController loginController = Get.put(LoginBottomController());
  late ScrollController _scrollController;
  String? path;
  var kExpandedHeight = 100;
  late DateTime brt;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()..addListener(() => setState(() {}));
  }

  bool get _showTitle {
    return _scrollController.hasClients &&
        _scrollController.offset > kExpandedHeight - kToolbarHeight;
  }

  //显示底部弹框的功能
  void showBottomSheet() {
    //用于在底部打开弹框的效果
    showModalBottomSheet(
      builder: (BuildContext context) {
        //构建弹框中的内容
        return buildBottomSheetWidget(context);
      },
      context: context,
      backgroundColor: Colors.transparent,
    );
  }

  void showBottomSheetOne() {
    //用于在底部打开弹框的效果
    showModalBottomSheet(
      builder: (BuildContext context) {
        //构建弹框中的内容
        return buildBottomSheetWidgetOne(context);
      },
      context: context,
      backgroundColor: Colors.transparent,
    );
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
    MineInfoController controller = Get.put(MineInfoController());
    LoginBottomController loginController = Get.put(LoginBottomController());

    return NestedScrollView(
      controller: _scrollController,
      physics: AlwaysScrollableScrollPhysics(),
      headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
        return <Widget>[
          SliverAppBar(
            pinned: true,
            // stretch: true,
            floating: false,
            // snap: true,
            expandedHeight: 120.h,
            backgroundColor: Colors.white,
            elevation: 0,
            forceElevated: true,
            title: _showTitle
                ? Text(
                    '编辑个人资料',
                    style: BaseStyle.fs16.copyWith(fontWeight: FontWeight.bold),
                  )
                : Text(''),
            centerTitle: true,
            leading: Padding(
              padding: EdgeInsets.only(left: 10),
              child: GestureDetector(
                onTap: () => Get.back(),
                child: !_showTitle
                    ? Align(
                        alignment: Alignment.center,
                        child: CircleAvatar(
                          radius: 16.r,
                          backgroundColor: Colors.grey.withOpacity(0.5),
                          child: Padding(
                            padding: EdgeInsets.only(left: 5),
                            child: Icon(
                              Icons.arrow_back_ios,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                        ),
                      )
                    : Icon(
                        Icons.arrow_back_ios,
                        color: Colors.black,
                        size: 20,
                      ),
              ),
            ),
            flexibleSpace: FlexibleSpaceBar(
              collapseMode: CollapseMode.pin,
              background: Stack(
                children: [
                  Positioned(
                    child: Container(
                      foregroundDecoration: BoxDecoration(
                        color: Colors.transparent.withOpacity(0.3),
                      ),
                      child: Obx(
                        () => Image.network(
                          loginController.bg.value,
                          width: size.width,
                          height: size.height * 0.17,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: paddingTop + 8.h,
                    right: 16.w,
                    child: GestureDetector(
                      onTap: () async {
                        List<Media>? res = await ImagesPicker.pick(
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
                        uploadBg(res);
                        if (res != null) {
                          print(res.map((e) => e.path).toList());
                          setState(() {
                            path = res[0].thumbPath!;
                          });
                        }
                      },
                      child: Container(
                        padding:
                            EdgeInsets.symmetric(vertical: 6, horizontal: 12),
                        decoration: BoxDecoration(
                          color: Colors.grey.withOpacity(0.5),
                          borderRadius: BorderRadius.circular(20.r),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.camera_alt_rounded,
                              size: 20,
                              color: Colors.white,
                            ),
                            SizedBox(width: 2),
                            Text(
                              '更换背景',
                              style:
                                  BaseStyle.fs14.copyWith(color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: size.height * 0.14,
                    left: 0,
                    child: Container(
                      width: size.width,
                      height: size.height,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(10.r),
                          topRight: Radius.circular(10.r),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: size.height * 0.09,
                    left: size.width / 2 - 46.w,
                    child: GestureDetector(
                      onTap: () => showBottomSheetOne(),
                      child: Container(
                        width: 92.w,
                        height: 92.w,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(47.r),
                          border: Border.all(
                            width: 4.w,
                            color: Colors.white,
                          ),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(40.r),
                          child: Container(
                            foregroundDecoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.3),
                            ),
                            child: Obx(
                              () => Image.network(
                                loginController.avatar.value,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: size.height * 0.13,
                    left: size.width / 2 - 15.w,
                    child: GestureDetector(
                      onTap: () => showBottomSheetOne(),
                      child: Icon(
                        Icons.camera_alt_rounded,
                        color: Colors.white,
                        size: 32.w,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )
        ];
      },
      body: Container(
        color: Colors.white,
        child: SingleChildScrollView(
          physics: ClampingScrollPhysics(),
          child: Column(
            children: [
              SizedBox(height: 16.h),
              GestureDetector(
                onTap: () => showBottomSheetOne(),
                child: Text(
                  '点击更换头像',
                  style: BaseStyle.fs14.copyWith(
                    color: Config.primarySwatchColor.shade300,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(height: 50.h),
              ListTile(
                onTap: () => Get.to(() => InfoNicknameView()),
                leading: Text(
                  '名字',
                  style: BaseStyle.fs16.copyWith(color: Colors.grey),
                ),
                title: Obx(
                  () => Text(
                    loginController.nickname.value == '请先登录'
                        ? '填写昵称'
                        : loginController.nickname.value,
                    style: loginController.nickname.value == '请先登录'
                        ? BaseStyle.fs14G
                        : BaseStyle.fs14,
                  ),
                ),
                trailing: Icon(
                  Icons.arrow_forward_ios,
                  size: 16,
                ),
                minLeadingWidth: 88,
              ),
              ListTile(
                onTap: () => Get.to(() => InfoDescView()),
                leading: Text(
                  '简介',
                  style: BaseStyle.fs16.copyWith(color: Colors.grey),
                ),
                title: Obx(
                  () => Text(
                    loginController.description.value == '这家伙很懒，什么都没留下~'
                        ? '介绍一下自己'
                        : loginController.description.value,
                    style: loginController.description.value == '这家伙很懒，什么都没留下~'
                        ? BaseStyle.fs14G
                        : BaseStyle.fs14,
                    maxLines: 4,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                trailing: Icon(
                  Icons.arrow_forward_ios,
                  size: 16,
                ),
                minLeadingWidth: 88,
              ),
              SizedBox(height: 30.h),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 16.w),
                color: BaseData.bodyColor,
                height: 1.h,
              ),
              SizedBox(height: 16.h),
              ListTile(
                onTap: () => showBottomSheet(),
                leading: Text(
                  '性别',
                  style: BaseStyle.fs16.copyWith(color: Colors.grey),
                ),
                title: Obx(
                  () => Text(
                    loginController.sex.value == 3
                        ? '选择性别'
                        : (loginController.sex.value == 1
                            ? '男'
                            : (loginController.sex.value == 0 ? '女' : '不展示')),
                    // '选择性别',
                    style: loginController.sex.value == 3
                        ? BaseStyle.fs14G
                        : BaseStyle.fs14,
                  ),
                ),
                trailing: Icon(
                  Icons.arrow_forward_ios,
                  size: 16,
                ),
                minLeadingWidth: 88,
              ),
              ListTile(
                onTap: () => Pickers.showDatePicker(
                  context,
                  mode: DateMode.YMD,
                  suffix: Suffix(years: ' 年', month: ' 月', days: ' 日'),
                  pickerStyle: PickerStyle(
                    commitButton: Container(
                      alignment: Alignment.center,
                      padding: EdgeInsets.only(left: 12, right: 22),
                      child: Text('确定',
                          style: BaseStyle.fs18.copyWith(color: Colors.red)),
                    ),
                    cancelButton: Container(
                      alignment: Alignment.center,
                      padding: const EdgeInsets.only(left: 22, right: 12),
                      child: Text('取消',
                          style: BaseStyle.fs18.copyWith(color: Colors.grey)),
                    ),
                  ),
                  selectDate: PDuration(
                      year: DateTime.now().year,
                      month: DateTime.now().month,
                      day: DateTime.now().day),
                  onConfirm: (p) {
                    brt = DateTime(p.year!, p.month!, p.day!);
                    loginController.age.value = BirthUtil.getAge(brt);
                    print(controller.age.value);
                    EasyLoading.showToast('设置成功');
                    print('${p.year}-${p.month}-${p.day}');
                    loginController.birthday.value = p.year.toString() +
                        '-'.toString() +
                        p.month.toString() +
                        '-'.toString() +
                        p.day.toString();
                    controller.modifyBirth();
                  },
                  // onChanged: (p) => print(p),
                ),
                leading: Text(
                  '生日',
                  style: BaseStyle.fs16.copyWith(color: Colors.grey),
                ),
                title: Obx(
                  () => Text(
                    loginController.birthday.value == ''
                        ? '选择生日'
                        : loginController.birthday.value,
                    style: loginController.birthday.value == ''
                        ? BaseStyle.fs14G
                        : BaseStyle.fs14,
                  ),
                ),
                trailing: Icon(
                  Icons.arrow_forward_ios,
                  size: 16,
                ),
                minLeadingWidth: 88,
              ),
              LocationView(),
              SizedBox(height: 30.h),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 16.w),
                color: BaseData.bodyColor,
                height: 1.h,
              ),
              SizedBox(height: 16.h),
              ListTile(
                onTap: () => Get.to(() => InfoNumView()),
                leading: Text(
                  'HanTok号',
                  style: BaseStyle.fs16.copyWith(color: Colors.grey),
                ),
                title: Obx(
                  () => Text(
                    loginController.hantokNum.value,
                    // '1755888613',
                    style: BaseStyle.fs14,
                  ),
                ),
                trailing: Icon(
                  Icons.arrow_forward_ios,
                  size: 16,
                ),
                minLeadingWidth: 88,
              ),
              ListTile(
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
                            Center(
                              child: SizedBox(
                                width: size.width,
                                //height: size.width,
                                child: Obx(
                                  () => Image.network(
                                    loginController.bg.value,
                                    fit: BoxFit.fill,
                                  ),
                                ),
                              ),
                            ),
                            Positioned(
                                bottom: 60,
                                child: Padding(
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 16.w),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
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
                                          uploadBg(res);
                                          if (res != null) {
                                            print(res
                                                .map((e) => e.path)
                                                .toList());
                                            setState(() {
                                              path = res[0].thumbPath!;
                                            });
                                          }
                                          Navigator.of(context).pop();
                                        },
                                        child: Container(
                                          width: (size.width - 42) / 2,
                                          alignment: Alignment.center,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(2.r),
                                            color: Colors.grey.withOpacity(0.2),
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
                                          File file = await downloadFile(
                                              controller.avatar.value);
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
                                                BorderRadius.circular(2.r),
                                            color: Colors.grey.withOpacity(0.2),
                                          ),
                                          padding: EdgeInsets.symmetric(
                                              vertical: 15),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Icon(
                                                Icons.vertical_align_bottom,
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
                                )),
                          ],
                        ),
                      ),
                    );
                  },
                ),
                leading: Text(
                  '主页背景',
                  style: BaseStyle.fs16.copyWith(color: Colors.grey),
                ),
                title: Text(
                  '更换主页背景',
                  style: BaseStyle.fs14.copyWith(color: Colors.grey),
                ),
                trailing: Icon(
                  Icons.arrow_forward_ios,
                  size: 16,
                ),
                minLeadingWidth: 88,
              ),
              ListTile(
                onTap: () => Get.to(() => InfoQrcodeView()),
                leading: Text(
                  '二维码',
                  style: BaseStyle.fs16.copyWith(color: Colors.grey),
                ),
                title: Text(
                  '查看你的二维码',
                  style: BaseStyle.fs14.copyWith(color: Colors.grey),
                ),
                trailing: Icon(
                  Icons.arrow_forward_ios,
                  size: 16,
                ),
                minLeadingWidth: 88,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildBottomSheetWidget(BuildContext context) {
    MineInfoController controller = Get.put(MineInfoController());
    return Container(
      height: 230.h,
      margin: EdgeInsets.symmetric(horizontal: 10.w),
      child: Column(
        children: [
          Container(
            decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10))),
            child: buildItem(
              '男',
              onTap: () => controller.selectM(),
            ),
          ),
          Container(
            color: Colors.white,
            child: buildItem(
              '女',
              onTap: () => controller.selectF(),
            ),
          ),
          Container(
            decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(15),
                    bottomRight: Radius.circular(15))),
            child: buildItem(
              '不展示',
              onTap: () => controller.selectS(),
            ),
          ),
          Container(
            color: Colors.transparent,
            height: 10.h,
          ),
          InkWell(
            onTap: () {
              Navigator.of(context).pop();
            },
            child: Container(
              height: 50.h,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15.r),
              ),
              child: Text(
                "取消",
                style: BaseStyle.fs18.copyWith(
                    color: Colors.blueAccent, fontWeight: FontWeight.bold),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget buildBottomSheetWidgetOne(BuildContext context) {
    return Container(
      height: 250.h,
      decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10), topRight: Radius.circular(10))),
      child: Column(
        children: [
          buildItem1(
            '拍一张',
            onTap: () async {
              List<Media>? res = await ImagesPicker.openCamera(
                // pickType: PickType.video,
                pickType: PickType.image,
                quality: 0.8,
                maxSize: 800,
                cropOpt: CropOption(
                  aspectRatio: CropAspectRatio.custom,
                ),
                maxTime: 15,
              );
              print(res);
              uploadAvatar(res);
              if (res != null) {
                print(res[0].path);
                setState(() {
                  path = res[0].thumbPath!;
                });
              }
              Navigator.of(context).pop();
            },
          ),
          const Divider(),
          buildItem1(
            '相册选择',
            onTap: () async {
              List<Media>? res = await ImagesPicker.pick(
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
              uploadAvatar(res);
              if (res != null) {
                print(res.map((e) => e.path).toList());
                setState(() {
                  path = res[0].thumbPath!;
                });
              }
              Navigator.of(context).pop();
            },
          ),
          const Divider(),
          buildItem1('查看大图', onTap: () {
            Get.to(() => InfoAvatarView());
          }),
          Container(
            color: Config.primarySwatchColor.shade50,
            height: 8.h,
          ),
          InkWell(
            onTap: () {
              Navigator.of(context).pop();
            },
            child: Container(
              height: 50.h,
              alignment: Alignment.center,
              child: Text(
                "取消",
                style: BaseStyle.fs14,
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget buildItem(String title, {required Function onTap}) {
    return InkWell(
      onTap: () {
        // Navigator.of(context).pop();
        onTap();
      },
      child: SizedBox(
        height: 46.h,
        child: Center(
          child: Text(
            title,
            style: BaseStyle.fs18.copyWith(color: Colors.blueAccent),
          ),
        ),
      ),
    );
  }

  Widget buildItem1(String title, {required Function onTap}) {
    return InkWell(
      onTap: () {
        // Navigator.of(context).pop();
        onTap();
      },
      child: SizedBox(
        height: 44.h,
        child: Center(
          child: Text(
            title,
            style: BaseStyle.fs14,
          ),
        ),
      ),
    );
  }
}

class LocationView extends StatefulWidget {
  const LocationView({Key? key}) : super(key: key);

  @override
  State<LocationView> createState() => _LocationViewState();
}

class _LocationViewState extends State<LocationView> {
  final LocationFlutterPlugin _myLocPlugin = LocationFlutterPlugin();
  InfoLocationController locationController = Get.put(InfoLocationController());
  LoginBottomController loginController = Get.put(LoginBottomController());

  Map result = {};

  @override
  void initState() {
    super.initState();
    requestPermission();

    /// 设置用户是否同意SDK隐私协议
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
          // city = result.city!;
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

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () => {
        Get.to(() => InfoLocationView()),
      },
      leading: Text(
        '所在地',
        style: BaseStyle.fs16.copyWith(color: Colors.grey),
      ),
      title: Obx(
        () => Text(
          locationController.isSet.value == true
              ? (loginController.country.value == ''
                  ? '你在哪儿'
                  : loginController.location.value)
              : '暂不设置',
          style: locationController.isSet.value == true
              ? (loginController.country.value == ''
                  ? BaseStyle.fs14G
                  : BaseStyle.fs14)
              : BaseStyle.fs14,
        ),
      ),
      trailing: Icon(
        Icons.arrow_forward_ios,
        size: 16,
      ),
      minLeadingWidth: 88,
    );
  }
}
