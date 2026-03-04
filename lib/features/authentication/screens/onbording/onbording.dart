import 'package:ecommerce_app/features/authentication/controllers/onbording/on_bording_controller.dart';
import 'package:ecommerce_app/features/authentication/screens/onbording/widgets/on_bording_dot_navigation.dart';
import 'package:ecommerce_app/features/authentication/screens/onbording/widgets/on_bording_next_button.dart';
import 'package:ecommerce_app/features/authentication/screens/onbording/widgets/on_bording_page.dart';
import 'package:ecommerce_app/features/authentication/screens/onbording/widgets/on_bording_skip_button.dart';
import 'package:ecommerce_app/utlis/constants/images.dart';
import 'package:ecommerce_app/utlis/constants/sizes.dart';
import 'package:ecommerce_app/utlis/constants/text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OnbordingScreen extends StatelessWidget {
  const OnbordingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(OnBordingController());
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: USizes.defaultSpace),
        child: Stack(
          children: [
            //scrollabel page
            PageView(
              controller: controller.pageController,
              onPageChanged: (value) => controller.updatePageIndicator(value),
              children: [
                OnBordingPage(
                  animation: UImages.onboarding1Animation,
                  title: UItext.onBordingTitile1,
                  subTitle: UItext.onBordingSubTitile1,
                ),
                OnBordingPage(
                  animation: UImages.onboarding2Animation,
                  title: UItext.onBordingTitile2,
                  subTitle: UItext.onBordingSubTitile2,
                ),
                OnBordingPage(
                  animation: UImages.onboarding3Animation,
                  title: UItext.onBordingTitile3,
                  subTitle: UItext.onBordingSubTitile3,
                ),
              ],
            ),
            //Indiactor
            OnBordingDotNavigation(),
            //Bottom Butoon
            OnBordingNextButton(),
            //Skip Button
            OnBordingSkipButton(),
          ],
        ),
      ),
    );
  }
}
