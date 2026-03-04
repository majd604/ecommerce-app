import 'package:ecommerce_app/common/style/shadow.dart';
import 'package:ecommerce_app/features/shop/secreens/search_store/search_store.dart';
import 'package:ecommerce_app/utlis/constants/colors.dart';
import 'package:ecommerce_app/utlis/constants/sizes.dart';
import 'package:ecommerce_app/utlis/constants/text.dart';
import 'package:ecommerce_app/utlis/helper/helper_function.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class USearchBar extends StatelessWidget {
  const USearchBar({super.key});

  @override
  Widget build(BuildContext context) {
    bool dark = UHelperFunctions.isDarkMode(context);
    return Positioned(
      bottom: 0,
      left: USizes.spaceBtwSections,
      right: USizes.spaceBtwSections,
      child: GestureDetector(
        onTap: () => Get.to(() => SearchStoreScreen()),
        child: Hero(
          tag: 'search_animation',
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: USizes.md),
            height: USizes.searchBarHeight,
            decoration: BoxDecoration(
              color: dark ? UColors.dark : UColors.light,
              borderRadius: BorderRadius.circular(USizes.borderRadiusLg),
              boxShadow: UShadow.searchBarShadow,
            ),
            child: Row(
              children: [
                Icon(Iconsax.search_normal, color: UColors.darkGrey),
                SizedBox(width: USizes.spaceBtwItems),
                Text(
                  UItext.searchAppBar,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
