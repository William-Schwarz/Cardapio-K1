import 'package:flutter/material.dart';

class NewPage extends StatelessWidget {
  final String texto;

  NewPage(this.texto);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Text(texto),
      ),
    );
  }
}
