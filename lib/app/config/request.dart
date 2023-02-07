// ignore_for_file: avoid_print

import 'dart:convert';
import 'dart:io';

import 'package:dio/adapter.dart';
import 'package:dio/dio.dart';
import 'package:flustars/flustars.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

/// 指定返回响应格式
class HttpResponseFormat {
  String? codeKey;
  String? msgKey;
  bool? successKey;
  String? dataKey;
  String? tokenKey;

  HttpResponseFormat(this.codeKey, this.msgKey, this.successKey, this.dataKey,
      {this.tokenKey});
}

/// 请求工具
class Request {
  /// 响应格式
  static late HttpResponseFormat _responseFormat;

  /// 创建opt实例
  static late BaseOptions _options;

  /// 创建Dio实例
  static late Dio _dio;

  /// 公共参数
  static late Map _commonParam;

  static Map<String, dynamic> headers = {
    'headerUserId': '511',
    'headerUserToken': '',
    'version': '',
    'deviceNum': 'deviceNum',
    'timestamp': DateTime.now().millisecondsSinceEpoch,
    'channelId': 1
  };

  /// 初始化dio基础配置
  void init(
      {baseUrl = 'localhost',
      HttpResponseFormat? responseFormat,
      connectTimeOut = 60000,
      receiveTimeOut = 60000,
      commonParam}) {
    _options = BaseOptions(
      /// 基础url
      baseUrl: baseUrl,

      /// 超时时间
      connectTimeout: connectTimeOut,

      /// 接收响应时间
      receiveTimeout: receiveTimeOut,
    );

    /// 初始化响应类型
    _responseFormat =
        responseFormat ?? HttpResponseFormat('code', 'msg', true, 'data');

    /// 公共参数赋值
    _commonParam = commonParam ?? {};

    /// 公共参数加到请求头中
    _commonParam.forEach((key, value) {
      LogUtil.v('>>>>' + key);
      _options.headers[key] = value;
    });

    /// 初始化dio
    _dio = Dio(_options);

    (_dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
        (client) {
      client.findProxy = (url) {
        /// 设置代理 电脑ip地址
        // return "PROXY 10.20.81.75:8888";
        /// 不设置代理
        return 'DIRECT';
      };

      ///忽略证书
      client.badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
    };
  }

  /// _request 是核心函数，所有的请求都会走这里
  Future<T> _request<T>(
    String path, {
    String? method,
    Map<String, dynamic>? params,
    data,
    bool? isHasToken,
    Map<String, dynamic>? headers,
  }) async {
    _dio.options.headers['timeStamp'] = DateTime.now().millisecondsSinceEpoch;
    try {
      // LogUtil.v('请求地址：$path');
      LogUtil.v('请求头：${headers}');
      Response response = await _dio.request(
        path,
        queryParameters: params,
        data: data,
        options: Options(
          method: method,
          headers: headers,
        ),
      );

      /// 响应状态
      if (response.statusCode == 200 || response.statusCode == 201) {
        try {
          LogUtil.v('响应数据：${response}');

          /// 判断返回的code与规定的successCode对比
          // if (response.data[_responseFormat.codeKey].toString() !=
          //     _responseFormat.successCodeValue) {
          //   /// 返回异常处理
          //   return Future.error(response.data[_responseFormat.msgKey]);
          // } else {
          //   if (isHasToken!) {
          //     var data = json.decode(response.data[_responseFormat.dataKey]);
          //     _dio.options.headers[_responseFormat.tokenKey!] =
          //         data[_responseFormat.tokenKey];
          //     _dio.options.headers['userId'] = data['userId'];
          //   }
          //   if (response.data is Map) {
          //     return response.data[_responseFormat.dataKey];
          //   } else {
          //     return json
          //         .decode(response.data[_responseFormat.dataKey].toString());
          //   }
          // }
          // if (isHasToken!) {
          //   var data = json.decode(response.data[_responseFormat.dataKey]);
          //   // _dio.options.headers[_responseFormat.tokenKey!] =
          //   //     data[_responseFormat.tokenKey];
          //   _dio.options.headers['headerUserToken'] = data['headerUserToken'];
          //   _dio.options.headers['headerUserId'] = data['headerUserId'];
          // }
          if (response.data is Map) {
            return response.data[_responseFormat.dataKey];
          } else {
            return json
                .decode(response.data[_responseFormat.dataKey].toString());
          }
        } catch (e) {
          print(e.toString());
          return Future.error('解析响应数据异常');
        }
      } else {
        _handleHttpError(int.parse(response.statusCode.toString()));
        return Future.error('HTTP错误');
      }
    } on DioError catch (e) {
      // Toast.e(_dioError(e), '');
      EasyLoading.showToast(_dioError(e));
      return Future.error(_dioError(e));
    } catch (e) {
      return Future.error('未知异常');
    }
  }

  // 处理 Dio 异常
  String _dioError(DioError error) {
    switch (error.type) {
      case DioErrorType.connectTimeout:
        return "网络连接超时，请检查网络设置";
      case DioErrorType.receiveTimeout:
        return "服务器异常，请稍后重试！";
      case DioErrorType.sendTimeout:
        return "网络连接超时，请检查网络设置";
      case DioErrorType.response:
        return "服务器异常，请稍后重试！";
      case DioErrorType.cancel:
        return "请求已被取消，请重新请求";
      case DioErrorType.other:
        return "网络异常，请稍后重试！";
      default:
        return "Dio异常";
    }
  }

  // 处理Http错误码
  static void _handleHttpError(int errorCode) {
    String message;
    switch (errorCode) {
      case 400:
        message = '请求语法错误';
        break;
      case 401:
        message = '未授权，请登录';
        break;
      case 403:
        message = '拒绝访问';
        break;
      case 404:
        message = '请求出错';
        break;
      case 408:
        message = '请求超时';
        break;
      case 500:
        message = '服务器异常';
        break;
      case 501:
        message = '服务未实现';
        break;
      case 502:
        message = '网关错误';
        break;
      case 503:
        message = '服务不可用';
        break;
      case 504:
        message = '网关超时';
        break;
      case 505:
        message = 'HTTP版本不受支持';
        break;
      default:
        message = '请求失败，错误码：$errorCode';
    }
    LogUtil.v('请求异常$message');
  }

  /// get方法
  Future<T> get<T>(
    String path, {
    Map<String, dynamic>? params,
    bool isHasToken = false,
    Map<String, dynamic>? headers,
  }) {
    LogUtil.v('请求参数params: $params');
    return _request(path,
        method: 'get',
        params: params,
        isHasToken: isHasToken,
        headers: headers);
  }

  /// post方法
  Future<T> post<T>(
    String path, {
    Map<String, dynamic>? params,
    data,
    bool isHasToken = false,
    Map<String, dynamic>? headers,
  }) {
    LogUtil.v('请求参数data: $data');
    return _request(path,
        method: 'post',
        params: params,
        data: data,
        isHasToken: isHasToken,
        headers: headers);
  }
}
