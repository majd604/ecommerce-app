// ignore_for_file: unnecessary_string_interpolations, unused_local_variable

import 'package:ecommerce_app/common/style/padding.dart';

import 'package:ecommerce_app/common/widgets/button/social_button.dart';
import 'package:ecommerce_app/common/widgets/login_signup/form_divder.dart';
import 'package:ecommerce_app/features/authentication/controllers/signup/signup_controller.dart';

import 'package:ecommerce_app/features/authentication/screens/signup/widgets/signup_form.dart';
import 'package:ecommerce_app/utlis/constants/sizes.dart';
import 'package:ecommerce_app/utlis/constants/text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(SignupController());
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: UPadding.screenPadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ///----Header----
              ///Title
              Text(
                UItext.signUpTitile,
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              SizedBox(height: USizes.spaceBtwSections),

              ///----Form----
              USignupForm(),

              ///----Divider----
              SizedBox(height: USizes.spaceBtwSections),
              UFormDivider(title: UItext.orSignUpWith),

              ///----Footer----
              SizedBox(height: USizes.spaceBtwSections),
              USocialButton(),
            ],
          ),
        ),
      ),
    );
  }
}
