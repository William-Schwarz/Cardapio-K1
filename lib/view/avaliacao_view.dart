import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:k1_cardapio/controller/cardapio_avaliacao_controller.dart';
import 'package:k1_cardapio/model/cardapio_avaliacao_model.dart';

class Avaliacao extends StatefulWidget {
  const Avaliacao({Key? key}) : super(key: key);

  @override
  State<Avaliacao> createState() => _AvaliacaoState();
}

class _AvaliacaoState extends State<Avaliacao> {
  late Future<List<AvaliacaoCardapio>> _avaliacao;

  @override
  void initState() {
    super.initState();
    _avaliacao = getAvaliacoes();
  }

  Future<List<AvaliacaoCardapio>> getAvaliacoes() async {
    try {
      return CardapioAvaliacaoController.getCardapioAvaliacao();
    } catch (e) {
      if (kDebugMode) {
        print('Erro ao buscar avaliações: $e');
      }
      return [];
    }
  }

  double calcularMediaGeral(List<AvaliacaoCardapio> avaliacoes) {
    return CardapioAvaliacaoController().calcularMediaGeral(avaliacoes);
  }

  Map<String, List<AvaliacaoCardapio>> agruparAvaliacoesPorCardapio(
      List<AvaliacaoCardapio> avaliacoes) {
    return CardapioAvaliacaoController()
        .agruparAvaliacoesPorCardapio(avaliacoes);
  }

  Map<Object, double> calcularMediaPorCardapio(
      List<AvaliacaoCardapio> avaliacoes) {
    return CardapioAvaliacaoController().calcularMediaPorCardapio(avaliacoes);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<AvaliacaoCardapio>>(
        future: _avaliacao,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Erro: ${snapshot.error}'));
          } else {
            List<AvaliacaoCardapio> avaliacoes = snapshot.data ?? [];
            double media = calcularMediaGeral(avaliacoes);
            avaliacoes.sort((a, b) => b.data.compareTo(a.data));
            Map<Object, double> mediaPorCardapio =
                calcularMediaPorCardapio(avaliacoes);
            Map<String, List<AvaliacaoCardapio>> avaliacoesAgrupadas =
                agruparAvaliacoesPorCardapio(avaliacoes);
            return Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                children: [
                  Container(
                    alignment: Alignment.center,
                    padding: const EdgeInsets.symmetric(vertical: 20.0),
                    child: _buildStarRating(media),
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: avaliacoesAgrupadas.length,
                      itemBuilder: (context, index) {
                        String cardapioId =
                            avaliacoesAgrupadas.keys.elementAt(index);
                        List<AvaliacaoCardapio> avaliacoesDoCardapio =
                            avaliacoesAgrupadas[cardapioId] ?? [];
                        calcularMediaGeral(avaliacoesDoCardapio);
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.3),
                                  spreadRadius: 2,
                                  blurRadius: 5,
                                  offset: const Offset(0, 3),
                                ),
                              ],
                            ),
                            child: ExpansionTile(
                              childrenPadding: const EdgeInsets.only(
                                  right: 24, left: 24, bottom: 8),
                              leading: Image.network(
                                avaliacoesDoCardapio.first.imagemURLCardapio,
                                width: 50,
                                height: 50,
                              ),
                              title: Text(
                                avaliacoesDoCardapio.first.nomeCardapio,
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              trailing: Text(
                                'Média: ${mediaPorCardapio[cardapioId]?.toStringAsFixed(1) ?? 'N/A'}',
                                style: const TextStyle(
                                  fontSize: 14,
                                ),
                              ),
                              children: [
                                const Padding(
                                  padding: EdgeInsets.symmetric(vertical: 4),
                                  child: Text(
                                    'Comentários:',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: avaliacoesDoCardapio
                                      .where((avaliacao) =>
                                          avaliacao.comentario.isNotEmpty)
                                      .map((avaliacao) {
                                    return Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 4),
                                      child: Card(
                                        color: const Color.fromARGB(
                                            255, 156, 16, 6),
                                        elevation: 2,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          side: BorderSide.none,
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  const Icon(
                                                    Icons.chat_sharp,
                                                    color: Colors.white,
                                                    size: 20,
                                                  ),
                                                  const SizedBox(width: 4),
                                                  Expanded(
                                                    child: Text(
                                                      '- ${avaliacao.comentario}',
                                                      style: const TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 14,
                                                        fontStyle:
                                                            FontStyle.italic,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              const SizedBox(
                                                height: 4,
                                              ),
                                              Row(
                                                children: [
                                                  const Icon(
                                                    Icons.star,
                                                    color: Colors.white,
                                                    size: 18,
                                                  ),
                                                  Text(
                                                    ' - ${avaliacao.nota.toString()}',
                                                    style: const TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 14,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    );
                                  }).toList(),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }

  Widget _buildStarRating(double rating) {
    int numberOfStars = rating
        .round(); // Arredonde a média para o número mais próximo de estrelas
    List<Widget> stars = List.generate(
      5,
      (index) => Icon(
        index < numberOfStars ? Icons.star : Icons.star_border,
        size: 30,
        color: const Color.fromARGB(255, 156, 16, 6),
      ),
    );

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Column(
          children: [
            Row(
              children: stars,
            ),
            Text(
              'Média Geral: ${rating.toStringAsFixed(1)}',
              style: const TextStyle(fontSize: 20),
            ),
          ],
        ),
      ],
    );
  }
}
