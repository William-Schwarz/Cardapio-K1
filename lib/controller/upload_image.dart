import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class UploadImageController extends StatelessWidget {
  UploadImageController({super.key});
  final FirebaseStorage storage = FirebaseStorage.instance;

  Future<XFile?> getImage() async {
    final ImagePicker picker = ImagePicker();
    XFile? image = await picker.pickImage(source: ImageSource.gallery);
    return image;
  }

  Future<void> uploadImage(String path) async {
    File file = File(path);
    try {
      String ref = 'imagens/img-${DateTime.now().toString()}.png';
      await storage.ref(ref).putFile(file);
    } on FirebaseException catch (e) {
      throw Exception('Erro no upload: ${e.code}');
    }
  }

  pickAndUploadImage() async {
    XFile? file = await getImage();
    if (file != null) {
      uploadImage(file.path);
    }
  }

  @override
  Widget build(BuildContext context) {
    throw UnimplementedError();
  }
}
