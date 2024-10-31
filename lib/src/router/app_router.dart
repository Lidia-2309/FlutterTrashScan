import 'dart:io';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../pages/home_page.dart';
import '../pages/detect_page.dart';
import '../pages/detect_results_page.dart';

class AppRouter {
  static final router = GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const HomePage(),
      ),
      GoRoute(
        path: '/detect',
        builder: (context, state) => const DetectPage(),
      ),
      GoRoute(
        path: '/detect-results',
        builder: (context, state) {
          // Recupera o argumento passado ao navegar para esta página
          final args = state.extra as Map<String, dynamic>?;
          final image = args?['image'] as File?;
          final detections = args?['detections'] as List<Map<String, dynamic>>? ?? [];
          return DetectResultsPage(
            image: image,
            detections: detections,
          );
        },
      ),
    ],
  );
}
