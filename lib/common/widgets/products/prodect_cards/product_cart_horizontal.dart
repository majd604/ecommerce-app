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

class UProductCartHorizontal extends StatelessWidget {
  const UProductCartHorizontal({super.key, required this.product});
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
        width: 320,
        padding: EdgeInsets.all(1),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(USizes.productImageRadius),
          color: dark ? UColors.darkerGrey : UColors.light,
        ),
        child: Row(
          children: [
            //left portion
            URoundedContainer(
              height: 120,
              padding: EdgeInsets.all(USizes.sm),
              backgroundColor: dark ? UColors.dark : UColors.white,
              child: Stack(
                children: [
                  //Thumbanil
                  SizedBox(
                    width: 120,
                    height: 120,
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
                          '$salePercentage%',
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

            //right portion
            SizedBox(
              width: 172.0,

              child: Padding(
                padding: const EdgeInsets.only(left: USizes.sm, top: USizes.sm),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        //Title Product
                        UProdectTitle(title: product.title, smallSize: true),
                        SizedBox(height: USizes.spaceBtwItems / 2),
                        UBrandTitleWithVerifyIcon(title: product.brand!.name),
                      ],
                    ),
                    Spacer(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        //Product Price
                        Flexible(
                          child: UProductPriceText(
                            price: controller.getProductPriced(product),
                          ),
                        ),
                        //Add Button
                        ProductAddToCartbutton(product: product),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
