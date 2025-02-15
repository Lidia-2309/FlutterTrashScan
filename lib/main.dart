import 'package:flutter/material.dart';
import 'package:trashscanflutter/src/router/app_router.dart';
import 'package:trashscanflutter/src/themes/theme.dart';
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'TrashScan',
      theme: appTheme,
      routerConfig: AppRouter.router,
    );
  }
}