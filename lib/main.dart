import 'package:flutter/material.dart';
// provider import is reserved for future state management implementation

void main() {
  runApp(const AutohelmApp());
}

class AutohelmApp extends StatelessWidget {
  const AutohelmApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Autohelm Remote',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Autohelm Remote'),
      ),
      body: const Center(
        child: Text(
          'Autohelm App - Ready for development',
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
