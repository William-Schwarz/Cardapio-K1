import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:k1_cardapio/controller/avaliacao_controller.dart';

class AvaliarCardapio extends StatefulWidget {
  final String idCardapio;
  final String nomeCardapio;

  const AvaliarCardapio(
      {Key? key, required this.nomeCardapio, required this.idCardapio})
      : super(key: key);

  @override
  AvaliarCardapioState createState() => AvaliarCardapioState();
}

class AvaliarCardapioState extends State<AvaliarCardapio> {
  final AvaliacaoController avaliacaoController = AvaliacaoController();
  late int _rating = 1;
  late String _comment = '';

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Center(
        child: Text('Avaliação do Cardápio'),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            widget.nomeCardapio,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: Icon(Icons.star,
                    color: _rating >= 1 ? Colors.orange : Colors.grey),
                onPressed: () => setState(() => _rating = 1),
              ),
              IconButton(
                icon: Icon(Icons.star,
                    color: _rating >= 2 ? Colors.orange : Colors.grey),
                onPressed: () => setState(() => _rating = 2),
              ),
              IconButton(
                icon: Icon(Icons.star,
                    color: _rating >= 3 ? Colors.orange : Colors.grey),
                onPressed: () => setState(() => _rating = 3),
              ),
              IconButton(
                icon: Icon(Icons.star,
                    color: _rating >= 4 ? Colors.orange : Colors.grey),
                onPressed: () => setState(() => _rating = 4),
              ),
              IconButton(
                icon: Icon(Icons.star,
                    color: _rating >= 5 ? Colors.orange : Colors.grey),
                onPressed: () => setState(() => _rating = 5),
              ),
            ],
          ),
          TextField(
            decoration: const InputDecoration(
                hintText: 'Deixe um comentário (opcional)'),
            onChanged: (value) => _comment = value,
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          style: TextButton.styleFrom(
            foregroundColor: Colors.black,
          ),
          child: const Text('Cancelar'),
        ),
        TextButton(
          onPressed: () {
            avaliacaoController.postAvaliacoes(
              idCardapios: widget.idCardapio,
              nota: _rating,
              comentario: _comment,
            );
            ScaffoldMessenger.of(context).clearSnackBars();
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                  child: const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      'Avaliação enviada com sucesso!',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                duration: const Duration(seconds: 3),
              ),
            );
            Navigator.of(context).pop();
          },
          style: TextButton.styleFrom(
            foregroundColor: const Color.fromARGB(255, 156, 16, 6),
          ),
          child: const Text('Enviar'),
        ),
      ],
    );
  }
}
