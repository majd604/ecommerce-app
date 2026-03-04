import 'package:ecommerce_app/common/widgets/icon/circular_icon.dart';
import 'package:ecommerce_app/features/shop/controllers/cart/cart_controller.dart';
import 'package:ecommerce_app/features/shop/models/product_model.dart';
import 'package:ecommerce_app/utlis/constants/colors.dart';
import 'package:ecommerce_app/utlis/constants/sizes.dart';
import 'package:ecommerce_app/utlis/helper/helper_function.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:iconsax/iconsax.dart';

class UBootomAddToCart extends StatelessWidget {
  const UBootomAddToCart({super.key, required this.product});
  final ProductModel product;

  @override
  Widget build(BuildContext context) {
    bool dark = UHelperFunctions.isDarkMode(context);
    final controller = CartController.instance;
    controller.updateAlreadyAddedProductCount(product);

    return Container(
      padding: EdgeInsets.symmetric(
        vertical: USizes.defaultSpace / 2,
        horizontal: USizes.defaultSpace,
      ),
      decoration: BoxDecoration(
        color: dark ? UColors.darkerGrey : UColors.light,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(USizes.cardRadiusLg),
          topRight: Radius.circular(USizes.cardRadiusLg),
        ),
      ),
      child: Obx(
        () => Row(
          children: [
            //Decrement Button
            UCircularIcon(
              icon: Iconsax.minus,
              width: 40,
              height: 40,
              backgroundColor: UColors.darkGrey,
              color: UColors.white,
              onPressed: controller.productQuantityInCart.value < 1
                  ? null
                  : () => controller.productQuantityInCart.value -= 1,
            ),
            SizedBox(width: USizes.spaceBtwItems),
            //Counter
            Text(
              controller.productQuantityInCart.value.toString(),
              style: Theme.of(context).textTheme.titleSmall,
            ),
            SizedBox(width: USizes.spaceBtwItems),
            //Increment Button
            UCircularIcon(
              icon: Iconsax.add,
              width: 40,
              height: 40,
              backgroundColor: UColors.black,
              color: UColors.white,
              onPressed: () => controller.productQuantityInCart.value += 1,
            ),
            Spacer(),
            //Add To Cart Button
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.all(USizes.sm),
                backgroundColor: UColors.black,
                side: BorderSide(color: UColors.black),
              ),
              onPressed: controller.productQuantityInCart.value < 1
                  ? null
                  : () => controller.addToCart(product),
              child: Row(
                children: [
                  Icon(Iconsax.shopping_bag),
                  SizedBox(width: USizes.spaceBtwItems),
                  Text("Add To card"),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
