import 'package:flutter/material.dart';
import 'package:todolist/const/colors.dart';
import 'package:todolist/data/auth_data.dart';

class Sign_Up_Screen extends StatefulWidget {
  final VoidCallback show;
  final VoidCallback onSignUpSuccess;

  const Sign_Up_Screen(this.show, {super.key, required this.onSignUpSuccess});

  @override
  State<Sign_Up_Screen> createState() => _Sign_Up_ScreenState();
}

class _Sign_Up_ScreenState extends State<Sign_Up_Screen> {
  final email = TextEditingController();
  final password = TextEditingController();
  final confirmPassword = TextEditingController();

  final FocusNode _focusEmail = FocusNode();
  final FocusNode _focusPassword = FocusNode();
  final FocusNode _focusConfirm = FocusNode();

  @override
  void initState() {
    super.initState();
    _focusEmail.addListener(() => setState(() {}));
    _focusPassword.addListener(() => setState(() {}));
    _focusConfirm.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    email.dispose();
    password.dispose();
    confirmPassword.dispose();
    _focusEmail.dispose();
    _focusPassword.dispose();
    _focusConfirm.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Color(0xFFFCFBDB),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              child: Container(
                margin: const EdgeInsets.all(24),
                padding: const EdgeInsets.all(32),
                constraints: const BoxConstraints(maxWidth: 1000),
                decoration: BoxDecoration(
                  color: Color(0xFFFAF5B4).withOpacity(0.7),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(color: Color(0xFFF6DE77).withOpacity(0.18), blurRadius: 12),
                  ],
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Form Pendaftaran
                    Expanded(
                      flex: 5,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Sign Up to Nyatet",
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.w800,
                              color: Color(0xFFC7CB5F),
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            "Create an account to start organizing and managing your daily activities easily and efficiently.",
                            style: TextStyle(
                              fontSize: 14,
                              color: Color(0xFF7A7A3A),
                            ),
                          ),
                          const SizedBox(height: 24),
                          _buildTextField(
                            controller: email,
                            focusNode: _focusEmail,
                            label: "Email Address",
                            icon: Icons.email,
                          ),
                          const SizedBox(height: 16),
                          _buildTextField(
                            controller: password,
                            focusNode: _focusPassword,
                            label: "Password",
                            icon: Icons.lock,
                          ),
                          const SizedBox(height: 16),
                          _buildTextField(
                            controller: confirmPassword,
                            focusNode: _focusConfirm,
                            label: "Confirm Password",
                            icon: Icons.lock_outline,
                          ),
                          const SizedBox(height: 24),
                          _buildRegisterButton(),
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              Text("Already have an account? ",
                                  style: TextStyle(color: Color(0xFF7A7A3A))),
                              GestureDetector(
                                onTap: widget.show,
                                child: const Text(
                                  "Login here",
                                  style: TextStyle(
                                    color: Colors.blue,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    // Garis pembatas vertikal
                    Container(
                      width: 1.2,
                      height: 320,
                      margin: const EdgeInsets.symmetric(horizontal: 18),
                      color: Color(0xFFC7CB5F),
                    ),

                    // Gambar Ilustrasi
                    Expanded(
                      flex: 5,
                      child: Image.asset(
                        'images/7.png',
                        fit: BoxFit.contain,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRegisterButton() {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Color(0xFFC7CB5F),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        onPressed: () async {
          final emailText = email.text.trim();
          final passText = password.text.trim();
          final confirmText = confirmPassword.text.trim();

          if (emailText.isEmpty || passText.isEmpty || confirmText.isEmpty) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("All fields must be filled.")),
            );
            return;
          }

          if (passText != confirmText) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Passwords do not match.")),
            );
            return;
          }

          bool success = await AuthenticationRemote().register(
            emailText,
            passText,
            confirmText,
          );

          if (success) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Registration successful!")),
            );
            widget.onSignUpSuccess();
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Registration failed. Please try again.")),
            );
          }
        },
        child: const Text(
          'Sign Up',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required FocusNode focusNode,
    required String label,
    required IconData icon,
  }) {
    return TextField(
      controller: controller,
      focusNode: focusNode,
      obscureText: label.toLowerCase().contains('password'),
      decoration: InputDecoration(
        prefixIcon: Icon(
          icon,
          color: focusNode.hasFocus ? Color(0xFFC7CB5F) : Color(0xFFF6DE77),
        ),
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        filled: true,
        fillColor: Color(0xFFFCFBDB),
      ),
    );
  }
}
