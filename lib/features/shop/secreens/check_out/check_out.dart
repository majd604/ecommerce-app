import 'package:ecommerce_app/common/style/padding.dart';
import 'package:ecommerce_app/common/widgets/appbar/appbar.dart';
import 'package:ecommerce_app/common/widgets/button/elevated_button.dart';
import 'package:ecommerce_app/common/widgets/custom_shapes/rounded_container.dart';
import 'package:ecommerce_app/common/widgets/loader/screen_partial_loading.dart';
import 'package:ecommerce_app/common/widgets/textfieldes/promo_code_field.dart';
import 'package:ecommerce_app/features/shop/controllers/cart/cart_controller.dart';
import 'package:ecommerce_app/features/shop/controllers/checkout/checkout_controller.dart';
import 'package:ecommerce_app/features/shop/controllers/promo_code/promo_code_controller.dart';
import 'package:ecommerce_app/features/shop/secreens/cart/widgets/cart_iteams.dart';
import 'package:ecommerce_app/features/shop/secreens/check_out/widgets/biling_amount_section.dart';
import 'package:ecommerce_app/features/shop/secreens/check_out/widgets/biling_payment_section.dart';
import 'package:ecommerce_app/features/shop/secreens/check_out/widgets/billing_address_section.dart';
import 'package:ecommerce_app/utlis/constants/sizes.dart';
import 'package:ecommerce_app/utlis/constants/text.dart';
import 'package:ecommerce_app/utlis/helper/pricing_calculator.dart';
import 'package:ecommerce_app/utlis/popups/snackbar_helpers.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CheckOutScreen extends StatelessWidget {
  const CheckOutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final checkoutController = Get.put(CheckoutController());
    final promoCodeController = Get.put(PromoCodeController());
    final cartController = CartController.instance;
    double subTotal = cartController.totalCartPrice.value;
    double totalPrice = UPricingCalculator.calculateTotalPrice(
      subTotal,
      'Egypt',
    );

    return Obx(
      () => UPartialScreenLoading(
        isLoading: checkoutController.isPaymentProcessing.value,
        child: Scaffold(
          appBar: UAppBar(
            showBackArrow: true,
            title: Text(
              "Order Review",
              style: Theme.of(context).textTheme.headlineSmall,
            ),
          ),
          body: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Padding(
              padding: UPadding.screenPadding,
              child: Column(
                children: [
                  UCartIteams(showAddRemoveByrron: false),
                  SizedBox(height: USizes.spaceBtwItems),
                  UPromoCodeField(),
                  SizedBox(height: USizes.spaceBtwItems),

                  //Bilding Section
                  URoundedContainer(
                    showBorder: true,
                    padding: EdgeInsets.all(USizes.md),
                    backgroundColor: Colors.transparent,
                    child: Column(
                      children: [
                        // Amount
                        UBilingAmountSection(),
                        SizedBox(height: USizes.spaceBtwItems),
                        Divider(),
                        //Payment
                        UBilingPaymentSection(),
                        SizedBox(height: USizes.spaceBtwItems),

                        //Address
                        UBillingAddressSection(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          //[bottomNavigationBar] Check Out Button
          bottomNavigationBar: Obx(() {
            final promoCode = promoCodeController.appliedPromoCode.value;
            totalPrice = promoCodeController.calculatePriceAfterDiscount(
              promoCode,
              totalPrice,
            );
            return Padding(
              padding: const EdgeInsets.all(USizes.defaultSpace),
              child: UElevatedButton(
                onPress: subTotal > 0
                    ? () => checkoutController.checkOut(totalPrice)
                    : () => USnackBarHelpers.errorSnackBar(
                        title: 'Empty Cart',
                        message:
                            'Please add items to your cart before checking out.',
                      ),
                child: Text(
                  "Check Out ${UItext.currency} ${totalPrice.toStringAsFixed(2)} ",
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}
