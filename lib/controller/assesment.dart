import 'dart:async';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:k1_cardapio/cors_middleware.dart';
import 'package:k1_cardapio/model/assesment.dart';

class AvaliacaoController {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  static Future<List<Avaliacao>> getAvaliacao([HttpRequest? request]) async {
    List<Avaliacao> avaliacoes = [];
    try {
      QuerySnapshot querySnapshot =
          await FirebaseFirestore.instance.collection('Avaliacoes').get();

      for (QueryDocumentSnapshot doc in querySnapshot.docs) {
        Map<String, dynamic>? data = doc.data() as Map<String, dynamic>?;

        if (data != null) {
          avaliacoes.add(
            Avaliacao(
              id: doc.id,
              nota: data['Nota'] as int,
              comentario: data['Comentario'],
            ),
          );
        }
      }
    } catch (e) {
      print('Erro ao buscar cardápios: $e');
    }
    return avaliacoes;
  }

  Future<void> postAvaliacoes({
    required String id,
    required int nota,
    required String comentario,
  }) async {
    try {
      await firestore.collection('Avaliacoes').add({
        'Id': id,
        'Nota': nota,
        'Comentario': comentario,
      });

      print('Dados Salvas no Firestore');
    } on FirebaseException catch (e) {
      print('Erro no upload: ${e.code}');
    }
  }
}

void main() async {
  var server = await HttpServer.bind(InternetAddress.anyIPv4, 8080);

  server.listen(corsMiddleware(AvaliacaoController.getAvaliacao) as void
      Function(HttpRequest event)?);

  print('Servidor iniciado na porta ${server.port}');
}
