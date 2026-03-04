import 'package:ecommerce_app/features/shop/controllers/cart/cart_controller.dart';
import 'package:ecommerce_app/features/shop/models/cart_iteam_model.dart';
import 'package:ecommerce_app/features/shop/models/product_model.dart';
import 'package:ecommerce_app/features/shop/secreens/product_details/prodect_details.dart';
import 'package:ecommerce_app/utlis/constants/colors.dart';
import 'package:ecommerce_app/utlis/constants/enums.dart';
import 'package:ecommerce_app/utlis/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class ProductAddToCartbutton extends StatelessWidget {
  const ProductAddToCartbutton({super.key, required this.product});
  final ProductModel product;

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(CartController());
    return InkWell(
      onTap: () {
        if (product.productType == ProductType.single.toString()) {
          CartItemModel cartItem = controller.convertToCartItem(product, 1);
          controller.addOneToCart(cartItem);
        } else {
          Get.to(() => ProdectDetailsScreen(product: product));
        }
      },
      child: Obx(() {
        int productQunatityInCart = controller.getProductQuantityInCart(
          product.id,
        );
        return Container(
          width: USizes.iconLg * 1.2,
          height: USizes.iconLg * 1.2,
          decoration: BoxDecoration(
            color: productQunatityInCart > 0 ? UColors.dark : UColors.primary,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(USizes.cardRadiusMd),
              bottomRight: Radius.circular(USizes.productImageRadius),
            ),
          ),
          child: Center(
            child: productQunatityInCart > 0
                ? Text(
                    productQunatityInCart.toString(),
                    style: Theme.of(
                      context,
                    ).textTheme.titleLarge!.apply(color: UColors.white),
                  )
                : Icon(Iconsax.add, color: UColors.white),
          ),
        );
      }),
    );
  }
}
