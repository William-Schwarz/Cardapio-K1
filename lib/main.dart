import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:k1_cardapio/view/navigation.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: "<KEY>",
      authDomain: "k1-cardapio.firebaseapp.com",
      databaseURL: "https://k1-cardapio.firebaseio.com",
      projectId: "k1-cardapio",
      storageBucket: "k1-cardapio.appspot.com",
      messagingSenderId: "1062444444444",
      appId: "1:1062444444444:web:3232323232323232323232",
    ),
  );
  runApp(
    const MyApp(),
  );
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
