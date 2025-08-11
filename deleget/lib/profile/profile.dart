import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lol/model/user.dart';

class ProfileScreen extends StatefulWidget {
  final User user;
  final void Function(User)? onProfileUpdated; // ← اختياري

  const ProfileScreen({
    super.key,
    required this.user,
    this.onProfileUpdated, // ← لم يعد required
  });

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  void saveProfile() {
    final updatedUser = widget.user.copyWith(
      name: nameController.text.trim(),
      email: emailController.text.trim(),
      password: passwordController.text,
      image: imagePath,
    );

    // ارجاع النتيجة لمنادِي الشاشة
    Navigator.pop(context, updatedUser);
  }

  late TextEditingController nameController;
  late TextEditingController emailController;
  late TextEditingController passwordController;
  late String imagePath;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.user.name);
    emailController = TextEditingController(text: widget.user.email);
    passwordController = TextEditingController(text: widget.user.password);
    imagePath = widget.user.image; // قد تكون Asset/File/URL
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future<void> pickProfileImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );
    if (picked != null) {
      setState(() {
        imagePath = picked.path; // لا تعيده إلى Asset بعد الاختيار
      });
    }
  }

  ImageProvider _avatarProvider() {
    if (imagePath.isEmpty) {
      return const AssetImage('assets/beep.jpg');
    }
    if (imagePath.startsWith('assets/')) {
      return AssetImage(imagePath);
    }
    final uri = Uri.tryParse(imagePath);
    if (uri != null &&
        uri.hasScheme &&
        (uri.isScheme('http') || uri.isScheme('https'))) {
      return NetworkImage(imagePath);
    }
    final f = File(imagePath);
    if (f.existsSync()) {
      return FileImage(f);
    }
    return const AssetImage('assets/beep.jpg');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],

      appBar: AppBar(
        title: const Text('My Profile'),
        backgroundColor: Colors.blue,
        centerTitle: true,
        actions: [
          IconButton(icon: const Icon(Icons.save), onPressed: saveProfile),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            GestureDetector(
              onTap: pickProfileImage,
              child: CircleAvatar(
                radius: 60,
                backgroundImage: _avatarProvider(),
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: 'Name',
                prefixIcon: Icon(Icons.person),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: emailController,
              decoration: const InputDecoration(
                labelText: 'Email',
                prefixIcon: Icon(Icons.email),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Password',
                prefixIcon: Icon(Icons.lock),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: saveProfile,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                padding: const EdgeInsets.symmetric(
                  horizontal: 50,
                  vertical: 15,
                ),
              ),
              child: const Text(
                'Save',
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
