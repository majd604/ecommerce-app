import 'dart:io';

import 'package:ecommerce_app/common/style/padding.dart';
import 'package:ecommerce_app/data/repositories/authentication_repositry.dart';
import 'package:ecommerce_app/data/repositories/user/user_repositry.dart';
import 'package:ecommerce_app/features/authentication/models/user_model.dart';
import 'package:ecommerce_app/features/authentication/screens/login/login.dart';
import 'package:ecommerce_app/features/personalization/screens/edit_profile/widgets/re_authintcation_user_form.dart';
import 'package:ecommerce_app/utlis/constants/sizes.dart';
import 'package:ecommerce_app/utlis/helper/network_manager.dart';
import 'package:ecommerce_app/utlis/popups/full_screen_loader.dart';
import 'package:ecommerce_app/utlis/popups/snackbar_helpers.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart' as dio;
import 'package:image_picker/image_picker.dart';

class UserController extends GetxController {
  static UserController get instance => Get.find();
  // Variables
  final _userRepositry = Get.put(UserRepositry());
  Rx<UserModel> user = UserModel.empty().obs;
  RxBool profileLoading = false.obs;
  RxBool isProfileUploading = false.obs;

  //Re-Authintcation Form Variables
  final email = TextEditingController();
  final password = TextEditingController();
  final reAuthFormKey = GlobalKey<FormState>();
  RxBool isPasswordVisible = false.obs;
  @override
  onInit() {
    fetchUserDetails();
    super.onInit();
  }

  ///Function to Saved User Record

  Future<void> saveUserRecord(UserCredential userCredential) async {
    try {
      //First update Rx variable and then check if user data is already stored.If not then stored
      await fetchUserDetails();
      if (user.value.id.isEmpty) {
        //Convert Full name to FirstName &&LastName
        final nameParts = UserModel.nameParts(userCredential.user!.displayName);
        final username = '${userCredential.user!.displayName}2381';
        UserModel userModel = UserModel(
          id: userCredential.user!.uid,
          firstName: nameParts[0],
          lastName: nameParts.length > 1 ? nameParts.sublist(1).join('') : '',
          username: username,
          email: userCredential.user!.email ?? '',
          phoneNumber: userCredential.user!.phoneNumber ?? '',
          profilePicture: userCredential.user!.photoURL ?? '',
        );
        //save user record
        await _userRepositry.saveUserRecord(userModel);
      }
    } catch (e) {
      USnackBarHelpers.warningSnackBar(
        title: "Data Not Saved",
        message: "Somthing went wrong when saving your information",
      );
    }
  }

  ///Function to fetsh user details

  Future<void> fetchUserDetails() async {
    try {
      profileLoading.value = true;
      UserModel user = await _userRepositry.fetshUserDetail();
      this.user(user);
    } catch (e) {
      user(UserModel.empty());
    } finally {
      profileLoading.value = false;
    }
  }

  void deleteAccountWarningPopup() {
    Get.defaultDialog(
      contentPadding: UPadding.screenPadding,
      title: 'Delete Account.?',
      middleText: 'Are You Sure You Want Delete Your Account Permanently.?',
      confirm: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.red,
          side: BorderSide(color: Colors.red),
        ),
        onPressed: deleteUserAccount,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: USizes.lg),
          child: Text("Confirm"),
        ),
      ),
      cancel: OutlinedButton(
        onPressed: () => Get.back(),
        child: Text("Cancel"),
      ),
    );
  }

  Future<void> deleteUserAccount() async {
    try {
      //start loading
      UFullScreenLoader.openLoadingDialog("Processing");
      //Re-Authintcation user
      final authRepository = AuthenticationRepositry.instance;
      final provider = authRepository.currentUser!.providerData
          .map((e) => e.providerId)
          .first;
      //if google provider
      if (provider == 'google.com') {
        await authRepository.signInWithGoogle();
        await authRepository.deleteAccount();
        UFullScreenLoader.stopLoading();
        Get.offAll(() => LoginScreen());
      }
      //if email && password provider
      else if (provider == 'password') {
        UFullScreenLoader.stopLoading();
        Get.to(() => ReAuthintcationUserForm());
      }
    } catch (e) {
      UFullScreenLoader.stopLoading();
      USnackBarHelpers.errorSnackBar(title: "Error", message: e.toString());
    }
  }
  //Re-Authintcation user with email and password

  Future<void> reAuthintcationUser() async {
    try {
      //start loading
      UFullScreenLoader.openLoadingDialog("Processing..");
      //check internet connectivy
      bool isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) {
        UFullScreenLoader.stopLoading();
        return;
      }
      //validate
      if (!reAuthFormKey.currentState!.validate()) {
        UFullScreenLoader.stopLoading();
        return;
      }
      //Re-Authintcation user with email and password
      await AuthenticationRepositry.instance
          .reAuthintcationUserWithEmailAndPassword(
            email.text.trim(),
            password.text.trim(),
          );
      //delete account
      await AuthenticationRepositry.instance.deleteAccount();
      //stop loading
      UFullScreenLoader.stopLoading();
      Get.offAll(() => LoginScreen());
    } catch (e) {
      UFullScreenLoader.stopLoading();
      USnackBarHelpers.warningSnackBar(title: "Failed", message: e.toString());
    }
  }

  //[Upload Image]Update User Profile Picture
  Future<void> updateUserProfilePicture() async {
    try {
      //start loading
      isProfileUploading.value = true;
      //Pick Image From Gallery
      XFile? image = await ImagePicker().pickImage(
        source: ImageSource.gallery,
        maxHeight: 512,
        maxWidth: 512,
      );
      if (image == null) return;

      //Convert Xfile To File
      File file = File(image.path);

      //delete user current profile picture

      if (user.value.publicId.isNotEmpty) {
        await _userRepositry.deleteProfilePicture(user.value.publicId);
      }

      //Upload Profile Picture To Cloudinary
      dio.Response response = await _userRepositry.uoploadImage(file);

      if (response.statusCode == 200) {
        //Get Data
        final data = response.data;

        final imageUrl = data['url'];

        final publicId = data['public_id'];

        //Update Profile Picture From Fire Store

        await _userRepositry.updateSingleField({
          'profilePicture': imageUrl,
          'publicId': publicId,
        });
        // update profile and public from RX user
        user.value.profilePicture = imageUrl;
        user.value.publicId = publicId;
        user.refresh();
        //Success Message
        USnackBarHelpers.successSnackBar(
          title: "Gongratulation",
          message: "Your Profile Picture Updated Successuflly",
        );
      } else {
        throw "Failed To Upload Your Profile Picture Please Try Again..";
      }
    } catch (e) {
      USnackBarHelpers.errorSnackBar(title: "Failed", message: e.toString());
    } finally {
      isProfileUploading.value = false;
    }
  }
}
