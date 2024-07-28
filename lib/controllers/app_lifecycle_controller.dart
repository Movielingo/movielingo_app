import 'package:get/get.dart';

class AppLifecycleController extends GetxController {
  var isBackground = false.obs;

  void setBackground(bool value) {
    isBackground.value = value;
  }
}
