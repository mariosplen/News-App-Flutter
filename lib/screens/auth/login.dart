import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import 'package:flutter_news_app/screens/auth/logo.dart';
import 'package:flutter_news_app/screens/auth/validators.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key, required this.toggleAuthScreen});

  final void Function() toggleAuthScreen;

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  var _isLoading = false; // Used for the spinner
  var _isPassHiden = true; // Used to toggle password visibility
  var _email = '';
  var _password = '';

  String? _errorMsg;

  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Logo(),
                    TextFormField(
                      validator: validateEmail,
                      controller: _emailController,
                      onSaved: (newValue) {
                        _email = newValue!;
                      },
                      autocorrect: false,
                      keyboardType: TextInputType.emailAddress,
                      textCapitalization: TextCapitalization.none,
                      decoration: InputDecoration(
                        labelText: 'Email',
                        errorText: _errorMsg,
                        prefixIcon: const Icon(Icons.email),
                      ),
                    ),
                    TextFormField(
                      controller: _passwordController,
                      validator: (value) {
                        if (value == null || value.length < 8) {
                          return 'Password must be at least 8 characters long';
                        }
                        return null;
                      },
                      onSaved: (newValue) {
                        _password = newValue!;
                      },
                      autocorrect: false,
                      textCapitalization: TextCapitalization.none,
                      obscureText: _isPassHiden,
                      decoration: InputDecoration(
                        labelText: 'Password',
                        errorText: _errorMsg,
                        prefixIcon: const Icon(Icons.lock),
                        suffixIcon: InkWell(
                          onTap: () {
                            setState(() {
                              _isPassHiden = !_isPassHiden;
                            });
                          },
                          child: const Icon(Icons.visibility),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: _submit,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        foregroundColor:
                            Theme.of(context).colorScheme.onPrimary,
                        backgroundColor: Theme.of(context).colorScheme.primary,
                      ),
                      child: _isLoading
                          ? const SizedBox(
                              height: 24,
                              width: 24,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                              ))
                          : const Text(
                              'LOG IN',
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                    ),
                    const SizedBox(height: 24),
                    RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        text: 'Don\'t have an account? ',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onBackground,
                          fontSize: 16,
                        ),
                        children: [
                          TextSpan(
                            text: 'Create',
                            recognizer: TapGestureRecognizer()
                              ..onTap = widget.toggleAuthScreen,
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.primary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ]),
            ),
          ),
        ),
      ),
    );
  }

  // Form submit
  Future<void> _submit() async {
    if (_isLoading) {
      return;
    }
    setState(() {
      _errorMsg = null; // Clear error message
    });

    // Validate form
    final isValid = _formKey.currentState!.validate();
    FocusScope.of(context).unfocus();

    if (!isValid) {
      return;
    }

    // Copy to variables if form is valid
    _formKey.currentState!.save();

    try {
      // Start spinner
      setState(() {
        _isLoading = true;
      });

      // Sign user up
      final user = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _email,
        password: _password,
      );

      showAlert('Welcome back ${user.user!.email} !');
    } catch (e) {
      // Show error message
      if (e is FirebaseAuthException) {
        if (e.code == 'invalid-credential') {
          setState(() {
            _errorMsg = 'Invalid Email or Password';
          });
        } else {
          showAlert(e.code);
        }
      }
    } finally {
      // Stop spinner
      setState(() {
        _isLoading = false;
      });
    }
  }

  void showAlert(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }
}
