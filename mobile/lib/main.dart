import 'package:flutter/material.dart';

import 'screens/auth/login_screen.dart';

void main() {
  runApp(const AcessibilizandoApp());
}

class AcessibilizandoApp extends StatelessWidget {
  const AcessibilizandoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Acessibilizando',
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.blue,
      ),
      home: const LoginScreen(),
    );
  }
}