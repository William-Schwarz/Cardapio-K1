import 'package:flutter/material.dart';
import 'package:k1_cardapio/controller/cardapio_controller.dart';
import 'package:k1_cardapio/model/cardapios_model.dart';
import 'package:k1_cardapio/view/full_screen_image.dart';
import 'package:k1_cardapio/view/list_cardapios_view.dart';

class Cardapio extends StatefulWidget {
  const Cardapio({Key? key}) : super(key: key);

  @override
  State<Cardapio> createState() => _CardapioState();
}

class _CardapioState extends State<Cardapio> {
  late ListCardapiosState _listMenuController;
  String? _imagemUrl;
  DateTime? _dataFinal;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _listMenuController = ListCardapiosState();
    _loadImageUrl();
  }

  void _loadImageUrl() async {
    List<Cardapios> cardapios = await CardapioController.getCardapios();
    if (cardapios.isNotEmpty) {
      cardapios.sort((a, b) => b.data.compareTo(a.data));

      setState(() {
        _dataFinal = cardapios.first.dataFinal;
        _isLoading = false;
        if (_dataFinal!.isAfter(DateTime.now()) ||
            _dataFinal!.isAtSameMomentAs(DateTime.now())) {
          _imagemUrl = cardapios.first.imagemURL;
        }
      });
    } else {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(left: 10, right: 10),
            child: GestureDetector(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => FullScreenImage(
                      imagePath: _imagemUrl!,
                    ),
                  ),
                );
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(
                    height: 16,
                  ),
                  if (_isLoading) const LinearProgressIndicator(),
                  if (!_isLoading && _imagemUrl != null)
                    Image.network(
                      _imagemUrl!,
                      width: 450,
                      height: 450,
                      fit: BoxFit.contain,
                    )
                  else
                    const Center(
                      child: Text(
                        'Nenhum cardápio disponível.',
                        style: TextStyle(
                          color: Color.fromARGB(255, 156, 16, 6),
                          fontSize: 16,
                        ),
                      ),
                    ),
                  const SizedBox(
                    height: 16,
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      elevation: 5,
                      backgroundColor: const Color.fromARGB(255, 156, 16, 6),
                      padding: const EdgeInsets.all(25.0),
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(12.0),
                        ),
                      ),
                    ),
                    onPressed: () {
                      setState(() {
                        _listMenuController.toggleListVisibility();
                      });
                    },
                    child: Text(
                      _listMenuController.isListOpen
                          ? 'Fechar Cardápios Anteriores'
                          : 'Visualizar Cardápios Anteriores',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  if (_listMenuController.isListOpen)
                    _listMenuController.build(context),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
