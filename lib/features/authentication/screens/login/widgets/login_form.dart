import 'package:ecommerce_app/common/widgets/button/elevated_button.dart';
import 'package:ecommerce_app/features/authentication/controllers/login/login_controller.dart';
import 'package:ecommerce_app/features/authentication/screens/forget_password/forget_password.dart';
import 'package:ecommerce_app/features/authentication/screens/signup/sign_up.dart';
import 'package:ecommerce_app/utlis/constants/colors.dart';
import 'package:ecommerce_app/utlis/constants/sizes.dart';
import 'package:ecommerce_app/utlis/constants/text.dart';
import 'package:ecommerce_app/utlis/validators/validation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class ULoginForm extends StatelessWidget {
  const ULoginForm({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = LoginController.instance;
    return Form(
      key: controller.loginFormKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //Email
          TextFormField(
            validator: (value) => UValidator.validateEmail(value),
            controller: controller.email,
            decoration: InputDecoration(
              prefixIcon: Icon(Iconsax.direct_right),
              labelText: UItext.email,
            ),
          ),
          SizedBox(height: USizes.spaceBtwInputFields),
          //Password
          Obx(
            () => TextFormField(
              obscureText: controller.isPasswordVisible.value,

              validator: (value) =>
                  UValidator.validateEmptyText("Password", value),
              controller: controller.password,
              decoration: InputDecoration(
                prefixIcon: Icon(Iconsax.password_check),
                labelText: UItext.password,
                suffixIcon: IconButton(
                  onPressed: () => controller.isPasswordVisible.toggle(),
                  icon: Icon(
                    controller.isPasswordVisible.value
                        ? Iconsax.eye_slash
                        : Iconsax.eye,
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: USizes.spaceBtwInputFields / 2),
          //remember me && forget password
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Obx(
                () => Row(
                  children: [
                    Checkbox(
                      value: controller.rememberMe.value,
                      onChanged: (value) => controller.rememberMe.toggle(),
                    ),
                    Text(UItext.rememberMe),
                  ],
                ),
              ),
              //Forget Password
              TextButton(
                onPressed: () => Get.to(() => ForgetPasswordScreen()),
                child: Text(
                  UItext.forgetPassword,
                  style: TextStyle(color: UColors.primary),
                ),
              ),
            ],
          ),
          SizedBox(height: USizes.spaceBtwSections),
          //Sign In
          UElevatedButton(
            onPress: controller.loginWithEmailAndPassword,
            child: Text(UItext.signIn),
          ),
          SizedBox(height: USizes.spaceBtwItems / 2),
          //Create Account
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: () => Get.to(() => SignUpScreen()),
              child: Text(UItext.createAccount),
            ),
          ),
        ],
      ),
    );
  }
}
