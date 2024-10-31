import 'dart:io';

import 'package:flutter/material.dart';

class DetectResultsPage extends StatelessWidget {
  const DetectResultsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final arguments = ModalRoute.of(context)?.settings.arguments as Map;
    final image = arguments['image'] as File?;
    final prediction = arguments['prediction'];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Resultados de Detecção'),
        backgroundColor: Colors.white,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (image != null)
              Image.file(image!), // Exibe a imagem
            Text(
              'Predição: $prediction', // Exibe o resultado da detecção
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
