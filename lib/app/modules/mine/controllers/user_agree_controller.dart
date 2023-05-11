import 'package:get/get.dart';
import 'package:webview_flutter/webview_flutter.dart';

class UserAgreeController extends GetxController {
  late WebViewController webController;

  @override
  void onInit() {
    webController = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadRequest(Uri.parse('https://www.douyin.com/draft/douyin_agreement/douyin_agreement_user.html'));
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
}
