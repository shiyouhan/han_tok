import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/camera_controller.dart';

class CameraView extends GetView<CameraController> {
  const CameraView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('CameraView'),
        centerTitle: true,
      ),
      body: Center(
        child: Text(
          'CameraView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
