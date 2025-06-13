import 'package:flutter/material.dart';
import 'package:todolist/const/colors.dart';
import 'package:todolist/data/auth_data.dart';

class Login_Screen extends StatefulWidget {
  final VoidCallback show;
  final VoidCallback onLoginSuccess;

  const Login_Screen(this.show, {required this.onLoginSuccess, super.key});

  @override
  State<Login_Screen> createState() => _Login_ScreenState();
}

class _Login_ScreenState extends State<Login_Screen> {
  final email = TextEditingController();
  final password = TextEditingController();

  final FocusNode _focusEmail = FocusNode();
  final FocusNode _focusPassword = FocusNode();

  @override
  void initState() {
    super.initState();
    _focusEmail.addListener(() => setState(() {}));
    _focusPassword.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    email.dispose();
    password.dispose();
    _focusEmail.dispose();
    _focusPassword.dispose();
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
                    // Bagian Form
                    Expanded(
                      flex: 5,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Welcome back to Nyatet",
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.w800,
                              color: Color(0xFFC7CB5F),
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            "Nyatet is a to-do list app that helps you organize, record, and complete your daily tasks efficiently and enjoyably.",
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
                          const SizedBox(height: 24),
                          _buildLoginButton(),
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              Text(
                                "Don't have an account? ",
                                style: TextStyle(color: Color(0xFF7A7A3A)),
                              ),
                              GestureDetector(
                                onTap: widget.show,
                                child: const Text(
                                  "Register here",
                                  style: TextStyle(
                                    color: Colors.blue,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              )
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

                    // Bagian Gambar
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

  Widget _buildLoginButton() {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Color(0xFFC7CB5F),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        onPressed: () async {
          if (email.text.isEmpty || password.text.isEmpty) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Please enter your email and password!')),
            );
            return;
          }

          bool success = await AuthenticationRemote().login(
            email.text.trim(),
            password.text.trim(),
          );

          if (success) {
            widget.onLoginSuccess();
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Login failed! Incorrect email or password.')),
            );
          }
        },
        child: const Text(
          'Login',
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
