import 'package:flutter/material.dart';
import '../registration/signup.dart';
import '../home.dart';
import '../model/user.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  // controllers
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  late User user;

  bool eye = false;
  bool isPasswordHidden = true;

  @override
  void initState() {
    super.initState();
    user = User(
      name: '',
      email: '',
      password: '',
      companyId: 0,
      organizationLevelId: 0,
      managerId: 0,
      latitude: 0.0,
      longitude: 0.0,
      image: '',
    );
  }

  void onSignIn() {
    user.email = emailController.text.trim();
    user.password = passwordController.text;

    Navigator.push(context, MaterialPageRoute(builder: (context) => Home()));
  }

  Future<void> goToSignUp() async {
    final updated = await Navigator.push<User?>(
      context,
      MaterialPageRoute(builder: (context) => Signup()),
    );

    if (updated != null) {
      setState(() {
        user = updated;
        emailController.text = user.email;
        passwordController.text = user.password;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],

      appBar: AppBar(
        title: const Text('sign in'),
        backgroundColor: Colors.blue,
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircleAvatar(
              radius: 50,
              backgroundImage: AssetImage('assets/beep.jpg'),
            ),
            const SizedBox(height: 20.0),

            // Email
            SizedBox(
              width: 300.0,
              height: 60.0,
              child: TextField(
                controller: emailController,
                onChanged: (v) => user.email = v.trim(),
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  labelStyle: const TextStyle(color: Colors.black),
                  labelText: 'Enter your email',
                  hintText: 'example@gmail.com',
                  prefixIcon: Icon(
                    Icons.email,
                    color: Color.fromARGB(252, 229, 220, 47),
                  ),
                ),
              ),
            ),

            // Password
            SizedBox(
              width: 300.0,
              height: 60.0,
              child: TextField(
                controller: passwordController,
                onChanged: (v) => user.password = v,
                obscureText: isPasswordHidden,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  labelStyle: const TextStyle(color: Colors.black),
                  labelText: 'Enter your Password',
                  prefixIcon: const Icon(
                    Icons.lock,
                    color: Color.fromARGB(252, 229, 220, 47),
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(
                      eye ? Icons.visibility : Icons.visibility_off,
                      color: Colors.blue,
                    ),
                    onPressed: () {
                      setState(() {
                        eye = !eye;
                        isPasswordHidden = !isPasswordHidden;
                      });
                    },
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20.0),

            ElevatedButton(
              onPressed: onSignIn,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                padding: const EdgeInsets.symmetric(
                  horizontal: 50,
                  vertical: 15,
                ),
              ),
              child: const Text(
                'Sign in',
                style: TextStyle(fontSize: 20, color: Colors.white),
              ),
            ),

            const SizedBox(height: 20.0),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Don't have an account?",
                  style: TextStyle(
                    fontSize: 10,
                    color: Color.fromARGB(255, 179, 179, 180),
                  ),
                ),
                TextButton(
                  onPressed: goToSignUp,
                  child: const Text(
                    'Sign Up',
                    style: TextStyle(fontSize: 12, color: Colors.blue),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
