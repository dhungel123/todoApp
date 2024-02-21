import 'package:flutter/material.dart';

class InvalidScreen extends StatelessWidget {
  const InvalidScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.yellow,
      body: Center(child: Text('Invalid Screen')),
    );
  }
}
