import 'package:flutter/material.dart';

class Sharethis extends StatelessWidget {
  const Sharethis({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Share This App'),
      ),
      body: const Center(child: Text('share this'),),
    );
  }
}