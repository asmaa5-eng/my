import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart'; // مهم
import 'package:lol/model/user.dart';
import 'package:lol/registration/src/repo/user_repo.dart';
import '../home.dart';
import 'package:lol/profile/profile.dart';

class Signup extends StatefulWidget {
  const Signup({super.key});
  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  final nameC = TextEditingController();
  final emailC = TextEditingController();
  final passC = TextEditingController();

  int? companyId;
  int? managerId;

  bool eye = false;
  bool obscure = true;
  bool loading = false;

  String? imagePath; // مسار الصورة المختارة

  @override
  void dispose() {
    nameC.dispose();
    emailC.dispose();
    passC.dispose();
    super.dispose();
  }

  // اختيار صورة من المعرض
  Future<void> pickImage() async {
    try {
      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
      );
      if (pickedFile != null) {
        setState(() => imagePath = pickedFile.path);
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('تعذّر اختيار الصورة: $e')));
    }
  }

  // يحدد المزوّد المناسب للصورة (أصل/ملف/رابط)
  ImageProvider _avatarProvider() {
    final path = imagePath;
    if (path == null || path.isEmpty) {
      return const AssetImage('assets/beep.jpg');
    }
    if (path.startsWith('assets/')) {
      return AssetImage(path);
    }
    final uri = Uri.tryParse(path);
    if (uri != null && (uri.isScheme('http') || uri.isScheme('https'))) {
      return NetworkImage(path);
    }
    final f = File(path);
    if (f.existsSync()) {
      return FileImage(f);
    }
    return const AssetImage('assets/beep.jpg');
  }

  Future<void> onSignUp() async {
    // (تحققاتك كما هي)

    final draft = User(
      name: nameC.text.trim(),
      email: emailC.text.trim(),
      password: passC.text,
      companyId: companyId!,
      organizationLevelId: 32,
      managerId: managerId!,
      latitude: 29.9880,
      longitude: 31.3400,
      image: imagePath!,
    );

    setState(() => loading = true);
    try {
      await UserRepo().registerUser(draft);
      final created = draft;

      if (!mounted) return;

      // بدّل pushReplacement بـ push
      final updatedUser = await Navigator.push<User>(
        context,
        MaterialPageRoute<User>(builder: (_) => ProfileScreen(user: created)),
      );

      // بعد ما يرجع من ProfileScreen
      if (updatedUser != null) {
        // ممكن تحفظه أو تبعته للسيرفر
      }

      // بعدها تروح على Home وتمنع الرجوع للتسجيل
      if (!mounted) return;
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => const Home()),
        (route) => false,
      );

      if (updatedUser != null) {}
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('فشل التسجيل: $e')));
    } finally {
      if (mounted) setState(() => loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],

      appBar: AppBar(
        title: const Text('Sign Up'),
        backgroundColor: Colors.blue,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 24),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // الصورة
              GestureDetector(
                onTap: pickImage,
                child: Stack(
                  alignment: Alignment.bottomRight,
                  children: [
                    CircleAvatar(
                      radius: 48,
                      backgroundImage: _avatarProvider(),
                    ),
                    const CircleAvatar(
                      radius: 14,
                      backgroundColor: Colors.blue,
                      child: Icon(
                        Icons.camera_alt,
                        size: 16,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Name
              buildTextField(
                controller: nameC,
                label: 'Enter your Name',
                icon: Icons.person,
              ),
              const SizedBox(height: 10),

              // Email
              buildTextField(
                controller: emailC,
                label: 'Enter your email',
                icon: Icons.email,
              ),
              const SizedBox(height: 10),

              // Password
              buildTextField(
                controller: passC,
                label: 'Enter your Password',

                icon: Icons.lock,
                obscure: obscure,
                suffix: IconButton(
                  onPressed: () => setState(() {
                    eye = !eye;
                    obscure = !obscure;
                  }),
                  icon: Icon(
                    eye ? Icons.visibility : Icons.visibility_off,
                    color: Colors.blue,
                  ),
                ),
              ),
              const SizedBox(height: 10),

              // Company dropdown
              buildDropdown(
                value: companyId,
                hint: "choose your company",
                items: companies,
                onChanged: (v) => setState(() => companyId = v),
              ),
              const SizedBox(height: 10),

              // Manager dropdown
              buildDropdown(
                value: managerId,
                hint: "choose your Manager",
                items: managers,
                onChanged: (v) => setState(() => managerId = v),
              ),
              const SizedBox(height: 20),

              // Sign up button
              SizedBox(
                width: 170,
                height: 44,
                child: ElevatedButton(
                  onPressed: loading ? null : onSignUp,
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                  child: Text(
                    loading ? 'جاري الإرسال...' : 'Sign up',
                    style: const TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    bool obscure = false,
    Widget? suffix,
  }) {
    return SizedBox(
      width: 300,
      child: TextField(
        controller: controller,
        obscureText: obscure,
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white,
          labelStyle: const TextStyle(color: Colors.black),
          labelText: label,
          prefixIcon: Icon(
            icon,
            color: const Color.fromARGB(252, 229, 220, 47),
          ),
          suffixIcon: suffix,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 10,
          ),
        ),
      ),
    );
  }

  Widget buildDropdown({
    required int? value,
    required String hint,
    required Map<int, String> items,
    required ValueChanged<int?> onChanged,
  }) {
    return SizedBox(
      width: 300,
      child: DropdownButtonFormField<int>(
        value: value,
        isExpanded: true,
        decoration: InputDecoration(
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 10,
          ),
        ),
        hint: Text(hint),
        items: items.entries
            .map(
              (e) => DropdownMenuItem<int>(value: e.key, child: Text(e.value)),
            )
            .toList(),
        onChanged: onChanged,
      ),
    );
  }
}

// بيانات تجريبية
Map<int, String> companies = {1: 'Company 1', 2: 'Company 2', 3: 'Company 3'};
Map<int, String> managers = {1: 'Manager 1', 2: 'Manager 2', 3: 'Manager 3'};
