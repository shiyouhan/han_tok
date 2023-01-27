// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, use_build_context_synchronously, avoid_print, must_be_immutable

import 'dart:io';
import 'dart:ui';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:han_tok/app/modules/index/views/info/info_like_view.dart';
import 'package:han_tok/app/modules/index/views/info/info_opus_view.dart';
import 'package:images_picker/images_picker.dart';

import '../../utils/Iconfont.dart';
import '../base_data.dart';
import '../base_style.dart';
import '../theme_data.dart';
import 'controller/user_info_controller.dart';

class UserInfo extends StatefulWidget {
  String? vlogerId;
  UserInfo({Key? key, required this.vlogerId}) : super(key: key);

  @override
  State<UserInfo> createState() => _UserInfoState();
}

class _UserInfoState extends State<UserInfo> with TickerProviderStateMixin {
  UserInfoController controller = Get.put(UserInfoController());
  late TabController _tabController;
  String? path;
  late ScrollController _scrollController;
  var kExpandedHeight = 400;
  String city = '';

  @override
  void initState() {
    controller.vlogerId.value = widget.vlogerId!;
    controller.query();
    controller.queryFollow();
    _scrollController = ScrollController()..addListener(() => setState(() {}));
    _tabController = TabController(length: 2, vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  bool get _showTitle {
    return _scrollController.hasClients &&
        _scrollController.offset > kExpandedHeight - kToolbarHeight;
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
                      controller.nickname.value,
                      style:
                          BaseStyle.fs16.copyWith(fontWeight: FontWeight.bold),
                    ),
                  )
                : Text(''),
            centerTitle: true,
            leading: GestureDetector(
              onTap: () => Get.back(),
              child: Icon(
                Icons.arrow_back_ios,
                color: _showTitle ? Colors.black : Colors.white,
              ),
            ),
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
                                              controller.bg.value,
                                              fit: BoxFit.fill,
                                            ),
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                        bottom: 60,
                                        child: Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 16.w),
                                          child: GestureDetector(
                                            onTap: () async {
                                              File file = await downloadFile(
                                                  controller.bg.value);
                                              bool res = await ImagesPicker
                                                  .saveImageToAlbum(file,
                                                      albumName: "chaves");
                                              print(res);
                                              Navigator.of(context).pop();
                                              EasyLoading.showToast('下载成功');
                                            },
                                            child: Container(
                                              width: size.width - 32.w,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(2.r),
                                                color: Colors.grey
                                                    .withOpacity(0.2),
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
                              () => controller.bg.value == ''
                                  ? Container(
                                      width: size.width,
                                      height: size.height * 0.3,
                                      color: Colors.white70,
                                    )
                                  : Image.network(
                                      controller.bg.value,
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
                                            () => Center(
                                              child: SizedBox(
                                                width: size.width,
                                                height: size.width,
                                                child: Image.network(
                                                  controller.avatar.value,
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
                                              child: ListTile(
                                                onTap: () async {
                                                  File file =
                                                      await downloadFile(
                                                          controller
                                                              .avatar.value);
                                                  bool res = await ImagesPicker
                                                      .saveImageToAlbum(file,
                                                          albumName: "chaves");
                                                  print(res);
                                                  Navigator.of(context).pop();
                                                  EasyLoading.showToast('下载成功');
                                                },
                                                title: Text(
                                                  '保存头像',
                                                  style: BaseStyle.fs16W,
                                                ),
                                                trailing: Icon(
                                                  Icons.vertical_align_bottom,
                                                  color: Colors.white,
                                                ),
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
                                      controller.avatar.value,
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
                                    controller.nickname.value,
                                    // nicknameController.nickname.value,
                                    style: BaseStyle.fs20W
                                        .copyWith(fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(height: 2.h),
                                  Row(
                                    children: [
                                      Text(
                                        'HanTok号：${controller.hantokNum.value}',
                                        // '抖音号： 1755888613',
                                        style: BaseStyle.fs12
                                            .copyWith(color: Colors.white),
                                      ),
                                      SizedBox(width: 2.w),
                                      GestureDetector(
                                        onTap: () => {
                                          Clipboard.setData(ClipboardData(
                                              text:
                                                  controller.hantokNum.value)),
                                          EasyLoading.showToast(
                                              '已复制HanTok号：${controller.hantokNum.value}'),
                                        },
                                        child: Icon(
                                          IconFont.copy,
                                          size: 14,
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
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(height: 18.h),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Text(
                                            '0',
                                            style: BaseStyle.fs16.copyWith(
                                                fontWeight: FontWeight.bold),
                                          ),
                                          SizedBox(width: 5.h),
                                          Text(
                                            '获赞',
                                            style: BaseStyle.fs16,
                                          ),
                                        ],
                                      ),
                                      SizedBox(width: 18.h),
                                      Row(
                                        children: [
                                          Text(
                                            '0',
                                            style: BaseStyle.fs16.copyWith(
                                                fontWeight: FontWeight.bold),
                                          ),
                                          SizedBox(width: 5.h),
                                          Text(
                                            '关注',
                                            style: BaseStyle.fs16,
                                          ),
                                        ],
                                      ),
                                      SizedBox(width: 18.h),
                                      Row(
                                        children: [
                                          Text(
                                            '0',
                                            style: BaseStyle.fs16.copyWith(
                                                fontWeight: FontWeight.bold),
                                          ),
                                          SizedBox(width: 5.h),
                                          Text(
                                            '粉丝',
                                            style: BaseStyle.fs16,
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 12.h),
                                  Obx(
                                    () => Text(
                                      controller.description.value,
                                      style: BaseStyle.fs14,
                                      maxLines: 4,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  SizedBox(height: 12.h),
                                  Row(
                                    children: [
                                      Obx(
                                        () => GestureDetector(
                                          child: controller.sex.value == 2
                                              ? Container()
                                              : Row(
                                                  children: [
                                                    Obx(
                                                      () =>
                                                          controller.sex
                                                                      .value ==
                                                                  3
                                                              ? Container()
                                                              : Container(
                                                                  padding: EdgeInsets
                                                                      .symmetric(
                                                                          horizontal:
                                                                              6,
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
                                                                          controller.sex.value == 1
                                                                              ? IconFont
                                                                                  .nan
                                                                              : IconFont
                                                                                  .nv,
                                                                          color: controller.sex.value == 1
                                                                              ? Colors.blueAccent
                                                                              : Colors.red,
                                                                          size: 12),
                                                                      SizedBox(
                                                                          width:
                                                                              2.w),
                                                                      Text(
                                                                        controller.birthday.isEmpty
                                                                            ? (controller.sex.value == 1
                                                                                ? '男'
                                                                                : '女')
                                                                            : '${controller.age.value}岁',
                                                                        style: BaseStyle
                                                                            .fs12,
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                    ),
                                                    Obx(() =>
                                                        controller.sex.value ==
                                                                3
                                                            ? Container()
                                                            : SizedBox(
                                                                width: 10.w)),
                                                  ],
                                                ),
                                        ),
                                      ),
                                      Obx(
                                        () => controller.province.value == ''
                                            ? Container()
                                            : Container(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 6, vertical: 2),
                                                decoration: BoxDecoration(
                                                  color: Config
                                                      .primarySwatchColor
                                                      .shade50,
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(2.r)),
                                                ),
                                                child: Row(
                                                  children: [
                                                    Text(
                                                      'IP：',
                                                      style: BaseStyle.fs12,
                                                    ),
                                                    SizedBox(width: 2.w),
                                                    Text(
                                                      controller.province.value
                                                          .substring(
                                                              0,
                                                              controller
                                                                      .province
                                                                      .value
                                                                      .length -
                                                                  1),
                                                      style: BaseStyle.fs12,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                      ),
                                      Spacer(),
                                    ],
                                  ),
                                  SizedBox(height: 16.h),
                                  Obx(() => controller.isMine.value == false
                                      ? Obx(
                                          () => controller.followed.value ==
                                                  false
                                              ? GestureDetector(
                                                  onTap: () =>
                                                      controller.follow(),
                                                  child: Container(
                                                    width: size.width,
                                                    height: 44.h,
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10.r),
                                                      color: Colors.pink,
                                                    ),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        Icon(
                                                          Icons.add,
                                                          size: 20,
                                                          color: Colors.white,
                                                        ),
                                                        SizedBox(width: 4.w),
                                                        Text(
                                                          '关注',
                                                          style: BaseStyle.fs16W
                                                              .copyWith(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                )
                                              : GestureDetector(
                                                  onTap: () =>
                                                      controller.cancelFollow(),
                                                  child: Container(
                                                    width: size.width / 2,
                                                    height: 44.h,
                                                    alignment: Alignment.center,
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10.r),
                                                      color:
                                                          BaseData.kBackColor,
                                                    ),
                                                    child: Text(
                                                      '已关注',
                                                      style: BaseStyle.fs16
                                                          .copyWith(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                    ),
                                                  ),
                                                ),
                                        )
                                      : Container())
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
                Obx(
                  () => Tab(text: '作品 ${controller.publicList.length}'),
                ),
                Obx(
                  () => Tab(text: '喜欢 ${controller.likeList.length}'),
                ),
              ],
            ),
          )
        ];
      },
      body: TabBarView(
        controller: _tabController,
        children: [
          InfoOpusView(),
          InfoLikeView(),
        ],
      ),
    );
  }
}
