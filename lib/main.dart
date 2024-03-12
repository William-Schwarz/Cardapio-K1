import 'package:flutter/material.dart';
import 'package:k1_cardapio/view/navigation.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'K1 Cardápio',
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: const Color.fromARGB(255, 156, 16, 6),
        fontFamily: 'DINPro',
      ),
      home: const Navigation(),
    );
  }
}

