import 'package:ecommerce_app/common/widgets/images/rounded_image.dart';
import 'package:ecommerce_app/common/widgets/texts/brand_title_with_verify_icon.dart';
import 'package:ecommerce_app/common/widgets/texts/prodect_title_text.dart';
import 'package:ecommerce_app/features/shop/models/cart_iteam_model.dart';
import 'package:ecommerce_app/utlis/constants/colors.dart';
import 'package:ecommerce_app/utlis/constants/sizes.dart';
import 'package:ecommerce_app/utlis/helper/helper_function.dart';
import 'package:flutter/material.dart';

class UCartIteam extends StatelessWidget {
  const UCartIteam({super.key, required this.cartItem});
  final CartItemModel cartItem;

  @override
  Widget build(BuildContext context) {
    final dark = UHelperFunctions.isDarkMode(context);
    return Row(
      children: [
        URoundedImage(
          backgroundColor: dark ? UColors.darkerGrey : UColors.light,
          padding: EdgeInsets.all(USizes.sm),
          imageUrl: cartItem.image ?? '',
          isImageNetwork: true,
          width: 65,
          height: 65,
        ),
        SizedBox(width: USizes.spaceBtwItems),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              UBrandTitleWithVerifyIcon(title: cartItem.brandName ?? ''),
              UProdectTitle(title: cartItem.title, maxLines: 1),
              RichText(
                text: TextSpan(
                  children: (cartItem.selectedVariation ?? {}).entries
                      .map(
                        (e) => TextSpan(
                          children: [
                            TextSpan(
                              text: '${e.key} ',
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                            TextSpan(
                              text: '${e.value} ',
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ],
                        ),
                      )
                      .toList(),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
