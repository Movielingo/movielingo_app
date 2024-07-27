import 'package:get/get.dart';
import 'package:sensors_plus/sensors_plus.dart';

class AccelerometerController extends GetxController {
  var isStationary = true.obs;

  @override
  void onInit() {
    super.onInit();
    accelerometerEventStream().listen((AccelerometerEvent event) {
      if ((event.x.abs() + event.y.abs() + event.z.abs()) > 1.0) {
        isStationary.value = false;
      } else {
        isStationary.value = true;
      }
    });
  }
}
