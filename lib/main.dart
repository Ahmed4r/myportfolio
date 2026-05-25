import 'package:flutter/material.dart';
import 'package:myportfolio/home_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ahmed Hegazy Portfolio',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        useMaterial3: true,
        fontFamily: 'Inter',
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xff027DFD),
          brightness: Brightness.dark,
          surface: const Color(0xff040D21),
        ),
      ),
      home: const HomePage(),
    );
  }
}
