import 'package:flutter/material.dart';
import 'emp.dart';

List<Emp> ems = [];

class Regesr extends StatefulWidget {
  const Regesr({super.key});

  @override
  State<Regesr> createState() => _RegesrState();
}

class _RegesrState extends State<Regesr> {
  final nameC = TextEditingController();
  final nameM = TextEditingController();
  final emailC = TextEditingController();
  final passC = TextEditingController();
  int mynumber = 0;
  bool eye = false;
  bool obscure = true;

  @override
  void dispose() {
    nameC.dispose();
    nameM.dispose();
    emailC.dispose();
    passC.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const CircleAvatar(
                radius: 40,
                backgroundImage: AssetImage('asset/Artboard 1.png'),
              ),
              const SizedBox(height: 20),

              _buildTextField(nameC, 'Enter Company Name', Icons.business),
              const SizedBox(height: 20),

              _buildTextField(nameM, 'Enter Admin Name', Icons.person),
              const SizedBox(height: 20),

              _buildTextField(emailC, 'Enter Admin Email', Icons.email),
              const SizedBox(height: 20),

              _buildPasswordField(),
              const SizedBox(height: 20),

              // اللوب لعرض الموظفين
              for (int i = 1; i <= mynumber; i++)
                EmpsInfo(
                  employeeNumber: i,
                  onSave: (state, level) {
                    ems.add(Emp(state: state, level: level));
                  },
                ),

              const SizedBox(height: 20),

              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.yellow[700],
                  foregroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () {
                  setState(() {
                    mynumber++;
                  });
                },
                icon: const Icon(Icons.add),
                label: const Text(
                  "إضافة موظف جديد",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
    TextEditingController controller,
    String label,
    IconData icon,
  ) {
    return SizedBox(
      width: 300,
      height: 45,
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white,
          labelText: label,
          prefixIcon: Icon(icon, color: Colors.yellow[700]),
          labelStyle: const TextStyle(color: Colors.black),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }

  Widget _buildPasswordField() {
    return SizedBox(
      width: 300,
      height: 45,
      child: TextField(
        controller: passC,
        obscureText: obscure,
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white,
          labelText: 'Enter your Password',
          prefixIcon: Icon(Icons.lock, color: Colors.yellow[700]),
          suffixIcon: IconButton(
            onPressed: () => setState(() {
              eye = !eye;
              obscure = !obscure;
            }),
            icon: Icon(
              eye ? Icons.visibility : Icons.visibility_off,
              color: Colors.black,
            ),
          ),
          labelStyle: const TextStyle(color: Colors.black),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }
}

class EmpsInfo extends StatefulWidget {
  final int employeeNumber;
  final Function(String, int) onSave;

  const EmpsInfo({
    super.key,
    required this.employeeNumber,
    required this.onSave,
  });

  @override
  State<EmpsInfo> createState() => _EmpsInfoState();
}

class _EmpsInfoState extends State<EmpsInfo> {
  final empsname = TextEditingController();
  final empslevel = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: 300,
          height: 45,
          child: TextField(
            controller: empsname,
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.white,
              labelText: 'Employee Name',
              prefixIcon: Icon(Icons.person, color: Colors.yellow[700]),
              labelStyle: const TextStyle(color: Colors.black),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ),
        const SizedBox(height: 15),
        SizedBox(
          width: 300,
          height: 45,
          child: TextField(
            controller: empslevel,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.white,
              labelText: 'Employee Level',
              prefixIcon: Icon(Icons.grade, color: Colors.yellow[700]),
              labelStyle: const TextStyle(color: Colors.black),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
            ),
            onSubmitted: (value) {
              widget.onSave(empsname.text, int.tryParse(value) ?? 0);
            },
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}
