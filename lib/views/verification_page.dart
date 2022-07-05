import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/auth_controller.dart';
import '../utils/constants.dart';

class VerificationPage extends StatelessWidget {
  VerificationPage({Key? key, required this.email}) : super(key: key);

  final String email;
  final TextEditingController _codeController = TextEditingController();
  final AuthController _authController = Get.put(AuthController());

  @override
  Widget build(BuildContext context) {
    //final currentUser = _authController.getCurrentUser();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Verification'),
      ),
      body: Container(
        width: Get.width,
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              "We've sent verification code to $email ",
              style: kTextStyle(20),
            ),
            kVerticalSpace(10),
            TextField(
              controller: _codeController,
              decoration: const InputDecoration(
                hintText: 'Verification code',
              ),
            ),
            kVerticalSpace(24),
            ElevatedButton(
              onPressed: _verify,
              child: Text('Verify', style: kTextStyle(18)),
            ),
            kVerticalSpace(24),
            Row(
              children: [
                Text(
                  "Didn't receive verification code?",
                  style: kTextStyle(15),
                ),
                Expanded(
                  child: TextButton(
                    onPressed: _resendVerificationCode,
                    child: Text('Resend', style: kTextStyle(18)),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _resendVerificationCode() {
    _authController.resendVerificationCode(email);
  }

  void _verify() {
    if (_codeController.text.trim().isNotEmpty) {
      final code = _codeController.text.trim();
      _authController.verifyUser(email, code);
    }
  }
}
