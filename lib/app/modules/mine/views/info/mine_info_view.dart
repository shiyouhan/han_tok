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

  //???????????????????????????
  void showBottomSheet() {
    //????????????????????????????????????
    showModalBottomSheet(
      builder: (BuildContext context) {
        //????????????????????????
        return buildBottomSheetWidget(context);
      },
      context: context,
      backgroundColor: Colors.transparent,
    );
  }

  void showBottomSheetOne() {
    //????????????????????????????????????
    showModalBottomSheet(
      builder: (BuildContext context) {
        //????????????????????????
        return buildBottomSheetWidgetOne(context);
      },
      context: context,
      backgroundColor: Colors.transparent,
    );
  }

  // ???????????????
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
        EasyLoading.showError('??????????????????');
      });
    }
  }

  // ????????????
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
        EasyLoading.showError('??????????????????');
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
                    '??????????????????',
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
                              '????????????',
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
                  '??????????????????',
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
                  '??????',
                  style: BaseStyle.fs16.copyWith(color: Colors.grey),
                ),
                title: Obx(
                  () => Text(
                    loginController.nickname.value == '????????????'
                        ? '????????????'
                        : loginController.nickname.value,
                    style: loginController.nickname.value == '????????????'
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
                  '??????',
                  style: BaseStyle.fs16.copyWith(color: Colors.grey),
                ),
                title: Obx(
                  () => Text(
                    loginController.description.value == '????????????????????????????????????~'
                        ? '??????????????????'
                        : loginController.description.value,
                    style: loginController.description.value == '????????????????????????????????????~'
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
                  '??????',
                  style: BaseStyle.fs16.copyWith(color: Colors.grey),
                ),
                title: Obx(
                  () => Text(
                    loginController.sex.value == 3
                        ? '????????????'
                        : (loginController.sex.value == 1
                            ? '???'
                            : (loginController.sex.value == 0 ? '???' : '?????????')),
                    // '????????????',
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
                  suffix: Suffix(years: ' ???', month: ' ???', days: ' ???'),
                  pickerStyle: PickerStyle(
                    commitButton: Container(
                      alignment: Alignment.center,
                      padding: EdgeInsets.only(left: 12, right: 22),
                      child: Text('??????',
                          style: BaseStyle.fs18.copyWith(color: Colors.red)),
                    ),
                    cancelButton: Container(
                      alignment: Alignment.center,
                      padding: const EdgeInsets.only(left: 22, right: 12),
                      child: Text('??????',
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
                    EasyLoading.showToast('????????????');
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
                  '??????',
                  style: BaseStyle.fs16.copyWith(color: Colors.grey),
                ),
                title: Obx(
                  () => Text(
                    loginController.birthday.value == ''
                        ? '????????????'
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
                  'HanTok???',
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
                                            '????????????',
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
                                          EasyLoading.showToast('????????????');
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
                                                '??????',
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
                  '????????????',
                  style: BaseStyle.fs16.copyWith(color: Colors.grey),
                ),
                title: Text(
                  '??????????????????',
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
                  '?????????',
                  style: BaseStyle.fs16.copyWith(color: Colors.grey),
                ),
                title: Text(
                  '?????????????????????',
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
              '???',
              onTap: () => controller.selectM(),
            ),
          ),
          Container(
            color: Colors.white,
            child: buildItem(
              '???',
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
              '?????????',
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
                "??????",
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
            '?????????',
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
            '????????????',
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
          buildItem1('????????????', onTap: () {
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
                "??????",
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

    /// ????????????????????????SDK????????????
    BMFMapSDK.setAgreePrivacy(true);
    _myLocPlugin.setAgreePrivacy(true);

    // ????????????sdk???????????????
    if (Platform.isIOS) {
      _myLocPlugin.authAK('YGyNATp3fEQM5bSNczzrGiaqSPOAm9QT');
      BMFMapSDK.setApiKeyAndCoordType(
          'YGyNATp3fEQM5bSNczzrGiaqSPOAm9QT', BMF_COORD_TYPE.BD09LL);
    } else if (Platform.isAndroid) {
      // Android ???????????????????????????Apikey,
      // ??????????????????Manifest???????????????????????????????????????????????????(https://lbsyun.baidu.com/)demo
      BMFMapSDK.setCoordType(BMF_COORD_TYPE.BD09LL);
    }

    locationAction();

    ///??????????????????
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
    /// ??????android??????ios???????????????
    /// android ?????????????????????
    /// ios ?????????????????????
    Map iosMap = _initIOSOptions().getMap();
    Map androidMap = _initAndroidOptions().getMap();

    await _myLocPlugin.prepareLoc(androidMap, iosMap);
  }

  // ????????????????????????
  void requestPermission() async {
    // ????????????
    bool hasLocationPermission = await requestLocationPermission();
    if (hasLocationPermission) {
      // ??????????????????
    } else {}
  }

  /// ??????????????????
  /// ????????????????????????true??? ????????????false
  Future<bool> requestLocationPermission() async {
    //?????????????????????
    var status = await Permission.location.status;
    if (status == PermissionStatus.granted) {
      //????????????
      return true;
    } else {
      //??????????????????????????????
      status = await Permission.location.request();
      if (status == PermissionStatus.granted) {
        return true;
      } else {
        return false;
      }
    }
  }

  /// ??????????????????
  BaiduLocationAndroidOption _initAndroidOptions() {
    BaiduLocationAndroidOption options = BaiduLocationAndroidOption(
        locationMode: BMFLocationMode.hightAccuracy,
        isNeedAddress: true,
        isNeedAltitude: true,
        isNeedLocationPoiList: true,
        isNeedNewVersionRgc: true,
        isNeedLocationDescribe: true,
        openGps: true,
        scanspan: 4000, //????????????????????? 0 ??????????????????
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
        '?????????',
        style: BaseStyle.fs16.copyWith(color: Colors.grey),
      ),
      title: Obx(
        () => Text(
          locationController.isSet.value == true
              ? (loginController.country.value == ''
                  ? '????????????'
                  : loginController.location.value)
              : '????????????',
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
