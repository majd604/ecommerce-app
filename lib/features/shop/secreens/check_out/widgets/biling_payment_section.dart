import 'package:ecommerce_app/common/widgets/custom_shapes/rounded_container.dart';
import 'package:ecommerce_app/common/widgets/texts/section_header.dart';
import 'package:ecommerce_app/features/shop/controllers/checkout/checkout_controller.dart';
import 'package:ecommerce_app/utlis/constants/colors.dart';
import 'package:ecommerce_app/utlis/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:ecommerce_app/utlis/helper/helper_function.dart';
import 'package:get/get.dart';

class UBilingPaymentSection extends StatelessWidget {
  const UBilingPaymentSection({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = CheckoutController.instance;
    final dark = UHelperFunctions.isDarkMode(context);
    return Column(
      children: [
        //Text & Payyment Method
        USectinHeading(
          title: "Payment Method",
          buttonTitle: "Changed",
          onPressed: () => controller.selectPaymentMethod(context),
        ),
        SizedBox(height: USizes.spaceBtwItems / 2),
        Obx(
          () => Row(
            children: [
              //Payyment Method
              URoundedContainer(
                height: 40,
                width: 60,
                backgroundColor: dark ? UColors.light : UColors.white,
                padding: EdgeInsets.all(USizes.sm),
                child: Image(
                  image: AssetImage(
                    controller.selectedPaymentMethod.value.image,
                  ),
                  fit: BoxFit.contain,
                ),
              ),
              SizedBox(width: USizes.spaceBtwSections),
              Text(
                controller.selectedPaymentMethod.value.name,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
