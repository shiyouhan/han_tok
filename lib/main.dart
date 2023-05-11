 // ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:han_tok/app/modules/login/views/login_view.dart';

import 'app/config/net_url.dart';
import 'app/config/request.dart';
import 'app/data/theme_data.dart';
import 'app/routes/app_pages.dart';
import 'generated/l10n.dart';

Request request = Request();

void main() {
  request.init(
    baseUrl: NetUrl.http_HostName,
    responseFormat: HttpResponseFormat('code', 'msg', true, 'data'),
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(390, 844),
      minTextAdapt: true,
      builder: (context, _) => GetMaterialApp(
        // showPerformanceOverlay: true,
        localizationsDelegates: const [
          S.delegate,
          GlobalMaterialLocalizations.delegate, //安卓
          GlobalWidgetsLocalizations.delegate, //浏览器
          GlobalCupertinoLocalizations.delegate //ios
        ],
        supportedLocales: S.delegate.supportedLocales,
        debugShowCheckedModeBanner: false,
        title: 'HanTok',
        theme: defaultTheme,
        darkTheme: appDarkTheme,
        themeMode: ThemeMode.light,
        // initialRoute: AppPages.INITIAL,
        initialRoute: Routes.LOGIN,
        getPages: AppPages.routes,
        // 命名路由配置
        builder: EasyLoading.init(),
      ),
    );
  }
}
