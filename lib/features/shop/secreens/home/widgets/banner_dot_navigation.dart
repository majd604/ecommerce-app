import 'package:ecommerce_app/features/shop/controllers/banner/banner_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class BannerDotNavigation extends StatelessWidget {
  const BannerDotNavigation({super.key});

  @override
  Widget build(BuildContext context) {
    final bannerController = Get.put(BannerController());

    return Obx(
      () => SmoothPageIndicator(
        count: bannerController.banners.length,
        effect: ExpandingDotsEffect(dotHeight: 8.0),
        controller: PageController(
          initialPage: bannerController.currentIndex.value,
        ),
      ),
    );
  }
}
