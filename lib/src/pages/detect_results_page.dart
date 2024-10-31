import 'dart:io';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class DetectResultsPage extends StatelessWidget {
  final File? image;
  final List<Map<String, dynamic>> detections;

  DetectResultsPage({
    super.key,
    required this.image,
    required this.detections,
  });

  // Mapeamento de classes e cores permanece o mesmo.
  final Map<double, String> classNames = {
    0.0: 'Metal',
    1.0: 'Papel/Papelão',
    2.0: 'Vidro',
    3.0: 'Plástico',
  };

  final Map<double, Color> classColors = {
    0.0: Colors.red,
    1.0: Colors.green,
    2.0: Colors.blue,
    3.0: Colors.yellow,
  };

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 255, 255, 255),
            boxShadow: [
              BoxShadow(
                color: const Color.fromARGB(255, 230, 230, 230),
                spreadRadius: 0,
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
        ),
        title: Row(
          children: [
            BackButton(
              onPressed: () => {context.go('/detect')},
              color: const Color.fromARGB(255, 103, 143, 124),
            ),
            const SizedBox(width: 8),
            Text(
              'Resultados da Detecção',
              style: TextStyle(
                color: const Color.fromARGB(255, 103, 143, 124),
                fontSize: height * 0.023,
              ),
            ),
          ],
        ),
      ),
      body: Center(
        child: image != null
            ? Column(
                children: [
                  Stack(
                    children: [
                      // Exibe a imagem original
                      Image.file(image!),
                      // Sobrepõe as caixas de detecção
                      Positioned.fill(
                        child: Stack(
                          children: detections.map((pred) {
                            // Extrai as coordenadas de cada detecção
                            final List<double> caixa = List<double>.from(pred['caixa']);
                            final double left = caixa[0] * width;
                            final double top = caixa[1] * height;
                            final double right = caixa[2] * width;
                            final double bottom = caixa[3] * height;

                            final double classIndex = pred['classe'];
                            final String className = classNames[classIndex] ?? 'Desconhecido';
                            final Color boxColor = classColors[classIndex] ?? Colors.black;
                            final double confidence = pred['confiança'];

                            return Positioned(
                              left: left,
                              top: top,
                              width: right - left,
                              height: bottom - top,
                              child: Container(
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: boxColor,
                                    width: 2,
                                  ),
                                ),
                                child: Text(
                                  '$className - ${(confidence * 100).toStringAsFixed(2)}%',
                                  style: TextStyle(
                                    color: boxColor,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ],
                  ),
                  // Exibe a lista de classes presentes e suas cores
                  Expanded(
                    child: ListView(
                      children: detections.map((pred) {
                        final double classIndex = pred['classe'];
                        final String className = classNames[classIndex] ?? 'Desconhecido';
                        final Color boxColor = classColors[classIndex] ?? Colors.black;
                        final double confidence = pred['confiança'];
                        return ListTile(
                          leading: Container(
                            width: 20,
                            height: 20,
                            color: boxColor,
                          ),
                          title: Text(className),
                          subtitle: Text('Confiança: ${(confidence * 100).toStringAsFixed(2)}%'),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              )
            : const Text(
                "Nenhuma imagem encontrada.",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
      ),
    );
  }
}
