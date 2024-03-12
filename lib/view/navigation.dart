import 'package:flutter/material.dart';
import 'package:k1_cardapio/controller/new_page.dart';

class Navigation extends StatefulWidget {
  const Navigation({Key? key}) : super(key: key);

  @override
  State<Navigation> createState() => _NavigationState();
}

class _NavigationState extends State<Navigation> {
  int _indiceAtual = 0;
  final List<String> _titulos = ['Inicio', 'Cardápio', 'Avaliar'];
  final List<Widget> _telas = [
    const NewPage(0),
    const NewPage(1),
    const NewPage(2),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 200, 0, 0),
        title: Center(
          child: Text(
            _titulos[_indiceAtual],
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
            ),
          ),
        ),
      ),
      body: Center(
        child: _telas.elementAt(_indiceAtual),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _indiceAtual,
        onTap: onItemTapped,
        backgroundColor: const Color.fromARGB(255, 200, 0, 0),
        selectedItemColor: Colors.white,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Inicio',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.restaurant_menu),
            label: 'Cardápio',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.star),
            label: 'Avaliar',
          ),
        ],
      ),
    );
  }

  void onItemTapped(int index) {
    setState(() {
      _indiceAtual = index;
    });
  }
}
