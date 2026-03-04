import 'package:ecommerce_app/common/style/padding.dart';
import 'package:ecommerce_app/common/widgets/appbar/appbar.dart';
import 'package:ecommerce_app/common/widgets/button/elevated_button.dart';
import 'package:ecommerce_app/features/personalization/controllers/change_name_controller.dart';
import 'package:ecommerce_app/utlis/constants/sizes.dart';
import 'package:ecommerce_app/utlis/validators/validation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class ChangeNameScreen extends StatelessWidget {
  const ChangeNameScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ChangeNameController());
    return Scaffold(
      //[Appbar]
      appBar: UAppBar(
        showBackArrow: true,
        title: Text(
          "Change Name",
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        //[Body]
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: UPadding.screenPadding,
          child: Column(
            children: [
              Text(
                "Update your name to keep your profile accurate and personalized",
                style: Theme.of(context).textTheme.labelMedium,
              ),
              const SizedBox(height: USizes.spaceBtwSections),
              Form(
                key: controller.udpateUserFormKey,
                child: Column(
                  children: [
                    //first name
                    TextFormField(
                      controller: controller.firstName,
                      validator: (value) =>
                          UValidator.validateEmptyText("First Name", value),
                      decoration: InputDecoration(
                        labelText: "First Name",
                        prefixIcon: Icon(Iconsax.user),
                      ),
                    ),
                    const SizedBox(height: USizes.spaceBtwInputFields),
                    //last name
                    TextFormField(
                      controller: controller.lastName,
                      validator: (value) =>
                          UValidator.validateEmptyText("Last Name", value),
                      decoration: InputDecoration(
                        labelText: "Last Name",
                        prefixIcon: Icon(Iconsax.user),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: USizes.spaceBtwSections),
              //save button
              UElevatedButton(
                onPress: controller.updateUserName,
                child: Text("Save"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
