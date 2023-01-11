import 'package:flutter/material.dart';

import 'package:get/get.dart';

class ComView extends GetView {
  const ComView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ComView'),
        centerTitle: true,
      ),
      body: Center(
        child: Text(
          'ComView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
