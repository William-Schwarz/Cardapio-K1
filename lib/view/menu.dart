import 'package:flutter/material.dart';
import 'package:k1_cardapio/controller/list_menus.dart';

class Menu extends StatefulWidget {
  const Menu({Key? key}) : super(key: key);

  @override
  State<Menu> createState() => _MenuState();
}

class _MenuState extends State<Menu> {
  late ListMenusController _listMenuController;

  @override
  void initState() {
    super.initState();
    _listMenuController = ListMenusController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          color: Colors.grey[200],
          padding: const EdgeInsets.only(left: 10, right: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(
                height: 1,
              ),
              Image.asset(
                'images/2.png',
                width: 800,
                height: 800,
                fit: BoxFit.contain,
              ),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    _listMenuController.toggleListVisibility();
                  });
                },
                child: Text(_listMenuController.isListOpen
                    ? 'Fechar Lista dos Cardápios Anteriores'
                    : 'Abrir Lista dos Cardápios Anteriores'),
              ),
              if (_listMenuController.isListOpen)
                _listMenuController.buildListView(),
            ],
          ),
        ),
      ),
    );
  }
}
