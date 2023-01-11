import 'package:flutter/material.dart';

import 'package:get/get.dart';

class UserAgreeView extends GetView {
  const UserAgreeView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('UserAgreeView'),
        centerTitle: true,
      ),
      body: Center(
        child: Text(
          'UserAgreeView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
