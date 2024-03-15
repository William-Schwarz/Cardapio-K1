import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:k1_cardapio/model/menu.dart';

class CardapioController {
  static Future<List<Cardapio>> getCardapios() async {
    List<Cardapio> cardapios = [];

    try {
      QuerySnapshot querySnapshot =
          await FirebaseFirestore.instance.collection('Cardapios').get();

      for (QueryDocumentSnapshot doc in querySnapshot.docs) {
        Map<String, dynamic>? data = doc.data() as Map<String, dynamic>?;

        if (data != null) {
          cardapios.add(
            Cardapio(
              nome: data['Nome'],
              dataInicial: data['DataInicial'],
              dataFinal: data['DataFinal'],
              imagem: data['Imagem'], // Mantenha a URL original da imagem
              dataAdicao: DateTime.now().toString(),
            ),
          );
        }
      }
    } catch (e) {
      print('Erro ao buscar cardápios: $e');
    }

    return cardapios;
  }
}
