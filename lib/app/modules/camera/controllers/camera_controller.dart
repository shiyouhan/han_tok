// ignore_for_file: avoid_print, prefer_const_constructors, unnecessary_import, depend_on_referenced_packages, unnecessary_overrides

import 'package:camera/camera.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:get/get.dart';
import 'package:han_tok/app/modules/camera/views/camera_detail_view.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../utils/ChannelUtil.dart';

class CameraViewController extends GetxController {
  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  CameraController? _cameraController;

  late List<CameraDescription> _cameras;

  final _cameraControllerObs = Rx<CameraController?>(null);

  CameraController? get cameraController => _cameraControllerObs.value;

  final _cameraIndex = 0.obs;

  int get cameraIndex => _cameraIndex.value;

  set cameraIndex(int index) => _cameraIndex.value = index;

  final _flash = false.obs;

  bool get flash => _flash.value;

  set flash(bool enable) => _flash.value = enable;

  final _recording = false.obs;

  bool get recording => _recording.value;

  set recording(bool recording) => _recording.value = recording;

  final cover = ''.obs;
  final videoUrl = ''.obs;
  final coverUrl = 'http://img.syhan.top/uPic/grey.jpg'.obs;

  void onCloseTap() {
    ChannelUtil.closeCamera();
  }

  void init() {
    availableCameras().then((value) {
      print('available camera : $value');
      _cameras = value;
      _initCameraController();
    });
  }

  void onSwitchCamera() {
    if (_cameras.length > 1) {
      cameraIndex = cameraIndex == 0 ? 1 : 0;
      _initCameraController();
    }
  }

  void _initCameraController() {
    print('_initCameraController, cameraIndex: $cameraIndex');
    _cameraController =
        CameraController(_cameras[cameraIndex], ResolutionPreset.max);
    _cameraController?.initialize().then((_) {
      print('MOOC: _initCameraController, refresh controller: $cameraIndex');

      _cameraControllerObs.value = _cameraController;
    }).catchError((Object e) {
      if (e is CameraException) {
        switch (e.code) {
          case 'CameraAccessDenied':
            print('User denied camera access.');
            break;
          default:
            print('MOOC: Handle other errors.');
            break;
        }
      }
    });
  }

  Future<void> takePhotoAndUpload() async {
    if (recording) {
      recording = false;
      XFile file = await _cameraController!.stopVideoRecording();
      print('take video : ${file.path}');
      GallerySaver.saveVideo(file.path);
      var prefs = await SharedPreferences.getInstance();
      prefs.setString('videoUrl', file.path);
      Get.to(() => CameraDetailView());
    } else {
      recording = true;
      _cameraController?.startVideoRecording();
    }
  }

  void onSwitchFlash() {
    _cameraController?.setFlashMode(flash ? FlashMode.off : FlashMode.always);
    flash = !flash;
  }
}
