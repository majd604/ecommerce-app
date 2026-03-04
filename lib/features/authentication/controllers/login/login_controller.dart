import 'package:ecommerce_app/data/repositories/authentication_repositry.dart';
import 'package:ecommerce_app/features/personalization/controllers/user_controller.dart';
import 'package:ecommerce_app/utlis/constants/keys.dart';
import 'package:ecommerce_app/utlis/helper/network_manager.dart';
import 'package:ecommerce_app/utlis/popups/full_screen_loader.dart';
import 'package:ecommerce_app/utlis/popups/snackbar_helpers.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class LoginController extends GetxController {
  static LoginController get instance => Get.find();

  //Variables

  final email = TextEditingController();
  final password = TextEditingController();
  RxBool isPasswordVisible = false.obs;
  RxBool rememberMe = false.obs;

  final loginFormKey = GlobalKey<FormState>();
  final localStorge = GetStorage();

  @override
  void onInit() {
    email.text = localStorge.read(UKeys.rememberMeEmail) ?? "";
    password.text = localStorge.read(UKeys.rememberMePassword) ?? "";
    super.onInit();
  }

  Future<void> loginWithEmailAndPassword() async {
    try {
      //Start Loading
      UFullScreenLoader.openLoadingDialog("Logging in You");
      //Check Internet Connectivity
      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) {
        UFullScreenLoader.stopLoading();
        USnackBarHelpers.warningSnackBar(title: "No Internit Connection ");
        return;
      }
      //Validate
      if (!loginFormKey.currentState!.validate()) {
        UFullScreenLoader.stopLoading();
        return;
      }
      //Sava Data if remember me is  checked
      if (rememberMe.value) {
        localStorge.write(UKeys.rememberMeEmail, email.text.trim());
        localStorge.write(UKeys.rememberMePassword, password.text.trim());
      }
      await AuthenticationRepositry.instance.loginWithEmailAndPAssword(
        email.text.trim(),
        password.text.trim(),
      );
      //stop loading
      UFullScreenLoader.stopLoading();
      //Redirected
      AuthenticationRepositry.instance.screenRedirect();
    } catch (e) {
      UFullScreenLoader.stopLoading();
      USnackBarHelpers.errorSnackBar(
        title: "Login Failed",
        message: e.toString(),
      );
    }
  }

  //Google Sign in Authintcation
  Future<void> googleSignIn() async {
    try {
      //Start Loading
      UFullScreenLoader.openLoadingDialog("Logging you in...");
      //Check Internet Conectivity
      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) {
        UFullScreenLoader.stopLoading();
        USnackBarHelpers.warningSnackBar(title: "No Internet Connection!");
        return;
      }
      //Google Authintcation
      UserCredential userCredential = await AuthenticationRepositry.instance
          .signInWithGoogle();

      //Save User Record
      await Get.put(UserController()).saveUserRecord(userCredential);

      //Stop Loading
      UFullScreenLoader.stopLoading();

      //Redirect
      AuthenticationRepositry.instance.screenRedirect();
    } catch (e) {
      //stop loading
      UFullScreenLoader.stopLoading();
      //Warning Snap_Bar
      USnackBarHelpers.errorSnackBar(
        title: "Logged Falied",
        message: e.toString(),
      );
    }
  }
}
