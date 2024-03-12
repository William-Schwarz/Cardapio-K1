import 'package:flutter/material.dart';
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
        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.all(8),
          child: ListTile(
            leading: Image.asset(
              cardapio.icone,
              width: 100,
              height: 100,
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
        );
      },
    );
  }
}
