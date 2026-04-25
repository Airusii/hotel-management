import 'package:flutter/material.dart';

class MyReviewsScreen extends StatelessWidget {
  const MyReviewsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Мои отзывы')),
      body: const Center(child: Text('Здесь можно увидеть отзывы, которые вы оставили')),
    );
  }
}