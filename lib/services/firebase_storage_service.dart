import 'package:get/get.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:movielingo_app/singletons/logger.dart';

Reference get firebaseStorage => FirebaseStorage.instance.ref();

class FirebaseStorageService extends GetxService {
  Future<String?> getImage(String? imgName) async {
    if (imgName == null) {
      return null;
    }
    try {
      final url = await firebaseStorage.child(imgName).getDownloadURL();
      return url;
    } catch (e) {
      LoggerSingleton().logger.e('Error getting image: $e');
      return null;
    }
  }
}
