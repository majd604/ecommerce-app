import 'package:ecommerce_app/common/style/padding.dart';
import 'package:ecommerce_app/common/widgets/appbar/appbar.dart';
import 'package:ecommerce_app/common/widgets/button/elevated_button.dart';
import 'package:ecommerce_app/common/widgets/icon/circular_icon.dart';
import 'package:ecommerce_app/common/widgets/loader/animation_loader.dart';
import 'package:ecommerce_app/features/shop/controllers/cart/cart_controller.dart';
import 'package:ecommerce_app/features/shop/secreens/cart/widgets/cart_iteams.dart';
import 'package:ecommerce_app/features/shop/secreens/check_out/check_out.dart';
import 'package:ecommerce_app/utlis/constants/images.dart';
import 'package:ecommerce_app/utlis/constants/sizes.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = CartController.instance;
    return Scaffold(
      appBar: UAppBar(
        showBackArrow: true,
        title: Text("Cart", style: Theme.of(context).textTheme.headlineMedium),
        actions: [
          UCircularIcon(
            icon: Iconsax.box_remove,
            onPressed: () => controller.clearCart(),
          ),
        ],
      ),
      body: Obx(() {
        final emptyWidget = UAnimationLoader(
          text: 'Cart Is Empty',
          animation: UImages.cartEmptyAnimation,
          showActionButton: true,
          actionText: "Let's Fill It ",
          onActionPressed: () => Get.back(),
        );
        if (controller.cartItems.isEmpty) {
          return emptyWidget;
        }
        return SingleChildScrollView(
          child: Padding(padding: UPadding.screenPadding, child: UCartIteams()),
        );
      }),
      bottomNavigationBar: Obx(() {
        if (controller.cartItems.isEmpty) return SizedBox();
        return Padding(
          padding: const EdgeInsets.all(USizes.defaultSpace),
          child: UElevatedButton(
            onPress: () => Get.to(() => CheckOutScreen()),
            child: Text(
              "CheckOut \$${controller.totalCartPrice.value.toStringAsFixed(0)}",
            ),
          ),
        );
      }),
    );
  }
}
