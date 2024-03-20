import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:k1_cardapio/controller/avaliacao_controller.dart';
import 'package:k1_cardapio/model/avaliacoes_model.dart';
import 'dart:async';
import 'dart:io';
import 'package:k1_cardapio/cors_middleware.dart';

class Avaliacao extends StatefulWidget {
  const Avaliacao({Key? key}) : super(key: key);

  @override
  State<Avaliacao> createState() => _AvaliacaoState();
}

class _AvaliacaoState extends State<Avaliacao> {
  late Future<List<Avaliacoes>> _avaliacao;

  @override
  void initState() {
    super.initState();
    _avaliacao = getAvaliacoes();
  }

  Future<List<Avaliacoes>> getAvaliacoes() async {
    try {
      return AvaliacaoController.getAvaliacao();
    } catch (e) {
      if (kDebugMode) {
        print('Erro ao buscar avaliações: $e');
      }
      return [];
    }
  }

  double calcularMedia(List<Avaliacoes> avaliacoes) {
    if (avaliacoes.isEmpty) return 0.0;

    double total = 0.0;
    for (var avaliacao in avaliacoes) {
      total += avaliacao.nota;
    }
    return total / avaliacoes.length;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Avaliações'),
      ),
      body: FutureBuilder<List<Avaliacoes>>(
        future: _avaliacao,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Erro: ${snapshot.error}'));
          } else {
            List<Avaliacoes> avaliacoes = snapshot.data ?? [];
            double media = calcularMedia(avaliacoes);
            return Column(
              children: [
                Container(
                  alignment: Alignment.center,
                  padding: const EdgeInsets.symmetric(vertical: 20.0),
                  child: _buildStarRating(media),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: avaliacoes.length,
                    itemBuilder: (context, index) {
                      Avaliacoes avaliacao = avaliacoes[index];
                      return ListTile(
                        title: Text('Nota: ${avaliacao.nota}'),
                        subtitle: Text('Comentário: ${avaliacao.comentario}'),
                      );
                    },
                  ),
                ),
              ],
            );
          }
        },
      ),
    );
  }

  Widget _buildStarRating(double rating) {
    return Column(
      children: [
        const Icon(
          Icons.star,
          size: 60,
          color: Colors.yellow,
        ),
        Text(
          rating.toStringAsFixed(1),
          style: const TextStyle(fontSize: 24),
        ),
      ],
    );
  }
}

void main() async {
  var server = await HttpServer.bind(InternetAddress.anyIPv4, 8080);

  server.listen(corsMiddleware(AvaliacaoController()) as void Function(
      HttpRequest event)?);

  if (kDebugMode) {
    print('Servidor iniciado na porta ${server.port}');
  }
}
