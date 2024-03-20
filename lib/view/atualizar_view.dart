import 'package:flutter/material.dart';
import 'package:k1_cardapio/controller/cardapio_controller.dart';

class Atualizar extends StatefulWidget {
  const Atualizar({Key? key}) : super(key: key);

  @override
  State<Atualizar> createState() => _AtualizarState();
}

class _AtualizarState extends State<Atualizar> {
  final CardapioController uploadController = CardapioController();
  late DateTime _startDate;
  late DateTime _endDate;
  late String _descricao = '';

  @override
  void initState() {
    super.initState();
    _startDate = DateTime.now();
    _endDate = _startDate.add(
      const Duration(days: 4),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(50.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  onChanged: (value) {
                    setState(() {
                      _descricao = value;
                    });
                  },
                  decoration: const InputDecoration(
                    labelText: 'Descrição',
                    hintText: 'Ex: Cardápio especial',
                  ),
                ),
                const SizedBox(
                  height: 25,
                ),
                Row(
                  children: [
                    ElevatedButton.icon(
                      onPressed: () async {
                        final DateTime? picked = await showDatePicker(
                          context: context,
                          initialDate: _startDate,
                          firstDate: DateTime(2020),
                          lastDate: DateTime(2101),
                        );
                        if (picked != null && picked != _startDate) {
                          setState(() {
                            _startDate = picked;
                          });
                        }
                      },
                      icon: const Icon(Icons.calendar_today),
                      label: Text('Início: ${_formatDate(_startDate)}'),
                    ),
                    const SizedBox(width: 10),
                    ElevatedButton.icon(
                      onPressed: () async {
                        final DateTime? picked = await showDatePicker(
                          context: context,
                          initialDate: _endDate,
                          firstDate: DateTime(2020),
                          lastDate: DateTime(2101),
                        );
                        if (picked != null && picked != _endDate) {
                          setState(() {
                            _endDate = picked;
                          });
                        }
                      },
                      icon: const Icon(Icons.calendar_today),
                      label: Text('Fim: ${_formatDate(_endDate)}'),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 25,
                ),
                Row(
                  children: [
                    ElevatedButton.icon(
                      onPressed: () async {
                        await uploadController.pickImage();
                      },
                      icon: const Icon(Icons.upload),
                      label: const Text('Carregar Cardápio'),
                    ),
                    const SizedBox(width: 10),
                    ElevatedButton.icon(
                      onPressed: () async {
                        // Adicione o imageData como argumento
                        if (uploadController.imageData != null) {
                          await uploadController.postCardapios(
                            nome: _descricao,
                            dataInicial: _formatDate(_startDate),
                            dataFinal: _formatDate(_endDate),
                            uint8list: uploadController.imageData!,
                          );
                        }
                      },
                      icon: const Icon(Icons.save),
                      label: const Text('Salvar'),
                    ),
                  ],
                ),
                const SizedBox(height: 25),
                if (uploadController.imageData != null)
                  Image.memory(
                    uploadController.imageData!,
                    width: 200,
                    height: 200,
                    fit: BoxFit.cover,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}
