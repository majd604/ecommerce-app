// ignore_for_file: unused_local_variable, empty_catches

import 'package:ecommerce_app/data/repositories/authentication_repositry.dart';
import 'package:ecommerce_app/data/repositories/user/user_repositry.dart';
import 'package:ecommerce_app/features/authentication/models/user_model.dart';
import 'package:ecommerce_app/features/authentication/screens/signup/verify_email.dart';
import 'package:ecommerce_app/utlis/helper/network_manager.dart';
import 'package:ecommerce_app/utlis/popups/full_screen_loader.dart';
import 'package:ecommerce_app/utlis/popups/snackbar_helpers.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class SignupController extends GetxController {
  static SignupController get instance => Get.find();

  final signupFormKey = GlobalKey<FormState>();
  RxBool isPasswordVisbal = false.obs;
  RxBool privacePolice = false.obs;

  final firstName = TextEditingController();
  final lastName = TextEditingController();
  final email = TextEditingController();
  final phoneNumber = TextEditingController();
  final password = TextEditingController();

  Future<void> registerUser() async {
    try {
      UFullScreenLoader.openLoadingDialog(
        'We Are Processing Your Information...',
      );

      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) {
        UFullScreenLoader.stopLoading();
        USnackBarHelpers.warningSnackBar(title: 'No Internet Connetion');
        return;
      }

      if (!privacePolice.value) {
        UFullScreenLoader.stopLoading();
        USnackBarHelpers.warningSnackBar(
          title: "Accept Privace Poice",
          message:
              "In order to create account , you must have to read and accept the Privace Police & terms Of Use ",
        );
        return;
      }

      if (!signupFormKey.currentState!.validate()) {
        UFullScreenLoader.stopLoading();
        return;
      }

      final userCredential = await AuthenticationRepositry.instance
          .registerUser(email.text.trim(), password.text.trim());

      final userModel = UserModel(
        id: userCredential.user!.uid,
        firstName: firstName.text,
        lastName: lastName.text,
        username: '${firstName.text}${lastName.text}716283',
        email: email.text.trim(),
        phoneNumber: phoneNumber.text.trim(),
        profilePicture: '',
      );

      final userRepositry = Get.put(UserRepositry());
      await userRepositry.saveUserRecord(userModel);

      UFullScreenLoader.stopLoading();

      // لا تقول "تم إرسال الإيميل" هنا لأن الإرسال سيتم من شاشة Verify مرة واحدة
      USnackBarHelpers.successSnackBar(
        title: "Account Created",
        message: "Redirecting to email verification...",
        duration: 3,
      );

      Get.to(() => VerifyEmailScreen(email: email.text.trim()));
    } catch (e) {
      UFullScreenLoader.stopLoading();
      USnackBarHelpers.errorSnackBar(title: "Error", message: e.toString());
    }
  }
}
