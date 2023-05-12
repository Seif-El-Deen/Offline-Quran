import 'package:flutter/material.dart';
import 'package:quran_kareem/screens/home_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'القرآن الكريم ',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.green, fontFamily: "ReemKufi"),
      home: const HomeScreen(),
    );
  }
}
