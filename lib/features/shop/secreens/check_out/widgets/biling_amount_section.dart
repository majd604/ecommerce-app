import 'package:ecommerce_app/features/shop/controllers/cart/cart_controller.dart';
import 'package:ecommerce_app/features/shop/controllers/promo_code/promo_code_controller.dart';
import 'package:ecommerce_app/utlis/constants/colors.dart';
import 'package:ecommerce_app/utlis/constants/sizes.dart';
import 'package:ecommerce_app/utlis/constants/text.dart';
import 'package:ecommerce_app/utlis/helper/pricing_calculator.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UBilingAmountSection extends StatelessWidget {
  const UBilingAmountSection({super.key});

  @override
  Widget build(BuildContext context) {
    final cartController = CartController.instance;
    final subTotal = cartController.totalCartPrice.value;
    final promoCodeController = PromoCodeController.instance;
    return Column(
      children: [
        Row(
          children: [
            //sub total
            Expanded(
              child: Text(
                "Subtotal",
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
            Text(
              "${UItext.currency}$subTotal",
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
        const SizedBox(height: USizes.spaceBtwItems),
        //shipping fee
        Row(
          children: [
            Expanded(
              child: Text(
                "Shipping Fee",
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
            Text(
              "${UItext.currency}${UPricingCalculator.calculateShippingCost(subTotal, 'Egypt')}",
              style: Theme.of(context).textTheme.labelLarge,
            ),
          ],
        ),
        const SizedBox(height: USizes.spaceBtwItems),
        //tax fee
        Row(
          children: [
            Expanded(
              child: Text(
                "Tax Fee",
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
            Text(
              "${UItext.currency}${UPricingCalculator.calculateTax(subTotal, 'Egypt')}",
              style: Theme.of(context).textTheme.labelLarge,
            ),
          ],
        ),
        const SizedBox(height: USizes.spaceBtwItems / 2),
        //order total
        Row(
          children: [
            Expanded(
              child: Text(
                "Order Total",
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
            Obx(() {
              double totalPrice = UPricingCalculator.calculateTotalPrice(
                subTotal,
                'Egypt',
              );
              final promoCode = promoCodeController.appliedPromoCode.value;
              totalPrice = promoCodeController.calculatePriceAfterDiscount(
                promoCode,
                totalPrice,
              );
              return Text(
                "${UItext.currency}${totalPrice.toStringAsFixed(2)}",
                style: Theme.of(context).textTheme.titleMedium,
              );
            }),
          ],
        ),
        const SizedBox(height: USizes.spaceBtwItems / 2),
        //Discount price if promo code applied
        Obx(() {
          final promoCode = promoCodeController.appliedPromoCode.value;
          if (promoCode.id.isEmpty) {
            return const SizedBox();
          }
          return Row(
            children: [
              Expanded(
                child: Text(
                  "Discount",
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium!.apply(color: UColors.success),
                ),
              ),
              Text(
                promoCodeController.getDiscountPrice(),
                style: Theme.of(
                  context,
                ).textTheme.titleMedium!.apply(color: UColors.success),
              ),
            ],
          );
        }),
      ],
    );
  }
}
