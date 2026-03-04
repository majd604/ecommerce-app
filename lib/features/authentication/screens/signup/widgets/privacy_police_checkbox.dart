import 'package:ecommerce_app/features/authentication/controllers/signup/signup_controller.dart';
import 'package:ecommerce_app/utlis/constants/colors.dart';
import 'package:ecommerce_app/utlis/constants/text.dart';
import 'package:ecommerce_app/utlis/helper/helper_function.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';

class UPrivacyPoliceCheckbox extends StatelessWidget {
  const UPrivacyPoliceCheckbox({super.key});

  @override
  Widget build(BuildContext context) {
    final dark = UHelperFunctions.isDarkMode(context);
    final controller = SignupController.instance;
    return Row(
      children: [
        Obx(
          () => Checkbox(
            value: controller.privacePolice.value,
            onChanged: (value) => controller.privacePolice.value =
                !controller.privacePolice.value,
          ),
        ),
        Flexible(
          child: RichText(
            text: TextSpan(
              style: Theme.of(context).textTheme.bodyMedium,
              children: [
                TextSpan(text: '${UItext.iAgreeTo} '), // لاحظ المسافة هون ✅
                TextSpan(
                  text: UItext.privacePolice,
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                    color: dark ? UColors.white : UColors.primary,
                    decoration: TextDecoration.underline,
                    decorationColor: dark ? UColors.white : UColors.primary,
                    decorationThickness: 1.5, // اختياري: يخلي الخط أوضح
                  ),
                ),
                TextSpan(text: ' ${UItext.and} '), // مسافة قبل وبعد ✅
                TextSpan(
                  text: UItext.termsOfUs, // بدون ما تحط space هون
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                    color: dark ? UColors.white : UColors.primary,
                    decoration: TextDecoration.underline,
                    decorationColor: dark ? UColors.white : UColors.primary,
                    decorationThickness: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
