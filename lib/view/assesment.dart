import 'package:flutter/material.dart';
import 'package:k1_cardapio/controller/assesment.dart';
import 'package:k1_cardapio/model/assesment.dart';
import 'dart:async';
import 'dart:io';
import 'package:k1_cardapio/cors_middleware.dart';

class Assessment extends StatefulWidget {
  const Assessment({Key? key}) : super(key: key);

  @override
  State<Assessment> createState() => _AssessmentState();
}

class _AssessmentState extends State<Assessment> {
  late Future<List<Avaliacao>> _avaliacao;

  @override
  void initState() {
    super.initState();
    _avaliacao = getAvaliacoes();
  }

  Future<List<Avaliacao>> getAvaliacoes() async {
    try {
      return AvaliacaoController.getAvaliacao();
    } catch (e) {
      print('Erro ao buscar avaliações: $e');
      return [];
    }
  }

  double calcularMedia(List<Avaliacao> avaliacoes) {
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
      body: FutureBuilder<List<Avaliacao>>(
        future: _avaliacao,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Erro: ${snapshot.error}'));
          } else {
            List<Avaliacao> avaliacoes = snapshot.data ?? [];
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
                      Avaliacao avaliacao = avaliacoes[index];
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

  print('Servidor iniciado na porta ${server.port}');
}
