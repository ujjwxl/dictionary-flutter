// ignore_for_file: prefer_const_constructors

import 'package:dict/views/home_page.dart';
import 'package:dict/views/splash_screen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/', // Set initial route
      routes: {
        '/': (context) => const SplashScreen(),
        '/home': (context) => HomePage(),
      },
    );
  }
}
