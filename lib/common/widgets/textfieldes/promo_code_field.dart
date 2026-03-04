import 'package:ecommerce_app/common/widgets/custom_shapes/rounded_container.dart';
import 'package:ecommerce_app/features/shop/controllers/promo_code/promo_code_controller.dart';
import 'package:ecommerce_app/utlis/constants/colors.dart';

import 'package:ecommerce_app/utlis/constants/sizes.dart';
// import 'package:ecommerce_app/utlis/helper/helper_function.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UPromoCodeField extends StatelessWidget {
  const UPromoCodeField({super.key});

  @override
  Widget build(BuildContext context) {
    // final dark = UHelperFunctions.isDarkMode(context);
    final controller = PromoCodeController.instance;
    return URoundedContainer(
      padding: EdgeInsets.only(
        left: USizes.md,
        top: USizes.sm,
        bottom: USizes.sm,
        right: USizes.sm,
      ),
      showBorder: true,
      backgroundColor: Colors.transparent,
      child: Row(
        children: [
          Flexible(
            child: TextFormField(
              onChanged: controller.onPromeChange,
              decoration: InputDecoration(
                hintText: "Have A Promo Code ? Enter Here",
                hintStyle: Theme.of(context).textTheme.labelSmall,
                errorBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                enabledBorder: InputBorder.none,
                disabledBorder: InputBorder.none,
              ),
            ),
          ),
          SizedBox(
            width: 80,

            child: Obx(
              () => ElevatedButton(
                onPressed: controller.appliedPromoCode.value.id.isNotEmpty
                    ? null
                    : controller.promoCode.value.isEmpty
                    ? null
                    : controller.applyPromeCode,
                style: ElevatedButton.styleFrom(
                  side: BorderSide(color: Colors.grey.withValues(alpha: 0.2)),
                ),
                child: controller.isLoading.value
                    ? SizedBox(
                        height: USizes.lg,
                        width: USizes.lg,
                        child: CircularProgressIndicator(color: UColors.white),
                      )
                    : Text(
                        controller.appliedPromoCode.value.id.isEmpty
                            ? "Apply"
                            : "Applied",
                      ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
