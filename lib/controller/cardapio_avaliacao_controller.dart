import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:k1_cardapio/model/cardapio_avaliacao_model.dart';

class CardapioAvaliacaoController {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  static Future<List<AvaliacaoCardapio>> getCardapioAvaliacao() async {
    List<AvaliacaoCardapio> avaliacoes = [];
    try {
      QuerySnapshot avaliacoesSnapshot =
          await FirebaseFirestore.instance.collection('Avaliacoes').get();

      for (QueryDocumentSnapshot avaliacaoDoc in avaliacoesSnapshot.docs) {
        Map<String, dynamic> avaliacaoData =
            avaliacaoDoc.data() as Map<String, dynamic>;

        String idCardapio = avaliacaoData['IdCardapios'];

        // Obter dados do cardápio relacionado
        DocumentSnapshot cardapioDoc = await FirebaseFirestore.instance
            .collection('Cardapios')
            .doc(idCardapio)
            .get();
        Map<String, dynamic> cardapioData =
            cardapioDoc.data() as Map<String, dynamic>;

        avaliacoes.add(
          AvaliacaoCardapio(
            id: avaliacaoDoc.id,
            idCardapios: idCardapio,
            nota: avaliacaoData['Nota'],
            comentario: avaliacaoData['Comentario'],
            data: (avaliacaoData['Data'] as Timestamp).toDate(),
            // Incluindo os dados do cardápio
            nomeCardapio: cardapioData['Nome'],
            dataInicialCardapio:
                (cardapioData['DataInicial'] as Timestamp).toDate(),
            dataFinalCardapio:
                (cardapioData['DataFinal'] as Timestamp).toDate(),
            imagemURLCardapio: cardapioData['ImagemURL'],
          ),
        );
      }
    } catch (e) {
      if (kDebugMode) {
        print('Erro ao buscar avaliações: $e');
      }
    }
    return avaliacoes;
  }

  double calcularMediaGeral(List<AvaliacaoCardapio> avaliacoes) {
    if (avaliacoes.isEmpty) return 0.0;

    double mediaGeral = 0.0;
    for (var avaliacao in avaliacoes) {
      mediaGeral += avaliacao.nota;
    }
    return mediaGeral / avaliacoes.length;
  }

  Map<String, List<AvaliacaoCardapio>> agruparAvaliacoesPorCardapio(
      List<AvaliacaoCardapio> avaliacoes) {
    Map<String, List<AvaliacaoCardapio>> avaliacoesAgrupadas = {};

    for (var avaliacao in avaliacoes) {
      if (!avaliacoesAgrupadas.containsKey(avaliacao.idCardapios)) {
        avaliacoesAgrupadas[avaliacao.idCardapios] = [];
      }
      avaliacoesAgrupadas[avaliacao.idCardapios]?.add(avaliacao);
    }

    return avaliacoesAgrupadas;
  }

  Map<Object, double> calcularMediaPorCardapio(
      List<AvaliacaoCardapio> avaliacoes) {
    if (avaliacoes.isEmpty) return {};

    Map<String, List<double>> avaliacoesPorCardapio = {};

    for (var avaliacao in avaliacoes) {
      if (!avaliacoesPorCardapio.containsKey(avaliacao.idCardapios)) {
        avaliacoesPorCardapio[avaliacao.idCardapios] = [];
      }
      avaliacoesPorCardapio[avaliacao.idCardapios]
          ?.add(avaliacao.nota.toDouble());
    }

    Map<String, double> mediaPorCardapio = {};
    avaliacoesPorCardapio.forEach((cardapioId, notas) {
      double total = notas.reduce((a, b) => a + b);
      double media = total / notas.length;
      mediaPorCardapio[cardapioId] = media;
    });

    return mediaPorCardapio;
  }
}
