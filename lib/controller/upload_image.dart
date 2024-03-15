import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:image_picker_web/image_picker_web.dart';

class UploadImageController extends ChangeNotifier {
  final FirebaseStorage storage = FirebaseStorage.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  Uint8List? _imageData;

  Uint8List? get imageData => _imageData;

  Future<Uint8List?> pickImage() async {
    _imageData = await ImagePickerWeb.getImageAsBytes();
    notifyListeners();
    return _imageData;
  }

  Future<void> uploadImage({
    required String nome,
    required String dataInicial,
    required String dataFinal,
    required Uint8List uint8list,
  }) async {
    if (_imageData != null) {
      try {
        // Salva a imagem no Firebase Storage
        String ref = 'imagens/img-${DateTime.now().toString()}.png';
        await storage.ref(ref).putData(_imageData!);
        print('Imagem Salva');

        // Codifica a imagem em base64
        String base64Image = base64Encode(_imageData!);

        // Salva os dados no Firestore
        await firestore.collection('Cardapios').add({
          'Nome': nome,
          'DataInicial': dataInicial,
          'DataFinal': dataFinal,
          'Imagem': base64Image,
        });

        print('Dados Salvas no Firestore');
      } on FirebaseException catch (e) {
        print('Erro no upload: ${e.code}');
      }
    }
  }
}
