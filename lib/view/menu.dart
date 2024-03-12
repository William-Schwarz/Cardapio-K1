import 'package:flutter/material.dart';
import 'package:k1_cardapio/view/list_menus.dart';

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
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Container(
            color: Colors.white,
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
                const SizedBox(
                  height: 12,
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    elevation: 5,
                    backgroundColor: const Color.fromARGB(255, 156, 16, 6),
                    padding: const EdgeInsets.all(25.0),
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(12.0),
                      ),
                    ),
                  ),
                  onPressed: () {
                    setState(() {
                      _listMenuController.toggleListVisibility();
                    });
                  },
                  child: Text(
                    _listMenuController.isListOpen
                        ? 'Fechar Lista dos Cardápios Anteriores'
                        : 'Abrir Lista dos Cardápios Anteriores',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 12,
                ),
                if (_listMenuController.isListOpen)
                  _listMenuController.buildListView(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
