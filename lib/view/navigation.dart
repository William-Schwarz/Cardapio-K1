import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:k1_cardapio/controller/new_page.dart';
import 'package:k1_cardapio/view/login_view.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Navigation extends StatefulWidget {
  const Navigation({Key? key}) : super(key: key);

  @override
  State<Navigation> createState() => _NavigationState();
}

class _NavigationState extends State<Navigation> {
  int _indiceAtual = 0;
  final List<String> _titulos = ['Cardápio', 'Avaliações', 'Atualizar'];
  final List<Widget> _telas = [
    const NewPage(0),
    const NewPage(1),
    const NewPage(2),
  ];

  late User? _user;

  @override
  void initState() {
    super.initState();
    _getUser();
  }

  Future<void> _getUser() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    _user = auth.currentUser;

    if (_user == null) {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 156, 16, 6),
        flexibleSpace: Center(
          child: Text(
            _titulos[_indiceAtual],
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
            ),
          ),
        ),
        actions: [
          Center(
            child: Column(
              children: [
                IconButton(
                  onPressed: () {
                    if (_user != null) {
                      _signOut();
                    } else {
                      Navigator.push(
                        context,
                        PageRouteBuilder(
                          pageBuilder: (_, __, ___) => const LoginView(),
                          transitionsBuilder: (_, animation, __, child) {
                            return SlideTransition(
                              position: Tween<Offset>(
                                begin: const Offset(0, 1),
                                end: Offset.zero,
                              ).animate(animation),
                              child: child,
                            );
                          },
                        ),
                      );
                    }
                  },
                  icon: _user != null
                      ? const Icon(Icons.logout)
                      : const Icon(Icons.login),
                  color: Colors.white,
                ),
                _user != null
                    ? const Text('Sair',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                        ))
                    : const Text(
                        'Entrar',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                        ),
                      )
              ],
            ),
          ),
        ],
      ),
      body: Center(
        child: _telas.elementAt(_indiceAtual),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _indiceAtual,
        onTap: onItemTapped,
        backgroundColor: const Color.fromARGB(255, 156, 16, 6),
        selectedItemColor: Colors.white,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.restaurant_menu),
            label: 'Cardápio',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.assessment),
            label: 'Avaliações',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.folder),
            label: 'Atualizar',
          ),
        ],
      ),
    );
  }

  void onItemTapped(int index) {
    if (_user != null || index != 2) {
      setState(() {
        _indiceAtual = index;
      });
    } else {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
            child: const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                'Você precisa estar logado para acessar esta funcionalidade.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }

  void _signOut() async {
    try {
      await FirebaseAuth.instance.signOut();
      setState(() {
        _user = null;
      });
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.blue[700]?.withOpacity(0.9),
          content: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
            child: const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                'Logout realizado com sucesso!',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
          duration: const Duration(seconds: 3),
        ),
      );
    } catch (e) {
      if (kDebugMode) {
        print('Erro ao fazer logout: $e');
      }
    }
  }
}
