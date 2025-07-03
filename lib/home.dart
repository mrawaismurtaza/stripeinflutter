import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Stripe in Flutter'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'Welcome to Stripe in Flutter!',
            ),
            ElevatedButton(
              onPressed: () {
                // Navigate to the payment screen or perform an action
              },
              child: const Text('Make a Payment'),
            ),
          ],
        ),
      ),
    );
  }
}