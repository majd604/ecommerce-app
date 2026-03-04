// ignore_for_file: must_be_immutable

import 'package:ecommerce_app/common/style/shadow.dart';
import 'package:ecommerce_app/common/widgets/button/add_to_cart_button.dart';
import 'package:ecommerce_app/common/widgets/custom_shapes/rounded_container.dart';
import 'package:ecommerce_app/common/widgets/images/rounded_image.dart';
import 'package:ecommerce_app/common/widgets/products/favourite/favourite_icon.dart';
import 'package:ecommerce_app/common/widgets/texts/brand_title_with_verify_icon.dart';
import 'package:ecommerce_app/common/widgets/texts/prodect_title_text.dart';
import 'package:ecommerce_app/common/widgets/texts/product_price_text.dart';
import 'package:ecommerce_app/features/shop/controllers/product/product_controller.dart';
import 'package:ecommerce_app/features/shop/models/product_model.dart';
import 'package:ecommerce_app/features/shop/secreens/product_details/prodect_details.dart';
import 'package:ecommerce_app/utlis/constants/colors.dart';
import 'package:ecommerce_app/utlis/constants/sizes.dart';
import 'package:ecommerce_app/utlis/helper/helper_function.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UProductCardVertical extends StatelessWidget {
  const UProductCardVertical({super.key, required this.product});
  final ProductModel product;

  @override
  Widget build(BuildContext context) {
    final dark = UHelperFunctions.isDarkMode(context);
    final controller = ProductController.instance;
    String? salePercentage = controller.culculateSalePercentage(
      product.price,
      product.salePrice,
    );
    return GestureDetector(
      onTap: () => Get.to(() => ProdectDetailsScreen(product: product)),
      child: Container(
        width: 180,
        padding: EdgeInsets.all(1),
        decoration: BoxDecoration(
          boxShadow: dark ? [] : UShadow.verticalProductShadow,
          borderRadius: BorderRadius.circular(USizes.productImageRadius),
          color: dark ? Color(0x0857A01A) : UColors.white,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //Thumbanil,Favorite Button And Discount Tag
            URoundedContainer(
              height: 180,
              padding: const EdgeInsets.all(USizes.sm),
              backgroundColor: dark ? UColors.dark : UColors.light,
              child: Stack(
                children: [
                  //Thumbanil
                  Center(
                    child: URoundedImage(
                      imageUrl: product.thumbnail,
                      isImageNetwork: true,
                    ),
                  ),
                  //Discount Tag
                  if (salePercentage != null)
                    Positioned(
                      top: 12,
                      child: URoundedContainer(
                        radius: USizes.sm,
                        backgroundColor: UColors.yellow.withValues(alpha: 0.8),
                        padding: EdgeInsets.symmetric(
                          horizontal: USizes.sm,
                          vertical: USizes.xs,
                        ),
                        child: Text(
                          "$salePercentage%",
                          style: Theme.of(
                            context,
                          ).textTheme.labelLarge!.apply(color: UColors.black),
                        ),
                      ),
                    ),
                  //favourite Button
                  Positioned(
                    top: 0,
                    right: 0,
                    child: UFavouriteIcon(productId: product.id),
                  ),
                ],
              ),
            ),

            SizedBox(height: USizes.spaceBtwItems / 2),
            //Details
            Padding(
              padding: const EdgeInsets.only(left: USizes.sm),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //Prodect Title
                  UProdectTitle(title: product.title, smallSize: true),
                  SizedBox(height: USizes.spaceBtwItems / 2),
                  // Prodect Brand
                  UBrandTitleWithVerifyIcon(title: product.brand!.name),
                ],
              ),
            ),
            Spacer(),

            //Product Price and Add Button
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                //Prodect Price
                Padding(
                  padding: const EdgeInsets.only(left: USizes.sm),
                  child: UProductPriceText(
                    price: controller.getProductPriced(product),
                  ),
                ),
                // Add Button
                ProductAddToCartbutton(product: product),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
