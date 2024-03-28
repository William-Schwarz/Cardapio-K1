import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:k1_cardapio/controller/cardapio_controller.dart';
import 'package:k1_cardapio/view/navigation.dart';

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
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _startDate = DateTime.now();
    _endDate = _startDate.add(
      const Duration(days: 5),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Stack(
          alignment: Alignment.center,
          children: [
            SingleChildScrollView(
              child: Container(
                padding: const EdgeInsets.all(25),
                child: Center(
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
                          labelText: 'Descrição do Cardápio',
                          hintText: 'Ex: Cardápio Especial',
                        ),
                        style: const TextStyle(fontSize: 18),
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      Wrap(
                        spacing: 12,
                        runSpacing: 16,
                        alignment: WrapAlignment.center,
                        crossAxisAlignment: WrapCrossAlignment.start,
                        children: [
                          ElevatedButton.icon(
                            onPressed: () async {
                              final DateTime? picked = await showDatePicker(
                                context: context,
                                initialDate: _startDate,
                                firstDate: DateTime.now().subtract(
                                  const Duration(
                                    days: 365,
                                  ),
                                ),
                                lastDate: DateTime.now().add(
                                  const Duration(days: 365),
                                ),
                              );
                              if (picked != null &&
                                  picked != _startDate &&
                                  picked.isBefore(_endDate)) {
                                setState(() {
                                  _startDate = picked;
                                });
                              } else if (picked != null) {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title:
                                          const Text('Data Inicial Inválida!'),
                                      content: const Text(
                                          'Por favor, selecione uma data inicial válida antes da data final.'),
                                      actions: [
                                        TextButton(
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                          child: const Text('OK'),
                                        ),
                                      ],
                                    );
                                  },
                                );
                              }
                            },
                            icon: const Icon(Icons.calendar_today),
                            label: Text('Início: ${_formatDate(_startDate)}'),
                          ),
                          ElevatedButton.icon(
                            onPressed: () async {
                              final DateTime? picked = await showDatePicker(
                                context: context,
                                initialDate: _endDate,
                                firstDate: DateTime.now().subtract(
                                  const Duration(
                                    days: 365,
                                  ),
                                ),
                                lastDate: DateTime.now().add(
                                  const Duration(days: 365),
                                ),
                              );
                              if (picked != null &&
                                  picked != _endDate &&
                                  picked.isAfter(_startDate)) {
                                setState(() {
                                  _endDate = picked;
                                });
                              } else if (picked != null) {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: const Text('Data Final Inválida!'),
                                      content: const Text(
                                          'Por favor, selecione uma data final válida após a data inicial.'),
                                      actions: [
                                        TextButton(
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                          child: const Text('OK'),
                                        ),
                                      ],
                                    );
                                  },
                                );
                              }
                            },
                            icon: const Icon(Icons.calendar_today),
                            label: Text('Fim: ${_formatDate(_endDate)}'),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      if (uploadController.imageData != null)
                        Image.memory(
                          uploadController.imageData!,
                          fit: BoxFit.contain,
                        ),
                      if (uploadController.imageData != null)
                        const SizedBox(
                          height: 5,
                        ),
                      ElevatedButton.icon(
                        onPressed: () async {
                          setState(() {
                            _isLoading = true;
                          });
                          await uploadController.pickImage();
                          setState(() {
                            _isLoading = false;
                          });
                        },
                        icon: const Icon(Icons.upload),
                        label: const Text('Carregar Cardápio'),
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      if (uploadController.imageData != null)
                        ElevatedButton.icon(
                          onPressed: _isLoading
                              ? null
                              : () async {
                                  setState(() {
                                    _isLoading = true;
                                  });
                                  if (_descricao.isNotEmpty) {
                                    await uploadController.postCardapios(
                                      nome: _descricao,
                                      dataInicial: DateTime(_startDate.year,
                                          _startDate.month, _startDate.day),
                                      dataFinal: DateTime(_endDate.year,
                                          _endDate.month, _endDate.day),
                                      uint8list: uploadController.imageData!,
                                    );
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const Navigation()), // Navegue para a tela "Cardápio"
                                    );
                                    ScaffoldMessenger.of(context)
                                        .clearSnackBars();
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: BackdropFilter(
                                          filter: ImageFilter.blur(
                                              sigmaX: 5, sigmaY: 5),
                                          child: const Padding(
                                            padding: EdgeInsets.all(8.0),
                                            child: Text(
                                              'Cardápio atualizado com sucesso!',
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                          ),
                                        ),
                                        duration: const Duration(seconds: 3),
                                      ),
                                    );
                                  } else {
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title: const Text('Erro ao Salvar!'),
                                          content: const Text(
                                              'Por favor, preencha o campo de Descrição do Cardápio.'),
                                          actions: [
                                            TextButton(
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                              child: const Text('OK'),
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  }
                                  setState(() {
                                    _isLoading = false;
                                  });
                                },
                          icon: const Icon(Icons.save),
                          label: const Text('Salvar'),
                        ),
                    ],
                  ),
                ),
              ),
            ),
            if (_isLoading)
              Container(
                color: Colors.black.withOpacity(0.3),
                child: const Center(
                  child: CircularProgressIndicator(),
                ),
              ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}
