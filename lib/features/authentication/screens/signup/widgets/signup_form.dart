import 'package:ecommerce_app/common/widgets/button/elevated_button.dart';
import 'package:ecommerce_app/features/authentication/controllers/signup/signup_controller.dart';
import 'package:ecommerce_app/features/authentication/screens/signup/widgets/privacy_police_checkbox.dart';
import 'package:ecommerce_app/utlis/constants/sizes.dart';
import 'package:ecommerce_app/utlis/constants/text.dart';
import 'package:ecommerce_app/utlis/validators/validation.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:iconsax/iconsax.dart';

class USignupForm extends StatelessWidget {
  const USignupForm({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = SignupController.instance;
    return Form(
      key: controller.signupFormKey,
      child: Column(
        children: [
          Row(
            children: [
              //first name
              Expanded(
                child: TextFormField(
                  controller: controller.firstName,
                  validator: (value) =>
                      UValidator.validateEmptyText('First Name', value),
                  decoration: InputDecoration(
                    labelText: UItext.fName,
                    prefixIcon: Icon(Iconsax.user),
                  ),
                ),
              ),
              SizedBox(width: USizes.spaceBtwInputFields),
              //last name
              Expanded(
                child: TextFormField(
                  controller: controller.lastName,
                  validator: (value) =>
                      UValidator.validateEmptyText('Last Name', value),
                  decoration: InputDecoration(
                    labelText: UItext.lName,
                    prefixIcon: Icon(Iconsax.personalcard),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: USizes.spaceBtwInputFields),
          //Email
          TextFormField(
            controller: controller.email,
            validator: (value) => UValidator.validateEmail(value),
            decoration: InputDecoration(
              prefixIcon: Icon(Iconsax.direct_right),
              labelText: UItext.email,
            ),
          ),
          SizedBox(height: USizes.spaceBtwInputFields),
          //phone number
          TextFormField(
            controller: controller.phoneNumber,
            validator: (value) => UValidator.validatePhoneNumber(value),
            decoration: InputDecoration(
              prefixIcon: Icon(Iconsax.call),
              labelText: UItext.phoneNu,
            ),
          ),
          SizedBox(height: USizes.spaceBtwInputFields),
          //Password
          Obx(
            () => TextFormField(
              obscureText: controller.isPasswordVisbal.value,
              controller: controller.password,
              validator: (value) => UValidator.validatePassword(value),
              decoration: InputDecoration(
                prefixIcon: Icon(Iconsax.password_check),
                labelText: UItext.password,
                suffixIcon: IconButton(
                  onPressed: () => controller.isPasswordVisbal.value =
                      !controller.isPasswordVisbal.value,
                  icon: Icon(
                    controller.isPasswordVisbal.value
                        ? Iconsax.eye
                        : Iconsax.eye_slash,
                  ),
                ),
              ),
            ),
          ),
          //privace police && Terms Of Us
          UPrivacyPoliceCheckbox(),
          SizedBox(height: USizes.spaceBtwSections),
          UElevatedButton(
            onPress: controller.registerUser,
            child: Text(UItext.createAccount),
          ),
        ],
      ),
    );
  }
}
