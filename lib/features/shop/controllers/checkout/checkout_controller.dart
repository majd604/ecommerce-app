import 'package:ecommerce_app/common/widgets/texts/section_header.dart';
import 'package:ecommerce_app/data/services/stripe_services.dart';
import 'package:ecommerce_app/features/shop/controllers/order/order_controller.dart';
import 'package:ecommerce_app/features/shop/controllers/promo_code/promo_code_controller.dart';
import 'package:ecommerce_app/features/shop/models/payment_methos_model.dart';
import 'package:ecommerce_app/features/shop/secreens/check_out/widgets/payment_tile.dart';
import 'package:ecommerce_app/utlis/constants/enums.dart';
import 'package:ecommerce_app/utlis/constants/images.dart';
import 'package:ecommerce_app/utlis/constants/sizes.dart';
import 'package:ecommerce_app/utlis/popups/snackbar_helpers.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CheckoutController extends GetxController {
  static CheckoutController get instance => Get.find();

  //Variables
  Rx<PaymentMethodModel> selectedPaymentMethod = PaymentMethodModel.empty().obs;
  final _orderController = Get.put(OrderController());
  final _stripeService = Get.put(StripeServices());
  final isPaymentProcessing = false.obs;

  @override
  onInit() {
    selectedPaymentMethod.value = PaymentMethodModel(
      name: 'Cash on Delivery',
      image: UImages.codIcon,
      paymentMethod: PaymentMethods.cashOnDelivery,
    );
    super.onInit();
  }

  Future<void> selectPaymentMethod(BuildContext context) async {
    return showModalBottomSheet(
      context: context,
      builder: (context) => SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(USizes.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              USectinHeading(
                title: 'Select Payment Method  :',
                showActionButton: false,
              ),
              const SizedBox(height: USizes.spaceBtwSections),
              UPaymentTile(
                paymentMethod: PaymentMethodModel(
                  name: 'Cash on Deleviry',
                  image: UImages.codIcon,
                  paymentMethod: PaymentMethods.cashOnDelivery,
                ),
              ),
              const SizedBox(height: USizes.spaceBtwItems / 2),

              UPaymentTile(
                paymentMethod: PaymentMethodModel(
                  name: 'PayPal',
                  image: UImages.paypal,
                  paymentMethod: PaymentMethods.paypal,
                ),
              ),
              const SizedBox(height: USizes.spaceBtwItems / 2),

              UPaymentTile(
                paymentMethod: PaymentMethodModel(
                  name: 'Credit/Debit Card',
                  image: UImages.creditCard,
                  paymentMethod: PaymentMethods.creditCard,
                ),
              ),
              const SizedBox(height: USizes.spaceBtwItems / 2),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> checkOut(double totalAmount) async {
    try {
      //Start Loading
      isPaymentProcessing.value = true;
      PaymentMethods paymentMethod = selectedPaymentMethod.value.paymentMethod;
      switch (paymentMethod) {
        case PaymentMethods.creditCard:
          final amountInCents = (totalAmount * 100).round();
          await _stripeService.initPaymentSheet('usd', amountInCents);
          await _stripeService.showPaymentSheet();

        case PaymentMethods.cashOnDelivery:
          break;
        default:
          throw 'Payment Method Not Supported';
      }
      //stop Loading
      isPaymentProcessing.value = false;
      //process order
      await _orderController.processOrder(totalAmount);
      //decrease no of promo codes
      await PromoCodeController.instance.decreaseNoOfPromoCode();
      //add user to promo code
      await PromoCodeController.instance.addUserToPromoCode();
    } catch (e) {
      isPaymentProcessing.value = false;
      USnackBarHelpers.errorSnackBar(title: 'Error', message: e.toString());
    }
  }
}
