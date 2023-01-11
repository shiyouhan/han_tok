import 'package:flutter/material.dart';

import 'package:get/get.dart';

class LikeView extends GetView {
  const LikeView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('LikeView'),
        centerTitle: true,
      ),
      body: Center(
        child: Text(
          'LikeView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
