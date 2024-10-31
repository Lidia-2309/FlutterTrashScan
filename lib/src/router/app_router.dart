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
        builder: (context, state) => const DetectResultsPage(),
      ),
    ],
  );
}
