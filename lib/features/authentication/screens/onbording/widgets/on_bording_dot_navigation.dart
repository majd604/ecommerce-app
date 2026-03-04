import 'package:ecommerce_app/features/authentication/controllers/onbording/on_bording_controller.dart';
import 'package:ecommerce_app/utlis/helper/device_helper.dart';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnBordingDotNavigation extends StatelessWidget {
  const OnBordingDotNavigation({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = OnBordingController.instance;
    return Positioned(
      bottom: UDeviceHelper.getBottomNavigationBarHeight() * 4,
      left: UDeviceHelper.getScreenWidth(context) / 3,
      right: UDeviceHelper.getScreenWidth(context) / 3,

      child: SmoothPageIndicator(
        controller: controller.pageController,
        onDotClicked: controller.dotNavicationClick,
        count: 3,
        effect: ExpandingDotsEffect(dotHeight: 8.0),
      ),
    );
  }
}
