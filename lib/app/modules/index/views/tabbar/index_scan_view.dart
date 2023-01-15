// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:images_picker/images_picker.dart';
import 'package:scan/scan.dart';

// class IndexScanView extends GetView {
//   const IndexScanView({Key? key}) : super(key: key);
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('IndexScanView'),
//         centerTitle: true,
//       ),
//       body: Center(
//         child: Text(
//           'IndexScanView is working',
//           style: TextStyle(fontSize: 20),
//         ),
//       ),
//     );
//   }
// }

class IndexScanView extends StatefulWidget {
  const IndexScanView({Key? key}) : super(key: key);

  @override
  State<IndexScanView> createState() => _IndexScanViewState();
}

class _IndexScanViewState extends State<IndexScanView> {
  //闪光灯
  IconData lightIcon = Icons.flash_on;
  //扫描识图
  final ScanController _controller = ScanController();

  @override
  void initState() {
    super.initState();
  }

  ///扫描结果返回
  _getResult({String? result}) {
    _controller.pause();
    Navigator.of(context).pop(result);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        alignment: AlignmentDirectional.center,
        children: [
          //扫描图
          ScanView(
            controller: _controller,
            scanLineColor: Color(0xFF4759DA),
            onCapture: (result) {
              //返回解析二维码图片结果
              _getResult(result: result);
            },
          ),
          //返回键
          Positioned(
            left: 0,
            top: 25,
            child: IconButton(
              icon: Icon(
                Icons.arrow_back,
                size: 25,
                color: Colors.white,
              ),
              onPressed: () {
                _getResult();
              },
            ),
          ),
          //解析相册图片二维码
          Positioned(
            right: 0,
            top: 25,
            child: MaterialButton(
                child: Icon(
                  Icons.image,
                  size: 25,
                  color: Colors.white,
                ),
                onPressed: () async {
                  var imageFile = await ImagePicker()
                      .pickImage(source: ImageSource.gallery);
                  if (imageFile != null) {
                    _controller.pause();
                    String? result = await Scan.parse(imageFile.path);
                    if (result != null) {
                      //返回解析二维码图片结果
                      _getResult(result: result);
                    }
                  }
                }),
          ),
          //闪光灯
          Positioned(
            bottom: 25,
            child: StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
                return MaterialButton(
                    child: Icon(
                      lightIcon,
                      size: 25,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      _controller.toggleTorchMode();
                      if (lightIcon == Icons.flash_on) {
                        lightIcon = Icons.flash_off;
                      } else {
                        lightIcon = Icons.flash_on;
                      }
                      setState(() {});
                    });
              },
            ),
          ),
        ],
      ),
    );
  }
}
