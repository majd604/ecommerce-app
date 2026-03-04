import 'package:ecommerce_app/common/style/padding.dart';
import 'package:ecommerce_app/common/widgets/login_signup/form_divder.dart';
import 'package:ecommerce_app/features/authentication/controllers/login/login_controller.dart';
import 'package:ecommerce_app/features/authentication/screens/login/widgets/login_form.dart';
import 'package:ecommerce_app/features/authentication/screens/login/widgets/login_header.dart';
import 'package:ecommerce_app/common/widgets/button/social_button.dart';
import 'package:ecommerce_app/utlis/constants/sizes.dart';
import 'package:ecommerce_app/utlis/constants/text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(LoginController());
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: UPadding.screenPadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Header
              //Title && Subtitle
              ULoginHeader(),
              SizedBox(height: USizes.spaceBtwSections),
              //Form
              ULoginForm(),

              SizedBox(height: USizes.spaceBtwSections),
              //divider
              UFormDivider(title: UItext.orSignInWith),

              SizedBox(height: USizes.spaceBtwSections),
              //Social Button
              USocialButton(),
            ],
          ),
        ),
      ),
    );
  }
}
