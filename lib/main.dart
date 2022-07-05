import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:login_with_amazon_cognito_api/controllers/auth_controller.dart';
import 'package:login_with_amazon_cognito_api/views/auth_page.dart';
import 'package:login_with_amazon_cognito_api/views/home_page.dart';
import 'package:login_with_amazon_cognito_api/views/verification_page.dart';

import 'amplifyconfiguration.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final AuthController _authController = Get.put(AuthController());
  bool _isConfigured = false;

  @override
  void initState() {
    _configureAmplify();
    super.initState();
  }

  Future<void> _configureAmplify() async {
    try {
      if (!Amplify.isConfigured) {
        await Amplify.addPlugin(AmplifyAuthCognito());
        await Amplify.configure(amplifyconfig);
      }
      setState(() {
        _isConfigured = true;
      });
    } on Exception catch (e) {
      print('An error occurred configuring Amplify: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Login Demo',
      theme: ThemeData(
        primarySwatch: Colors.amber,
      ),
      home: FutureBuilder<bool>(
        future: _authController.isUserSignedIn(),
        builder: (_, snapshot) {
          if (snapshot.hasData) {
            return snapshot.data == true
                ? HomePage()
                : _verifyIfAmplifyIsConfigured();
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }

  Widget _verifyIfAmplifyIsConfigured() {
    return _isConfigured
        ? AuthPage()
        : const Center(
            child: CircularProgressIndicator(),
          );
  }
}
