import 'package:flutter/material.dart';
import 'package:flutter_news_app/screens/auth/login.dart';
import 'package:flutter_news_app/screens/auth/register.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  // Used to toggle between login and signup
  var _isLoginMode = true;

  void _toggleAuthScreen() {
    setState(() {
      _isLoginMode = !_isLoginMode;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isLoginMode
          ? LoginScreen(toggleAuthScreen: _toggleAuthScreen)
          : RegisterScreen(toggleAuthScreen: _toggleAuthScreen),
    );
  }
}
