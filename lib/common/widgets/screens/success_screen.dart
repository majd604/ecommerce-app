import 'package:ecommerce_app/common/style/padding.dart';
import 'package:ecommerce_app/common/widgets/button/elevated_button.dart';
import 'package:ecommerce_app/navigation_menu.dart';
import 'package:ecommerce_app/utlis/constants/sizes.dart';
import 'package:ecommerce_app/utlis/constants/text.dart';
import 'package:ecommerce_app/utlis/helper/device_helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SuccessScreen extends StatelessWidget {
  const SuccessScreen({
    super.key,
    required this.title,
    required this.image,
    required this.subTitle,
    required this.ontap,
  });
  final String title, image, subTitle;
  final VoidCallback ontap;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            onPressed: () => Get.offAll(() => NavigationMenu()),
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
                image,
                height: UDeviceHelper.getScreenWidth(context) * 0.8,
              ),
              SizedBox(height: USizes.spaceBtwItems),

              ///title
              Text(
                title,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              SizedBox(height: USizes.spaceBtwItems),

              SizedBox(height: USizes.spaceBtwItems),

              ///subTitle
              Text(
                subTitle,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodySmall,
              ),
              SizedBox(height: USizes.spaceBtwItems * 2),
              UElevatedButton(onPress: ontap, child: Text(UItext.uContinue)),
              SizedBox(height: USizes.spaceBtwItems),
            ],
          ),
        ),
      ),
    );
  }
}
