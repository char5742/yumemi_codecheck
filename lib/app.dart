import 'package:flutter/material.dart';
import 'package:yumemi_codecheck/pages/top.dart';

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(context) {
    return MaterialApp(
      theme: ThemeData(
          useMaterial3: true, colorSchemeSeed: const Color(0xFF38d18c)),
      darkTheme: ThemeData(
          useMaterial3: true,
          colorSchemeSeed: const Color(0xFF38d18c),
          brightness: Brightness.dark),
      home: const TopPage(),
    );
  }
}
