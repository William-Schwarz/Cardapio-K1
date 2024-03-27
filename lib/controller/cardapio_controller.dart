import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:k1_cardapio/cors_middleware.dart';
import 'package:k1_cardapio/model/cardapios_model.dart';

class CardapioController extends ChangeNotifier {
  final FirebaseStorage storage = FirebaseStorage.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  Uint8List? _imageData;

  Uint8List? get imageData => _imageData;

  Future<Uint8List?> pickImage() async {
    final pickedImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      _imageData = await pickedImage.readAsBytes();
      notifyListeners();
    }
    return _imageData;
  }

  Future<void> postCardapios({
    required String nome,
    required DateTime dataInicial,
    required DateTime dataFinal,
    required Uint8List uint8list,
  }) async {
    if (_imageData != null) {
      try {
        // Salva a imagem no Firebase Storage
        String ref = 'cardapios/img-${DateTime.now().toString()}.png';
        await storage.ref(ref).putData(_imageData!);
        String imageUrl = await storage.ref(ref).getDownloadURL();

        // Salva os dados no Firestore
        await firestore.collection('Cardapios').add({
          'Nome': nome,
          'DataInicial': dataInicial,
          'DataFinal': dataFinal,
          'ImagemURL': imageUrl,
          'Data': DateTime.now(),
        });

        if (kDebugMode) {
          print('Imagem Salva no Storage e Firestore');
        }
      } catch (e) {
        if (kDebugMode) {
          print('Erro no upload: $e');
        }
      }
    }
  }

  static Future<List<Cardapios>> getCardapios([HttpRequest? request]) async {
    List<Cardapios> cardapios = [];

    try {
      QuerySnapshot querySnapshot =
          await FirebaseFirestore.instance.collection('Cardapios').get();

      for (QueryDocumentSnapshot doc in querySnapshot.docs) {
        Map<String, dynamic>? data = doc.data() as Map<String, dynamic>?;

        if (data != null) {
          cardapios.add(
            Cardapios(
              id: doc.id,
              nome: data['Nome'],
              dataInicial: (data['DataInicial'] as Timestamp).toDate(),
              dataFinal: (data['DataFinal'] as Timestamp).toDate(),
              imagemURL: data['ImagemURL'],
              data: (data['Data'] as Timestamp).toDate(),
            ),
          );
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('Erro ao buscar cardápios: $e');
      }
    }

    return cardapios;
  }
}

void main() async {
  var server = await HttpServer.bind(InternetAddress.anyIPv4, 8080);

  server.listen(corsMiddleware(CardapioController.getCardapios) as void
      Function(HttpRequest event)?);

  if (kDebugMode) {
    print('Servidor iniciado na porta ${server.port}');
  }
}
