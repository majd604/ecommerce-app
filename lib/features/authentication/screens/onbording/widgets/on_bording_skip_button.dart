import 'package:ecommerce_app/features/authentication/controllers/onbording/on_bording_controller.dart';
import 'package:ecommerce_app/utlis/constants/colors.dart';
import 'package:ecommerce_app/utlis/helper/device_helper.dart';
import 'package:flutter/material.dart';
import 'package:get/state_manager.dart';

class OnBordingSkipButton extends StatelessWidget {
  const OnBordingSkipButton({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = OnBordingController.instance;
    return Obx(
      () => controller.currentIndex.value == 2
          ? SizedBox()
          : Positioned(
              top: UDeviceHelper.getAppBarHeight(),
              right: 0,
              child: TextButton(
                onPressed: controller.skipPage,
                child: Text("Skip", style: TextStyle(color: UColors.primary)),
              ),
            ),
    );
  }
}
