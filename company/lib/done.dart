import 'package:flutter/material.dart';

class Done extends StatelessWidget {
  const Done({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Done')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircleAvatar(
              radius: 100,
              backgroundImage: AssetImage(
                'asset/Artboard 1.png',
              ), // صورة من assets
            ),
            const SizedBox(height: 30),
            Text(
              'Your order has been placed successfully!',
              style: TextStyle(fontSize: 20, color: Colors.green),
            ),
          ],
        ),
      ),
    );
  }
}
