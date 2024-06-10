import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Ada Chat Example'),
        ),
        body: Center(
          child: ElevatedButton(
            child: const Text('Open Ada chat'),
            onPressed: () => Navigator.of(context).pushNamed('/ada'),
          ),
        ),
      ),
    );
  }
}
