import 'dart:async';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:k1_cardapio/cors_middleware.dart';
import 'package:k1_cardapio/model/avaliacoes_model.dart';

class AvaliacaoController {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  static Future<List<Avaliacoes>> getAvaliacao([HttpRequest? request]) async {
    List<Avaliacoes> avaliacoes = [];
    try {
      QuerySnapshot querySnapshot =
          await FirebaseFirestore.instance.collection('Avaliacoes').get();

      for (QueryDocumentSnapshot doc in querySnapshot.docs) {
        Map<String, dynamic>? data = doc.data() as Map<String, dynamic>?;

        if (data != null) {
          avaliacoes.add(
            Avaliacoes(
              id: doc.id,
              idCardapios: doc.id,
              nota: data['Nota'] as int,
              comentario: data['Comentario'],
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
    return avaliacoes;
  }

  Future<void> postAvaliacoes({
    required String idCardapios,
    required int nota,
    required String comentario,
  }) async {
    try {
      await firestore.collection('Avaliacoes').add({
        'IdCardapios': idCardapios,
        'Nota': nota,
        'Comentario': comentario,
        'Data': DateTime.now(),
      });

      if (kDebugMode) {
        print('Dados Salvos no Firestore');
      }
    } on FirebaseException catch (e) {
      if (kDebugMode) {
        print('Erro no upload: ${e.code}');
      }
    }
  }
}

void main() async {
  var server = await HttpServer.bind(InternetAddress.anyIPv4, 8080);

  server.listen(corsMiddleware(AvaliacaoController.getAvaliacao) as void
      Function(HttpRequest event)?);

  if (kDebugMode) {
    print('Servidor iniciado na porta ${server.port}');
  }
}
