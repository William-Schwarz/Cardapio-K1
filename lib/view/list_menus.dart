import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:k1_cardapio/controller/menu.dart';
import 'package:k1_cardapio/model/menu.dart';
import 'package:k1_cardapio/view/full_screen_image.dart';
import 'package:k1_cardapio/view/review_menu.dart';

class ListMenusController {
  bool isListOpen = false;

  void toggleListVisibility() {
    isListOpen = !isListOpen;
  }

  Widget buildListView() {
    return FutureBuilder<List<Cardapio>>(
      future: CardapioController.getCardapios(),
      builder: (BuildContext context, AsyncSnapshot<List<Cardapio>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          List<Cardapio> cardapios = snapshot.data!;
          // Ordenar a lista de cardápios pela data inicial
          cardapios.sort((a, b) => a.dataInicial.compareTo(b.dataInicial));
          return ListView.builder(
            shrinkWrap: true,
            itemCount: cardapios.length,
            itemBuilder: (BuildContext context, int index) {
              final cardapio = cardapios[index];
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => FullScreenImage(
                          imagePath: cardapio.imagem,
                        ),
                      ),
                    );
                  },
                  child: Slidable(
                    endActionPane: ActionPane(
                      extentRatio: 0.25,
                      motion: const ScrollMotion(),
                      children: [
                        SlidableAction(
                          onPressed: (BuildContext context) {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return ReviewDialog(
                                  nomeCardapio: cardapio.nome,
                                );
                              },
                            );
                          },
                          borderRadius: BorderRadius.circular(8),
                          backgroundColor:
                              const Color.fromARGB(255, 156, 16, 6),
                          foregroundColor: Colors.white,
                          icon: Icons.addchart,
                          label: 'Avaliar',
                        ),
                      ],
                    ),
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
                      child: Column(
                        children: [
                          ListTile(
                            leading: Image.network(
                              cardapio.imagem,
                              width: 50,
                              height: 50,
                            ),
                            title: Text(
                              cardapio.nome,
                              style: const TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            trailing: Text(
                              '${cardapio.dataInicial} / ${cardapio.dataFinal}',
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        }
      },
    );
  }
}
