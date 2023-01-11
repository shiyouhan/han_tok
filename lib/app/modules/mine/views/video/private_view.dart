import 'package:flutter/material.dart';

import 'package:get/get.dart';

class PrivateView extends GetView {
  const PrivateView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PrivateView'),
        centerTitle: true,
      ),
      body: Center(
        child: Text(
          'PrivateView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
