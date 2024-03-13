import 'dart:convert';
import 'dart:typed_data';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker_web/image_picker_web.dart';

class UploadImageController extends StatelessWidget {
  UploadImageController({Key? key}) : super(key: key);
  final FirebaseStorage storage = FirebaseStorage.instance;

  Future<Uint8List?> getImage() async {
    final imageBytes = await ImagePickerWeb.getImageAsBytes();
    if (imageBytes != null) {
      return Uint8List.fromList(imageBytes);
    }
    return null;
  }

  Future<void> uploadImage(Uint8List imageData) async {
    try {
      String base64Image = base64Encode(imageData);
      String dataUrl = 'data:image/png;base64,$base64Image';
      String ref = 'imagens/img-${DateTime.now().toString()}.png';
      await storage
          .ref(ref)
          .putString(dataUrl, format: PutStringFormat.dataUrl);
      print('Imagem carregada com sucesso!');
    } on FirebaseException catch (e) {
      print('Erro no upload: ${e.code}');
    }
  }

  pickAndUploadImage() async {
    Uint8List? imageData = await getImage();
    if (imageData != null) {
      uploadImage(imageData);
    }
  }

  @override
  Widget build(BuildContext context) {
    throw UnimplementedError();
  }
}
