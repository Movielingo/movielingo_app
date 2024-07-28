import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:movielingo_app/controllers/app_lifecycle_controller.dart';

class AppLifecycleObserver extends WidgetsBindingObserver {
  final AppLifecycleController _appLifecycleController =
      Get.find<AppLifecycleController>();

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed) {
      _appLifecycleController.setBackground(false);
    } else if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.inactive) {
      _appLifecycleController.setBackground(true);
    }
  }
}
