import 'package:ecommerce_app/common/widgets/custom_shapes/rounded_container.dart';
import 'package:ecommerce_app/common/widgets/images/rounded_image.dart';
import 'package:ecommerce_app/common/widgets/texts/brand_title_with_verify_icon.dart';
import 'package:ecommerce_app/features/shop/models/brand_model.dart';
import 'package:ecommerce_app/utlis/constants/enums.dart';
import 'package:ecommerce_app/utlis/constants/sizes.dart';
import 'package:flutter/material.dart';

class UBrandCart extends StatelessWidget {
  const UBrandCart({
    super.key,
    this.showBorder = true,
    this.onTap,
    required this.brand,
  });
  final bool showBorder;
  final VoidCallback? onTap;
  final BrandModel brand;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: URoundedContainer(
        height: USizes.brandCardHeigh,

        showBorder: showBorder,

        padding: EdgeInsets.all(USizes.sm),
        backgroundColor: Colors.transparent,

        child: Row(
          children: [
            Flexible(
              child: URoundedImage(
                imageUrl: brand.image,
                isImageNetwork: true,
                backgroundColor: Colors.transparent,
              ),
            ),
            SizedBox(width: USizes.spaceBtwItems),
            Expanded(
              //Right Portion
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  //Brand Name & Verify Icon
                  UBrandTitleWithVerifyIcon(
                    title: brand.name,
                    brandTextSize: TextSizes.larg,
                  ),
                  Text(
                    "${brand.productsCount}: Prodects",
                    style: Theme.of(context).textTheme.labelMedium,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
