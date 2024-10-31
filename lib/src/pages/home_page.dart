import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    // Para obter as dimensões da tela
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Adiciona a imagem acima do botão
            Image.asset(
              'lib/src/assets/logo.png', // Caminho para a imagem nos assets
              width: 300, // Ajuste o tamanho conforme necessário
              height: 100,
            ),
            const SizedBox(height: 20), // Espaço entre a imagem e o botão
            // Botão estilizado
            GestureDetector(
              onTap: () {
                context.go('/detect');
              },
              child: Container(
                width: width * 0.6,
                decoration: BoxDecoration(
                  color: const Color(0xFF06502D), // Cor de fundo
                  borderRadius: BorderRadius.circular(15), // Raio das bordas
                ),
                padding: EdgeInsets.symmetric(
                  vertical: height * 0.02, // Padding vertical
                  horizontal: width * 0.01, // Padding horizontal
                ),
                alignment: Alignment.center, // Centraliza o conteúdo
                child: Text(
                  'Detector de Resíduos',
                  style: TextStyle(
                    fontSize: 15, // Tamanho da fonte
                    color: Colors.white, // Cor do texto
                    fontFamily: 'Montserrat', // Fonte
                    fontWeight: FontWeight.w600, // Peso da fonte
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
