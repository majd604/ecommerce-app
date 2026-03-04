import 'package:ecommerce_app/common/widgets/custom_shapes/rounded_container.dart';
import 'package:ecommerce_app/common/widgets/images/circular_image.dart';
import 'package:ecommerce_app/common/widgets/texts/brand_title_with_verify_icon.dart';
import 'package:ecommerce_app/common/widgets/texts/prodect_title_text.dart';
import 'package:ecommerce_app/common/widgets/texts/product_price_text.dart';
import 'package:ecommerce_app/features/shop/controllers/product/product_controller.dart';
import 'package:ecommerce_app/features/shop/models/product_model.dart';
import 'package:ecommerce_app/utlis/constants/colors.dart';
import 'package:ecommerce_app/utlis/constants/enums.dart';
import 'package:ecommerce_app/utlis/constants/sizes.dart';
import 'package:ecommerce_app/utlis/constants/text.dart';
import 'package:flutter/material.dart';

class UProductMetaData extends StatelessWidget {
  const UProductMetaData({super.key, required this.product});
  final ProductModel product;
  @override
  Widget build(BuildContext context) {
    final controller = ProductController.instance;
    String? salePercenTag = controller.culculateSalePercentage(
      product.price,
      product.salePrice,
    );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        //Sale Tag,Sale Price,Actual Price And Share Button
        Row(
          children: [
            //Sale Tag
            if (salePercenTag != null) ...[
              URoundedContainer(
                radius: USizes.sm,
                backgroundColor: UColors.yellow.withValues(alpha: 0.8),
                padding: EdgeInsets.symmetric(
                  horizontal: USizes.sm,
                  vertical: USizes.xs,
                ),
                child: Text(
                  salePercenTag,
                  style: Theme.of(
                    context,
                  ).textTheme.labelLarge!.apply(color: UColors.black),
                ),
              ),

              SizedBox(width: USizes.spaceBtwItems),
            ],

            //Sale Price
            if (product.productType == ProductType.single.toString() &&
                product.salePrice > 0) ...[
              Text(
                "${UItext.currency}${product.price.toStringAsFixed(0)}",
                style: Theme.of(context).textTheme.titleSmall!.apply(
                  decoration: TextDecoration.lineThrough,
                ),
              ),
              SizedBox(width: USizes.spaceBtwItems),
            ],

            //Sale Price or Actual Price
            UProductPriceText(
              price: controller.getProductPriced(product),
              isLarg: true,
            ),
          ],
        ),

        SizedBox(height: USizes.spaceBtwItems / 1.5),
        //Product Title
        UProdectTitle(title: product.title),
        SizedBox(height: USizes.spaceBtwItems / 1.5),
        //Product Status
        Row(
          children: [
            UProdectTitle(title: "Status :"),
            SizedBox(width: USizes.spaceBtwItems),
            Text(
              controller.getProductStockStock(product.stock),
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ],
        ),
        SizedBox(height: USizes.spaceBtwItems / 1.5),
        //product Brand Image With Titlw
        Row(
          children: [
            //Brand Image
            UCircularImage(
              padding: 0,
              isNetworkImage: true,
              image: product.brand != null ? product.brand!.image : '',
              width: 32.0,
              height: 32.0,
            ),
            SizedBox(width: USizes.spaceBtwItems),
            //Brand Title
            UBrandTitleWithVerifyIcon(
              title: product.brand != null ? product.brand!.name : "",
            ),
          ],
        ),
        SizedBox(height: USizes.spaceBtwSections),
      ],
    );
  }
}
