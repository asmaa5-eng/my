import 'package:flutter/material.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        backgroundColor: Colors.blue,
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 50,
              backgroundImage: AssetImage('assets/beep.jpg'),
            ),
            SizedBox(height: 20.0),
            Text(
              'Welcome to the Home Page!',
              style: TextStyle(fontSize: 24, color: Colors.blue),
            ),
          ],
        ),
      ),
    );
  }
}
