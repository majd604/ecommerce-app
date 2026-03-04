import 'package:ecommerce_app/common/widgets/custom_shapes/rounded_container.dart';
import 'package:ecommerce_app/features/personalization/controllers/address_controller.dart';
import 'package:ecommerce_app/features/personalization/models/address_model.dart';
import 'package:ecommerce_app/utlis/constants/colors.dart';
import 'package:ecommerce_app/utlis/constants/sizes.dart';
import 'package:ecommerce_app/utlis/helper/helper_function.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:iconsax/iconsax.dart';

class USingleAddress extends StatelessWidget {
  const USingleAddress({super.key, required this.address, required this.onTap});

  final AddressModel address;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final controller = AddressController.instance;
    final dark = UHelperFunctions.isDarkMode(context);
    return Obx(() {
      String selectedAddreesId = controller.selectedAddress.value.id;
      bool isSelected = selectedAddreesId == address.id;
      return InkWell(
        onTap: onTap,
        child: URoundedContainer(
          borderColor: isSelected
              ? Colors.transparent
              : dark
              ? UColors.darkGrey
              : UColors.grey,
          backgroundColor: isSelected
              ? UColors.primary.withValues(alpha: 0.5)
              : Colors.transparent,
          width: double.infinity,
          padding: EdgeInsets.all(USizes.md),
          showBorder: true,
          child: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //Name
                  Text(
                    address.name,
                    style: Theme.of(context).textTheme.titleLarge,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: USizes.spaceBtwItems / 2),
                  //Phone Number
                  Text(
                    address.phoneNumber,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: USizes.spaceBtwItems / 2),
                  //Address
                  Text(
                    address.toString(),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
              if (isSelected)
                Positioned(
                  top: 0,
                  bottom: 0,
                  right: 6,
                  child: Icon(Iconsax.tick_circle5),
                ),
            ],
          ),
        ),
      );
    });
  }
}
