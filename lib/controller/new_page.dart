import 'package:flutter/material.dart';
import 'package:k1_cardapio/view/assesment.dart';
import 'package:k1_cardapio/view/menu.dart';

class NewPage extends StatelessWidget {
  final int indice;

  const NewPage(this.indice, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget page;
    if (indice == 0) {
      page = const Menu();
    } else if (indice == 1) {
      page = const Assessment();
    } else {
      page = Scaffold(
        appBar: AppBar(
          title: const Text('Erro!'),
        ),
        body: const Center(
          child: Text('Erro!'),
        ),
      );
    }

    return page;
  }
}
