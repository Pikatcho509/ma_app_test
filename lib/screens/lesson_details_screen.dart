import 'package:flutter/material.dart';

class LessonDetailsScreen extends StatelessWidget {
  const LessonDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Détails de la leçon')),
      body: const Center(
        child: Text("Informations sur la leçon — placeholder"),
      ),
    );
  }
}
