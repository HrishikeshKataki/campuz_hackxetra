import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:social_media_app/utils/file_utils.dart';
import 'package:social_media_app/utils/firebase.dart';

abstract class Service {
  //function to upload images to firebase storage and retrieve the url.
  Future<String> uploadImage(Reference ref, File file) async {
    String ext = FileUtils.getFileExtension(file);
    if (ext.isEmpty) {
      throw Exception('File extension is empty. Please provide a valid file.');
    }

    // Check if the file exists
    if (!await file.exists()) {
      throw Exception('File does not exist. Please provide a valid file.');
    }

    try {
      Reference storageReference = ref.child("${uuid.v4()}.$ext");
      UploadTask uploadTask = storageReference.putFile(file);

      // Await the upload task
      TaskSnapshot snapshot = await uploadTask;

      // Check if the upload was successful
      if (snapshot.state == TaskState.success) {
        String fileUrl = await snapshot.ref.getDownloadURL();
        return fileUrl;
      } else {
        throw Exception('Upload failed with state: ${snapshot.state}');
      }
    } catch (e) {
      throw Exception('Error uploading image: ${e.toString()}');
    }
  }
}
