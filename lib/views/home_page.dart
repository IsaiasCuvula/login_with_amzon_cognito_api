import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:login_with_amazon_cognito_api/controllers/auth_controller.dart';
import 'package:login_with_amazon_cognito_api/utils/constants.dart';

class HomePage extends StatelessWidget {
  HomePage({Key? key}) : super(key: key);
  final AuthController _authController = Get.put(AuthController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Amazon Cognito'),
        actions: [
          IconButton(
            onPressed: () {
              _authController.logOut();
            },
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Center(
          child: Text(
            'Hello World 👋🏾',
            style: kTextStyle(26),
          ),
        ),
      ),
    );
  }
}
