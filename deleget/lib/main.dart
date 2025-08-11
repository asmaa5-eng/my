import 'package:flutter/material.dart';
import 'package:lol/sign_in/sing_in.dart';
import 'package:lol/profile/profile.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter simple app',
      home: SignInScreen(),
    );
  }
}
