import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:get/get.dart';
import 'package:login_with_amazon_cognito_api/views/auth_page.dart';
import 'package:login_with_amazon_cognito_api/views/home_page.dart';
import 'package:login_with_amazon_cognito_api/views/verification_page.dart';

class AuthController extends GetxController {
  var isUserLoggedIn = false.obs;

  Future<bool> isUserSignedIn() async {
    final result = await Amplify.Auth.fetchAuthSession();
    return result.isSignedIn;
  }

  void registerAccount(String email, String password) async {
    try {
      await Amplify.Auth.signUp(
        username: email,
        password: password,
        options: CognitoSignUpOptions(userAttributes: {
          CognitoUserAttributeKey.email: email,
        }),
      ).then((value) {
        Get.to(
          () => VerificationPage(email: email),
          transition: Transition.circularReveal,
          duration: const Duration(milliseconds: 500),
        );
      });
    } on AmplifyException catch (e) {
      Get.snackbar('Error', e.message, snackPosition: SnackPosition.BOTTOM);
    }
  }

  void login(String email, String password) async {
    try {
      await Amplify.Auth.signIn(
        username: email,
        password: password,
      ).then((value) {
        Get.offAll(
          () => HomePage(),
          transition: Transition.circularReveal,
          duration: const Duration(milliseconds: 500),
        );
      });
    } on UserNotConfirmedException catch (e) {
      if (e.message == "User is not confirmed.") {
        Get.to(
          () => VerificationPage(email: email),
          transition: Transition.circularReveal,
          duration: const Duration(milliseconds: 500),
        );
      }
    } on AmplifyException catch (e) {
      Get.snackbar('Error', e.message, snackPosition: SnackPosition.BOTTOM);
    }
  }

  Future<void> verifyUser(String email, String code) async {
    try {
      await Amplify.Auth.confirmSignUp(
        username: email,
        confirmationCode: code,
      ).then((value) {
        if (value.isSignUpComplete) {
          Get.offAll(
            () => HomePage(),
            transition: Transition.circularReveal,
            duration: const Duration(milliseconds: 500),
          );
        }
      });
    } on AmplifyException catch (e) {
      Get.snackbar('Error', e.message, snackPosition: SnackPosition.BOTTOM);
    }
  }

  void logOut() async {
    try {
      await Amplify.Auth.signOut().then((value) {
        Get.offAll(
          () => AuthPage(),
          transition: Transition.circularReveal,
          duration: const Duration(milliseconds: 500),
        );
      });
    } on AmplifyException catch (e) {
      Get.snackbar('Error', e.message, snackPosition: SnackPosition.BOTTOM);
    }
  }

  Future<AuthUser> getCurrentUser() async {
    final user = await Amplify.Auth.getCurrentUser();
    return user;
  }

  Future<void> resendVerificationCode(String email) async {
    try {
      final result = await Amplify.Auth.resendSignUpCode(
        username: email,
      );
      result.codeDeliveryDetails.destination;
    } on AmplifyException catch (e) {
      Get.snackbar('Error', e.message, snackPosition: SnackPosition.BOTTOM);
    }
  }

  // Future<void> fetchCurrentUserAttributes() async {
  //   try {
  //     final result = await Amplify.Auth.fetchUserAttributes();
  //     for (final element in result) {
  //       if ('${element.userAttributeKey}' == 'email') {}
  //       username.value = element.value;
  //       //print('key: ${element.userAttributeKey}; value: ${element.value}');
  //       print('value: ${username}');
  //     }
  //   } catch (e) {
  //     print('DEBUG: error:$e');
  //   }
  // }

  // Future<void> updateUserAttribute(String email) async {
  //   try {
  //     final result = await Amplify.Auth.updateUserAttribute(
  //       userAttributeKey: CognitoUserAttributeKey.email,
  //       value: email,
  //     );
  //
  //     if (result.nextStep.updateAttributeStep ==
  //         'CONFIRM_ATTRIBUTE_WITH_CODE') {
  //       var destination = result.nextStep.codeDeliveryDetails?.destination;
  //     }
  //   } on AmplifyException catch (e) {
  //     print("DEBUG: $e");
  //   }
  // }
}
