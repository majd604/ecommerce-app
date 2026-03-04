import 'package:ecommerce_app/common/widgets/products/cart/cart_iteam.dart';
import 'package:ecommerce_app/common/widgets/products/cart/product_quantity_with_add_remove.dart';
import 'package:ecommerce_app/common/widgets/texts/product_price_text.dart';
import 'package:ecommerce_app/features/shop/controllers/cart/cart_controller.dart';
import 'package:ecommerce_app/utlis/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';

class UCartIteams extends StatelessWidget {
  const UCartIteams({super.key, this.showAddRemoveByrron = true});
  final bool showAddRemoveByrron;

  @override
  Widget build(BuildContext context) {
    final controller = CartController.instance;
    return Obx(
      () => ListView.separated(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        separatorBuilder: (context, index) =>
            SizedBox(height: USizes.spaceBtwSections),
        itemCount: controller.cartItems.length,
        itemBuilder: (context, index) {
          final cartItem = controller.cartItems[index];
          return Column(
            children: [
              //cart iteam
              UCartIteam(cartItem: cartItem),
              if (showAddRemoveByrron) SizedBox(height: USizes.spaceBtwItems),
              if (showAddRemoveByrron)
                Row(
                  children: [
                    //Extra Space
                    SizedBox(width: 70.0),
                    //Quantity Button
                    UProductQuantityWithAddRemove(
                      quantity: cartItem.quantity,
                      add: () => controller.addOneToCart(cartItem),
                      remove: () => controller.removeOneFromCart(cartItem),
                    ),
                    Spacer(),
                    UProductPriceText(
                      price: (cartItem.price * cartItem.quantity)
                          .toStringAsFixed(0),
                    ),
                  ],
                ),
            ],
          );
        },
      ),
    );
  }
}
