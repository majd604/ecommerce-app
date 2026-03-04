import 'package:ecommerce_app/data/repositories/user/user_repositry.dart';
import 'package:ecommerce_app/features/personalization/controllers/user_controller.dart';
import 'package:ecommerce_app/navigation_menu.dart';
import 'package:ecommerce_app/utlis/helper/network_manager.dart';
import 'package:ecommerce_app/utlis/popups/full_screen_loader.dart';
import 'package:ecommerce_app/utlis/popups/snackbar_helpers.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

class ChangeNameController extends GetxController {
  static ChangeNameController get instance => Get.find();

  //varibeles
  final _userController = UserController.instance;
  final _userRepositry = UserRepositry.instance;
  final firstName = TextEditingController();
  final lastName = TextEditingController();
  final udpateUserFormKey = GlobalKey<FormState>();

  @override
  void onInit() {
    initializeName();
    super.onInit();
  }

  void initializeName() {
    firstName.text = _userController.user.value.firstName;
    lastName.text = _userController.user.value.lastName;
  }

  Future<void> updateUserName() async {
    try {
      //start loading
      UFullScreenLoader.openLoadingDialog("We Are Processing Your Information");
      //network connectivy
      bool isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) {
        UFullScreenLoader.stopLoading();
        USnackBarHelpers.warningSnackBar(title: "No Internit Connetion");
        return;
      }
      //Validate
      if (!udpateUserFormKey.currentState!.validate()) {
        UFullScreenLoader.stopLoading();
        return;
      }
      //update user from fire store
      Map<String, dynamic> map = {
        'firstName': firstName.text,
        'lastName': lastName.text,
      };
      await _userRepositry.updateSingleField(map);
      //update user from RX user
      _userController.user.value.firstName = firstName.text;
      _userController.user.value.lastName = lastName.text;
      //stop loading
      UFullScreenLoader.stopLoading();
      //redirect
      Get.offAll(() => NavigationMenu());
      //success
      USnackBarHelpers.successSnackBar(
        title: "Congratulation",
        message: "Your name has been upadted ",
      );
    } catch (e) {
      USnackBarHelpers.errorSnackBar(
        title: "Ubdate Name Failed",
        message: e.toString(),
      );
    }
  }
}
