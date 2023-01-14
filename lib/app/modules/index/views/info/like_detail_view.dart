import 'package:flutter/material.dart';

import 'package:get/get.dart';

class LikeDetailView extends GetView {
  const LikeDetailView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('LikeDetailView'),
        centerTitle: true,
      ),
      body: Center(
        child: Text(
          'LikeDetailView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
