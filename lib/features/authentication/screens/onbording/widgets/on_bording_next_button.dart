import 'package:ecommerce_app/common/widgets/button/elevated_button.dart';
import 'package:ecommerce_app/features/authentication/controllers/onbording/on_bording_controller.dart';
import 'package:ecommerce_app/utlis/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';

class OnBordingNextButton extends StatelessWidget {
  const OnBordingNextButton({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = OnBordingController.instance;
    return Positioned(
      left: 0,
      right: 0,
      bottom: USizes.spaceBtwItems,
      child: UElevatedButton(
        onPress: controller.nextPage,
        child: Obx(
          () =>
              Text(controller.currentIndex.value == 2 ? "Get Statred" : "Next"),
        ),
      ),
    );
  }
}
