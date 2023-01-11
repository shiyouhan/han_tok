import 'package:flutter/material.dart';

import 'package:get/get.dart';

class FollowView extends GetView {
  const FollowView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('FollowView'),
        centerTitle: true,
      ),
      body: Center(
        child: Text(
          'FollowView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
