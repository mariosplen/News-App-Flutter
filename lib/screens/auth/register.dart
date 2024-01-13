import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import 'package:flutter_news_app/screens/auth/logo.dart';
import 'package:flutter_news_app/screens/auth/validators.dart';
import 'package:flutter_news_app/services/firestore_service.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key, required this.toggleAuthScreen});

  final void Function() toggleAuthScreen;

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  var _isLoading = false; // Used for the spinner
  var _isPassHiden = true; // Used to toggle password visibility
  var _isConfirmPassHiden = true;
  var _name = '';
  var _email = '';
  var _password = '';

  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  // Form submit
  Future<void> _submit() async {
    if (_isLoading) {
      return;
    }

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
      final user = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _email,
        password: _password,
      );

      Random random = Random();
      int randomIndex = random.nextInt(100);

      await FirestoreService().registerUser(user.user!.uid, _name, _email, [],
          'https://picsum.photos/id/$randomIndex/900/900');

      // showAlert('New user ${user.user!.email} created');
    } catch (e) {
      // Show error message
      showAlert(e.toString());
    } finally {
      // Stop spinner
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void showAlert(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }

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
                      validator: (value) {
                        if (value == null || value.length < 2) {
                          return 'Name must be at least 2 characters long';
                        }
                        return null;
                      },
                      controller: _nameController,
                      onSaved: (newValue) {
                        _name = newValue!;
                      },
                      autocorrect: true,
                      keyboardType: TextInputType.name,
                      textCapitalization: TextCapitalization.words,
                      decoration: const InputDecoration(
                        labelText: 'Name',
                        prefixIcon: Icon(Icons.person),
                      ),
                    ),
                    TextFormField(
                      validator: validateEmail,
                      controller: _emailController,
                      onSaved: (newValue) {
                        _email = newValue!;
                      },
                      autocorrect: false,
                      keyboardType: TextInputType.emailAddress,
                      textCapitalization: TextCapitalization.none,
                      decoration: const InputDecoration(
                        labelText: 'Email',
                        prefixIcon: Icon(Icons.email),
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
                    TextFormField(
                      controller: _confirmPasswordController,
                      validator: (value) {
                        if (value == null ||
                            value.isEmpty ||
                            value != _passwordController.text) {
                          return 'Passwords do not match';
                        }
                        return null;
                      },
                      autocorrect: false,
                      textCapitalization: TextCapitalization.none,
                      obscureText: _isConfirmPassHiden,
                      decoration: InputDecoration(
                        labelText: 'Confirm Password',
                        prefixIcon: const Icon(Icons.lock),
                        suffixIcon: InkWell(
                          onTap: () {
                            setState(() {
                              _isConfirmPassHiden = !_isConfirmPassHiden;
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
                          backgroundColor:
                              Theme.of(context).colorScheme.primary,
                        ),
                        child: _isLoading
                            ? const SizedBox(
                                height: 24,
                                width: 24,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                ))
                            : const Text(
                                'CREATE ACCOUNT',
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold),
                              )),
                    const SizedBox(height: 24),
                    RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        text: 'Already have an account? ',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onBackground,
                          fontSize: 16,
                        ),
                        children: [
                          TextSpan(
                            text: 'Sign in',
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
                    const SizedBox(
                      height: 20,
                    )
                  ]),
            ),
          ),
        ),
      ),
    );
  }
}
