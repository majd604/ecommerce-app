import 'package:ecommerce_app/data/repositories/authentication_repositry.dart';
import 'package:ecommerce_app/features/authentication/screens/forget_password/reset_password.dart';
import 'package:ecommerce_app/utlis/helper/network_manager.dart';
import 'package:ecommerce_app/utlis/popups/full_screen_loader.dart';
import 'package:ecommerce_app/utlis/popups/snackbar_helpers.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class ForgetPasswordController extends GetxController {
  static ForgetPasswordController get instance => Get.find();
  //Variables

  final email = TextEditingController();

  final forgetPasswordFormKey = GlobalKey<FormState>();

  //Send Email To Forget Password
  Future<void> sendPasswordRestEmail() async {
    try {
      //Start Loading
      UFullScreenLoader.openLoadingDialog("Processing your requit...");

      //Chek Internit Connectivy
      bool isConntected = await NetworkManager.instance.isConnected();
      if (!isConntected) {
        UFullScreenLoader.stopLoading();
        USnackBarHelpers.warningSnackBar(title: "No Internit Connection..");
        return;
      }
      //Validate
      if (!forgetPasswordFormKey.currentState!.validate()) {
        UFullScreenLoader.stopLoading();
        return;
      }
      //Sent Email To Reset Password
      AuthenticationRepositry.instance.sendPasswordRestEmail(email.text.trim());
      //Stop Loading
      UFullScreenLoader.stopLoading();
      // Success Message
      USnackBarHelpers.successSnackBar(
        title: "Email Sent",
        message: "Email Link Sent To Reset Your Password",
      );
      //redirct
      Get.to(() => ResetPassword(email: email.text.trim()));
    } catch (e) {
      UFullScreenLoader.stopLoading();
      USnackBarHelpers.errorSnackBar(
        title: "Failed Forget Password",
        message: e.toString(),
      );
    }
  }

  Future<void> resendPasswordRestEmail() async {
    try {
      //Start Loading
      UFullScreenLoader.openLoadingDialog("Processing your requit...");

      //Chek Internit Connectivy
      bool isConntected = await NetworkManager.instance.isConnected();
      if (!isConntected) {
        UFullScreenLoader.stopLoading();
        USnackBarHelpers.warningSnackBar(title: "No Internit Connection..");
        return;
      }

      //Sent Email To Reset Password
      AuthenticationRepositry.instance.sendPasswordRestEmail(email.text.trim());
      //Stop Loading
      UFullScreenLoader.stopLoading();
      // Success Message
      USnackBarHelpers.successSnackBar(
        title: "Email Sent",
        message: "Email Link Sent To Reset Your Password",
      );
    } catch (e) {
      UFullScreenLoader.stopLoading();
      USnackBarHelpers.errorSnackBar(
        title: "Failed Forget Password",
        message: e.toString(),
      );
    }
  }
}
