import 'package:flutter/material.dart';

class Versionpage extends StatelessWidget {
  const Versionpage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Version'),
      ),
      body: const Center(
        child: Text('version: 1.1.1'),
      ),
    );
  }
}
