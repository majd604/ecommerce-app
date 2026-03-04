import 'package:ecommerce_app/common/style/padding.dart';
import 'package:ecommerce_app/common/widgets/appbar/appbar.dart';
import 'package:ecommerce_app/common/widgets/texts/section_header.dart';
import 'package:ecommerce_app/features/personalization/controllers/user_controller.dart';
import 'package:ecommerce_app/features/personalization/screens/change_name/change_name.dart';
import 'package:ecommerce_app/features/personalization/screens/edit_profile/widgets/user_detail_row.dart';
import 'package:ecommerce_app/features/personalization/screens/edit_profile/widgets/user_profile_with_edit_icon.dart';
import 'package:ecommerce_app/utlis/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EditProfileScreen extends StatelessWidget {
  const EditProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = UserController.instance;
    return Scaffold(
      appBar: UAppBar(
        showBackArrow: true,
        title: Text(
          "Edit Profile",
          style: Theme.of(context).textTheme.headlineMedium,
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: UPadding.screenPadding,
          child: Column(
            children: [
              //User Profile With Edit Icon
              UserProfileWithEditIcon(),
              SizedBox(height: USizes.spaceBtwSections),
              //Divider
              Divider(),
              SizedBox(height: USizes.spaceBtwItems),
              //Acount Setting Heading
              USectinHeading(title: "Account Setting", showActionButton: false),
              SizedBox(height: USizes.spaceBtwItems),
              //Account Details
              UserDetailRow(
                title: "Name",
                value: controller.user.value.fullName,
                ontap: () => Get.to(() => ChangeNameScreen()),
              ),
              UserDetailRow(
                title: "Username",
                value: controller.user.value.username,
                ontap: () {},
              ),
              SizedBox(height: USizes.spaceBtwItems),
              //Diveder
              Divider(),
              SizedBox(height: USizes.spaceBtwItems),
              //Profile Setting Heading
              USectinHeading(title: "Profile Setting", showActionButton: false),
              SizedBox(height: USizes.spaceBtwItems),
              UserDetailRow(
                title: "User ID",
                value: controller.user.value.id,
                ontap: () {},
              ),
              //Profile Settings
              UserDetailRow(
                title: "Email",
                value: controller.user.value.email,
                ontap: () {},
              ),
              UserDetailRow(
                title: "Phone Number",
                value: controller.user.value.phoneNumber,
                ontap: () {},
              ),
              UserDetailRow(title: "Gender", value: "Male", ontap: () {}),
              SizedBox(height: USizes.spaceBtwItems),
              //Diveder
              Divider(),
              SizedBox(height: USizes.spaceBtwItems),
              //close account button
              TextButton(
                onPressed: controller.deleteAccountWarningPopup,
                child: Text(
                  "Close Account",
                  style: TextStyle(color: Colors.red),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
