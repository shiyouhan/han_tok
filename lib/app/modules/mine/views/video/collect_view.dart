// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:flutter/material.dart';

import 'package:get/get.dart';

class CollectView extends GetView {
  const CollectView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white,
        child: Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 200,
              height: 200,
              child: Image(
                image: AssetImage('assets/images/no_data.png'),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 10),
              child: Text('还没有收藏视频'),
            ),
            Text(
              '用分组收裝，找视频更方便',
              style: TextStyle(color: Colors.grey),
            )
          ],
        )),
      ),
    );
  }
}
