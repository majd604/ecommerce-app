import 'package:ecommerce_app/common/style/padding.dart';
import 'package:ecommerce_app/common/widgets/button/elevated_button.dart';
import 'package:ecommerce_app/features/authentication/controllers/forget_password/forget_password_controller.dart';
import 'package:ecommerce_app/features/authentication/screens/login/login.dart';
import 'package:ecommerce_app/utlis/constants/sizes.dart';
import 'package:ecommerce_app/utlis/constants/text.dart';
import 'package:ecommerce_app/utlis/helper/device_helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ResetPassword extends StatelessWidget {
  const ResetPassword({super.key, required this.email});
  final String email;

  @override
  Widget build(BuildContext context) {
    final controller = ForgetPasswordController.instance;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            onPressed: () => Get.back(),
            icon: Icon(CupertinoIcons.clear),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: UPadding.screenPadding,
          child: Column(
            children: [
              ///image
              Image.asset(
                "assets/images/mail_illustration.png",
                height: UDeviceHelper.getScreenWidth(context) * 0.8,
              ),
              SizedBox(height: USizes.spaceBtwItems),

              ///title
              Text(
                UItext.emailResentTitle,
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              SizedBox(height: USizes.spaceBtwItems),

              ///Email
              Text(email, style: Theme.of(context).textTheme.bodyMedium),
              SizedBox(height: USizes.spaceBtwItems),

              ///subTitle
              Text(
                UItext.emailResentSubTitle,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodySmall,
              ),
              SizedBox(height: USizes.spaceBtwItems * 2),
              UElevatedButton(
                onPress: () => Get.offAll(() => LoginScreen()),
                child: Text(UItext.done),
              ),
              SizedBox(height: USizes.spaceBtwItems),
              TextButton(
                onPressed: controller.resendPasswordRestEmail,
                child: Text(
                  UItext.resendEmail,
                  style: TextStyle(color: Color(0xff0857A0)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
