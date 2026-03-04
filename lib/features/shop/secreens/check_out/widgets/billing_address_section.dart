import 'package:ecommerce_app/common/widgets/texts/section_header.dart';
import 'package:ecommerce_app/features/personalization/controllers/address_controller.dart';
import 'package:ecommerce_app/utlis/constants/colors.dart';
import 'package:ecommerce_app/utlis/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UBillingAddressSection extends StatelessWidget {
  const UBillingAddressSection({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(AddressController());
    controller.getAllAddress();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        USectinHeading(
          title: "Billing Address",
          buttonTitle: "Changed",
          onPressed: () => controller.selectNewAddressBottomSheet(context),
        ),
        Obx(() {
          final address = controller.selectedAddress.value;
          if (address.id.isEmpty) {
            return Text(
              "No Address Selected",
              style: Theme.of(context).textTheme.bodyMedium,
            );
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(address.name, style: Theme.of(context).textTheme.titleLarge),
              SizedBox(height: USizes.spaceBtwItems / 2),
              Row(
                children: [
                  Icon(
                    Icons.phone,
                    color: UColors.darkGrey,
                    size: USizes.iconSm,
                  ),
                  SizedBox(width: USizes.spaceBtwItems),
                  Text(address.phoneNumber),
                ],
              ),
              SizedBox(height: USizes.spaceBtwItems / 2),
              Row(
                children: [
                  Icon(
                    Icons.location_history,
                    color: UColors.darkGrey,
                    size: USizes.iconSm,
                  ),
                  SizedBox(width: USizes.spaceBtwItems),
                  Expanded(child: Text(address.toString(), softWrap: true)),
                ],
              ),
            ],
          );
        }),
      ],
    );
  }
}
