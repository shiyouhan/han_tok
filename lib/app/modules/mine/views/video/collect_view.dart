import 'package:flutter/material.dart';

import 'package:get/get.dart';

class CollectView extends GetView {
  const CollectView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('CollectView'),
        centerTitle: true,
      ),
      body: Center(
        child: Text(
          'CollectView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
