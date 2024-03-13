import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:k1_cardapio/view/navigation.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
        apiKey: "AIzaSyD1PYevclxt1qxJBAacjC_qzXfWFnQsov0",
        authDomain: "cardapio-k1-c3881.firebaseapp.com",
        databaseURL: "https://cardapio-k1-default-rtdb.firebaseio.com",
        projectId: "cardapio-k1",
        storageBucket: "cardapio-k1.appspot.com",
        messagingSenderId: "894308179973",
        appId: "1:894308179973:web:a87d10da32da16c0f33c6c"),
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
