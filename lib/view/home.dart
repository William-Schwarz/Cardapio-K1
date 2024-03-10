import 'package:flutter/material.dart';
import 'package:k1_cardapio/model/new_page.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _indiceAtual = 0;
  final List<Widget> _telas = [
    NewPage('Inicio'),
    NewPage('Cardápio'),
    NewPage('Atualizar'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: _telas[_indiceAtual],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _indiceAtual,
        onTap: onItemTapped,
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
            icon: Icon(Icons.file_upload),
            label: 'Atualizar',
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
