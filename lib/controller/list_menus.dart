import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:k1_cardapio/controller/menu.dart';

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
          child: Slidable(
            endActionPane: ActionPane(
              extentRatio: 0.25,
              motion: const ScrollMotion(),
              children: [
                SlidableAction(
                  onPressed: (BuildContext context) {},
                  borderRadius: BorderRadius.circular(8),
                  backgroundColor: const Color.fromARGB(255, 200, 0, 0),
                  foregroundColor: Colors.white,
                  icon: Icons.star,
                  label: 'Avaliar',
                ),
              ],
            ),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: Colors.red[200],
                // border: Border.all(
                //   width: 1,
                //   color: Colors.black,
                // ),
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
        );
      },
    );
  }
}
