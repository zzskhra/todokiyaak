import 'package:flutter/material.dart';
import 'package:todolist/screen/SingUP.dart'; // ✅ file dan class: Sign_Up_Screen
import 'package:todolist/screen/login.dart';
import 'package:todolist/screen/home.dart'; // ✅ halaman tujuan setelah login/signup

class Auth_Page extends StatefulWidget {
  const Auth_Page({super.key});

  @override
  State<Auth_Page> createState() => _Auth_PageState();
}

class _Auth_PageState extends State<Auth_Page> {
  bool showLogin = true;

  void toggle() {
    setState(() {
      showLogin = !showLogin;
    });
  }

  void navigateToHome() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const Home_Screen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return showLogin
        ? Login_Screen(
            toggle,
            onLoginSuccess: navigateToHome,
          )
        : Sign_Up_Screen(
            toggle,
            onSignUpSuccess: navigateToHome,
          );
  }
}
