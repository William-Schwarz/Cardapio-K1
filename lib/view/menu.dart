import 'package:flutter/material.dart';
import 'package:k1_cardapio/controller/cardapio.dart';

class Menu extends StatefulWidget {
  const Menu({Key? key}) : super(key: key);

  @override
  State<Menu> createState() => _Menu();
}

class _Menu extends State<Menu> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Cardápio do Dia',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Image.asset('images/K1_logo_colorido.png',
                      width: 200, height: 200, fit: BoxFit.contain)
                ],
              ),
            ),
          ),
          Expanded(
            child: ListView.separated(
              itemBuilder: (BuildContext context, int index) {
                final cardapio = CardapioController.tabela[index];
                return ListTile(
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(12)),
                  ),
                  leading: Image.asset(cardapio.icone),
                  title: Text(
                    cardapio.nome,
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  trailing: Text(cardapio.data),
                );
              },
              padding: const EdgeInsets.all(16.0),
              separatorBuilder: (_, __) => const Divider(),
              itemCount: CardapioController.tabela.length,
            ),
          ),
        ],
      ),
    );
  }
}
