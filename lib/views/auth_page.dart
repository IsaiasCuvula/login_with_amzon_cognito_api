import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:login_with_amazon_cognito_api/controllers/auth_controller.dart';
import 'package:login_with_amazon_cognito_api/utils/constants.dart';

class AuthPage extends StatefulWidget {
  AuthPage({Key? key}) : super(key: key);

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final AuthController _authController = AuthController();
  bool isLogin = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                isLogin ? 'Login' : 'Register',
                style: kTextStyle(24),
              ),
              TextField(
                controller: _emailController,
                decoration: const InputDecoration(
                  hintText: 'Email',
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  hintText: 'Password',
                ),
              ),
              kVerticalSpace(24),
              isLogin ? _login() : _register(),
              TextButton(
                onPressed: () {
                  setState(() {
                    isLogin = !isLogin;
                  });
                },
                child: Text(
                  isLogin
                      ? "Do not have account? Register here"
                      : "Already have account? Login here",
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _login() {
    return ElevatedButton(
      onPressed: _validateData,
      child: const Text('Login'),
    );
  }

  Widget _register() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ElevatedButton(
          onPressed: _validateData,
          child: const Text('Register'),
        ),
        kVerticalSpace(24),
        _registerOptions(),
      ],
    );
  }

  void _validateData() {
    if (_emailController.text.isNotEmpty &&
        _passwordController.text.isNotEmpty) {
      final String email = _emailController.text.trim();
      final String password = _passwordController.text.trim();
      if (isLogin) {
        _authController.login(email, password);
      } else {
        _authController.registerAccount(email, password);
      }
    }
  }

  Widget _registerOptions() {
    return Column(
      children: [
        Text(
          'Or register using',
          style: kTextStyle(22),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            IconButton(
              onPressed: () {},
              icon: const FaIcon(FontAwesomeIcons.amazon, size: 26),
            ),
            IconButton(
              onPressed: () {},
              icon: const FaIcon(FontAwesomeIcons.apple, size: 28),
            ),
            IconButton(
              onPressed: () {},
              icon: const FaIcon(FontAwesomeIcons.google),
            ),
            IconButton(
              onPressed: () {},
              icon: const FaIcon(FontAwesomeIcons.facebook),
            )
          ],
        ),
      ],
    );
  }
}
