import 'dart:async';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:k1_cardapio/cors_middleware.dart';
import 'package:k1_cardapio/model/menu.dart';

class CardapioController {
  static Future<List<Cardapio>> getCardapios([HttpRequest? request]) async {
    List<Cardapio> cardapios = [];

    try {
      QuerySnapshot querySnapshot =
          await FirebaseFirestore.instance.collection('Cardapios').get();

      for (QueryDocumentSnapshot doc in querySnapshot.docs) {
        Map<String, dynamic>? data = doc.data() as Map<String, dynamic>?;

        if (data != null) {
          cardapios.add(
            Cardapio(
              id: doc.id,
              nome: data['Nome'],
              dataInicial: data['DataInicial'],
              dataFinal: data['DataFinal'],
              imagem: data['Imagem'],
            ),
          );
        }
      }
    } catch (e) {
      print('Erro ao buscar cardápios: $e');
    }

    return cardapios;
  }
}

void main() async {
  var server = await HttpServer.bind(InternetAddress.anyIPv4, 8080);

  server.listen(corsMiddleware(CardapioController.getCardapios) as void
      Function(HttpRequest event)?);

  print('Servidor iniciado na porta ${server.port}');
}
