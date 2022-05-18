import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

class StorageService {
  static Future<String> uploadFile({
    required String path,
    required XFile file,
  }) async {
    final ref = FirebaseStorage.instance.ref().child(path);
    final task = ref.putFile(File(file.path));
    try {
      await Future.wait([task.whenComplete(() async => true)]);
    } on FirebaseException catch (_) {
    } catch (e) {}
    return await ref.getDownloadURL();
  }
}
