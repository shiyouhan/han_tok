// ignore_for_file: prefer_const_constructors, unnecessary_null_comparison, avoid_print

import 'package:filesize/filesize.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';
import 'package:han_tok/app/modules/login/views/login_view.dart';
import 'package:han_tok/app/modules/mine/controllers/setting_controller.dart';
import 'package:han_tok/app/modules/mine/views/mine_view.dart';

import '../../../../data/base_data.dart';
import '../../../../data/base_style.dart';
import '../../../../data/theme_data.dart';
import '../../../../utils/CacheUtil.dart';
import '../../../../utils/Iconfont.dart';
import '../../../login/controllers/login_bottom_controller.dart';
import 'account/account_security_view.dart';
import 'privacy_policy_view.dart';
import 'system_permission_view.dart';
import 'user_agree_view.dart';

class SettingView extends GetView {
  const SettingView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    LoginBottomController loginController = Get.put(LoginBottomController());
    SettingController controller = Get.put(SettingController());

    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: BaseData.bodyColor,
        elevation: 0,
        title: Text(
          '设置',
          style: BaseStyle.fs18,
        ),
        leading: GestureDetector(
          onTap: () => Get.back(),
          child: Icon(
            Icons.arrow_back_ios,
            color: Colors.black,
            size: 24,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: ClampingScrollPhysics(),
          child: Container(
            width: size.width,
            padding: EdgeInsets.symmetric(horizontal: 15.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(left: 18, top: 30, bottom: 10),
                  child: Text(
                    '账号',
                    style: BaseStyle.fs12G,
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    children: [
                      ListTile(
                        onTap: () => Get.to(() => AccountSecurityView()),
                        minLeadingWidth: 15.w,
                        title: Text(
                          '账号与安全',
                          style: BaseStyle.fs16,
                        ),
                        leading: Icon(
                          Icons.person,
                          color: Colors.black,
                          size: 24,
                        ),
                        trailing: Icon(
                          Icons.arrow_forward_ios,
                          size: 16,
                        ),
                      ),
                      Container(
                        height: 1.h,
                        color: Config.primarySwatchColor.shade50,
                        margin: EdgeInsets.only(left: 50.w),
                      ),
                      ListTile(
                        onTap: () => Get.to(() => SystemPermissionView()),
                        minLeadingWidth: 15.w,
                        title: Text(
                          '系统权限',
                          style: BaseStyle.fs16,
                        ),
                        leading: Icon(
                          IconFont.shezhi,
                          color: Colors.black,
                          size: 24,
                        ),
                        trailing: Icon(
                          Icons.arrow_forward_ios,
                          size: 16,
                        ),
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 18, top: 30, bottom: 10),
                  child: Text(
                    '通用',
                    style: BaseStyle.fs12G,
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    children: [
                      ListTile(
                        minLeadingWidth: 15.w,
                        title: Text(
                          '通用设置',
                          style: BaseStyle.fs16,
                        ),
                        leading: Icon(
                          IconFont.shezhi,
                          color: Colors.black,
                          size: 24,
                        ),
                        trailing: Icon(
                          Icons.arrow_forward_ios,
                          size: 16,
                        ),
                      ),
                      Container(
                        height: 1.h,
                        color: Config.primarySwatchColor.shade50,
                        margin: EdgeInsets.only(left: 50.w),
                      ),
                      ListTile(
                        minLeadingWidth: 15.w,
                        title: Text(
                          '背景设置',
                          style: BaseStyle.fs16,
                        ),
                        leading: Icon(
                          IconFont.palette,
                          color: Colors.black,
                          size: 24,
                        ),
                        trailing: Icon(
                          Icons.arrow_forward_ios,
                          size: 16,
                        ),
                      ),
                      Container(
                        height: 1.h,
                        color: Config.primarySwatchColor.shade50,
                        margin: EdgeInsets.only(left: 50.w),
                      ),
                      ListTile(
                        minLeadingWidth: 15.w,
                        title: Text(
                          '字体大小',
                          style: BaseStyle.fs16,
                        ),
                        leading: Icon(
                          IconFont.Aa,
                          color: Colors.black,
                          size: 24,
                        ),
                        trailing: Icon(
                          Icons.arrow_forward_ios,
                          size: 16,
                        ),
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 18, top: 30, bottom: 10),
                  child: Text(
                    '关于',
                    style: BaseStyle.fs12G,
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    children: [
                      ListTile(
                        onTap: () => Get.to(() => UserAgreeView()),
                        minLeadingWidth: 15.w,
                        title: Text(
                          '用户协议',
                          style: BaseStyle.fs16,
                        ),
                        leading: Icon(
                          IconFont.file,
                          color: Colors.black,
                          size: 24,
                        ),
                        trailing: Icon(
                          Icons.arrow_forward_ios,
                          size: 16,
                        ),
                      ),
                      Container(
                        height: 1.h,
                        color: Config.primarySwatchColor.shade50,
                        margin: EdgeInsets.only(left: 50.w),
                      ),
                      ListTile(
                        onTap: () => Get.to(() => PrivacyPolicyView()),
                        minLeadingWidth: 15.w,
                        title: Text(
                          '隐私政策简明版',
                          style: BaseStyle.fs16,
                        ),
                        leading: Icon(
                          IconFont.yinsibaohu,
                          color: Colors.black,
                          size: 24,
                        ),
                        trailing: Icon(
                          Icons.arrow_forward_ios,
                          size: 16,
                        ),
                      ),
                      Container(
                        height: 1.h,
                        color: Config.primarySwatchColor.shade50,
                        margin: EdgeInsets.only(left: 50.w),
                      ),
                      Cache()
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 18.h),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.r),
                    color: Colors.white,
                  ),
                  child: ListTile(
                    onTap: () => showDialog(
                      context: context,
                      barrierDismissible: false, // 点击外部不消失
                      builder: (BuildContext context) {
                        return CupertinoAlertDialog(
                          title: Text('退出？'),
                          content: Text('@${loginController.nickname.value}'),
                          actions: [
                            CupertinoDialogAction(
                              child: Text(
                                '取消',
                                style: BaseStyle.fs16.copyWith(
                                    color: Colors.blue,
                                    fontWeight: FontWeight.bold),
                              ),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                            ),
                            CupertinoDialogAction(
                              child: Text(
                                '确定',
                                style: BaseStyle.fs16.copyWith(
                                    color: Colors.blue,
                                    fontWeight: FontWeight.bold),
                              ),
                              onPressed: () {
                                controller.logOut();
                                Get.offAll(() => LoginView());
                              },
                            ),
                          ],
                        );
                      },
                    ),
                    minLeadingWidth: 15.w,
                    title: Text(
                      '退出登录',
                      style: BaseStyle.fs16,
                    ),
                    leading: Icon(
                      IconFont.tuichu,
                      color: Colors.black,
                      size: 24,
                    ),
                    trailing: Icon(
                      Icons.arrow_forward_ios,
                      size: 16,
                    ),
                  ),
                ),
                Container(
                  alignment: Alignment.center,
                  height: 124.h,
                  child: Text(
                    'HanTok Version 1.0.0',
                    style: BaseStyle.fs12G,
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class Cache extends StatefulWidget {
  const Cache({Key? key}) : super(key: key);

  @override
  State<Cache> createState() => _CacheState();
}

class _CacheState extends State<Cache> {
  ValueNotifier<int> cacheSize = ValueNotifier(0);

  Future<void> initCache() async {
    /// 获取缓存大小
    int size = await CacheUtil.total();

    /// 复制变量
    cacheSize.value = size;
  }

  Future<void> handleClearCache() async {
    try {
      if (cacheSize.value <= 0) throw '没有缓存可清理';

      /// 执行清除缓存
      await CacheUtil.clear();

      /// 更新缓存
      await initCache();

      // AppUtil.showToast('缓存清除成功');
    } catch (e) {
      // AppUtil.showToast(e);
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: cacheSize,
      builder: (BuildContext context, int size, Widget? _) {
        return ListTile(
          leading: Icon(
            IconFont.shanchu,
            color: Colors.black,
            size: 24,
          ),
          minLeadingWidth: 15.w,
          title: Text('清理缓存'),
          trailing: Text(size != null && size > 0 ? filesize(size) : '无缓存'),
          onTap: handleClearCache,
        );
      },
    );
  }
}
