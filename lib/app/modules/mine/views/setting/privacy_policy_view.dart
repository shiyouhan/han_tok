import 'package:flutter/material.dart';

import 'package:get/get.dart';

class PrivacyPolicyView extends GetView {
  const PrivacyPolicyView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PrivacyPolicyView'),
        centerTitle: true,
      ),
      body: Center(
        child: Text(
          'PrivacyPolicyView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
