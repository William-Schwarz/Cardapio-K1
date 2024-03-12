import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:k1_cardapio/controller/menu.dart';
import 'package:k1_cardapio/view/full_screen_image.dart';
import 'package:k1_cardapio/view/review_menu.dart';

class ListMenusController {
  bool isListOpen = false;

  void toggleListVisibility() {
    isListOpen = !isListOpen;
  }

  Widget buildListView() {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: CardapioController.tabela.length,
      itemBuilder: (BuildContext context, int index) {
        final cardapio = CardapioController.tabela[index];
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: GestureDetector(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => FullScreenImage(
                    imagePath: cardapio.icone,
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
                          return ReviewDialog(nomeCardapio: cardapio.nome);
                        },
                      );
                    },
                    borderRadius: BorderRadius.circular(8),
                    backgroundColor: const Color.fromARGB(255, 156, 16, 6),
                    foregroundColor: Colors.white,
                    icon: Icons.addchart,
                    label: 'Avaliar',
                  ),
                ],
              ),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  // color: Colors.red[200],
                  // border: Border.all(
                  //   width: 1,
                  //   color: const Color.fromARGB(255, 200, 0, 0),
                  // ),
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
                      leading: Image.asset(
                        cardapio.icone,
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
                      trailing: Text(cardapio.data),
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
}
