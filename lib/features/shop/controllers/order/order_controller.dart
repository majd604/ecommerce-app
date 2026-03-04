import 'package:ecommerce_app/common/widgets/screens/success_screen.dart';
import 'package:ecommerce_app/data/repositories/authentication_repositry.dart';
import 'package:ecommerce_app/data/repositories/order/order_repository.dart';
import 'package:ecommerce_app/features/personalization/controllers/address_controller.dart';
import 'package:ecommerce_app/features/shop/controllers/cart/cart_controller.dart';
import 'package:ecommerce_app/features/shop/controllers/checkout/checkout_controller.dart';
import 'package:ecommerce_app/features/shop/models/order_model.dart';
import 'package:ecommerce_app/navigation_menu.dart';
import 'package:ecommerce_app/utlis/constants/enums.dart';
import 'package:ecommerce_app/utlis/constants/images.dart';
import 'package:ecommerce_app/utlis/popups/full_screen_loader.dart';
import 'package:ecommerce_app/utlis/popups/snackbar_helpers.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OrderController extends GetxController {
  static OrderController get instance => Get.find();

  //Variables
  final cartController = CartController.instance;

  final addressConteroller = AddressController.instance;
  final _respository = Get.put(OrderRepository());
  //Process the Order
  Future<void> processOrder(double totalAmount) async {
    try {
      //Start Loading
      UFullScreenLoader.openLoadingDialog('Processing Your Order...');
      //Check user existence
      String userId = AuthenticationRepositry.instance.currentUser!.uid;
      if (userId.isEmpty) return;

      //check Address is exists or not
      if (AddressController.instance.selectedAddress.value.id.isEmpty) {
        USnackBarHelpers.errorSnackBar(
          title: 'Address Not Selected',
          message: 'Please Select Address',
        );

        return;
      }

      //create Order Model
      OrderModel order = OrderModel(
        id: UniqueKey().toString(),
        status: OrderStatus.pending,
        items: cartController.cartItems.toList(),
        totalAmount: totalAmount,
        orderDate: DateTime.now(),
        userId: userId,
        paymentMethod:
            CheckoutController.instance.selectedPaymentMethod.value.name,
        address: addressConteroller.selectedAddress.value,
        deliveryDate: DateTime.now(),
      );
      await _respository.saveOrder(order);
      //Clear Cart
      cartController.clearCart();
      //show success screen
      Get.to(
        () => SuccessScreen(
          title: 'Payment Success',
          image: UImages.successfulPaymentIcon,
          subTitle: 'Your iteam Will be Shipped Soon',
          ontap: () => Get.offAll(() => NavigationMenu()),
        ),
      );
    } catch (e) {
      USnackBarHelpers.errorSnackBar(
        title: 'Order Failed',
        message: e.toString(),
      );
    }
  }

  Future<List<OrderModel>> fetchUserOrders() async {
    try {
      final orders = await _respository.fetchUserOrders();
      return orders;
    } catch (e) {
      USnackBarHelpers.errorSnackBar(title: 'Failed', message: e.toString());
      return [];
    }
  }
}
