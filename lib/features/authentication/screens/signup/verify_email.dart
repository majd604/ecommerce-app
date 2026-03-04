// ignore_for_file: unused_local_variable, curly_braces_in_flow_control_structures

import 'package:ecommerce_app/common/style/padding.dart';
import 'package:ecommerce_app/common/widgets/button/elevated_button.dart';
import 'package:ecommerce_app/data/repositories/authentication_repositry.dart';

import 'package:ecommerce_app/features/authentication/controllers/signup/verify_email_controller.dart';

import 'package:ecommerce_app/utlis/constants/sizes.dart';
import 'package:ecommerce_app/utlis/constants/text.dart';
import 'package:ecommerce_app/utlis/helper/device_helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class VerifyEmailScreen extends StatelessWidget {
  const VerifyEmailScreen({super.key, this.email});
  final String? email;

  @override
  Widget build(BuildContext context) {
    final controller = Get.isRegistered<VerifyEmailController>()
        ? Get.find<VerifyEmailController>()
        : Get.put(VerifyEmailController());
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            onPressed: AuthenticationRepositry.instance.logout,
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
                height: UDeviceHelper.getScreenWidth(context) * 0.9,
              ),
              SizedBox(height: USizes.spaceBtwItems),

              ///title
              Text(
                UItext.verifyEmailTitle,
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              SizedBox(height: USizes.spaceBtwItems),

              ///Email
              Text(email ?? '', style: Theme.of(context).textTheme.bodyMedium),
              SizedBox(height: USizes.spaceBtwItems),

              ///subTitle
              Text(
                UItext.verifyEmailSubTitle,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodySmall,
              ),
              SizedBox(height: USizes.spaceBtwItems * 2),
              UElevatedButton(
                onPress: controller.checkEmailVerificationState,
                child: Text(UItext.uContinue),
              ),
              SizedBox(height: USizes.spaceBtwItems),
              TextButton(
                onPressed: () => controller.sendEmailVerification(),
                child: Obx(() {
                  final c = controller.cooldown.value;
                  final sending = controller.isSending.value;

                  if (sending) {
                    return const Text(
                      'Sending...',
                      style: TextStyle(color: Color(0xff0857A0)),
                    );
                  }

                  if (c > 0) {
                    return Text(
                      'Resend Email (${c}s)',
                      style: const TextStyle(color: Color(0xff0857A0)),
                    );
                  }

                  return Text(
                    UItext.resendEmail,
                    style: const TextStyle(color: Color(0xff0857A0)),
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
