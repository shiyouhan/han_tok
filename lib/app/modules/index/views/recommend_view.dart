import 'package:flutter/material.dart';

import 'package:get/get.dart';

class RecommendView extends GetView {
  const RecommendView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('RecommendView'),
        centerTitle: true,
      ),
      body: Center(
        child: Text(
          'RecommendView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
