import 'package:flutter/material.dart';
import 'package:k1_cardapio/controller/upload_image.dart';

class Update extends StatefulWidget {
  const Update({Key? key}) : super(key: key);

  @override
  State<Update> createState() => _Update();
}

class _Update extends State<Update> {
  final UploadImageController uploadController = UploadImageController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ElevatedButton.icon(
                  onPressed: () {
                    uploadController.pickAndUploadImage();
                  },
                  icon: const Icon(Icons.upload),
                  label: const Text('Carregar Cardápio'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
