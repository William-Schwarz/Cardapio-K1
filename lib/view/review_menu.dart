import 'package:flutter/material.dart';

class ReviewDialog extends StatefulWidget {
  final String nomeCardapio;

  const ReviewDialog({Key? key, required this.nomeCardapio}) : super(key: key);

  @override
  ReviewDialogState createState() => ReviewDialogState();
}

class ReviewDialogState extends State<ReviewDialog> {
  int _rating = 0;
  String _comment = '';

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
            //usar o _rating e o _comment para enviar a avaliação
            Navigator.of(context).pop();
          },
          style: TextButton.styleFrom(
            foregroundColor: Colors.blue,
          ),
          child: const Text('Enviar'),
        ),
      ],
    );
  }
}
