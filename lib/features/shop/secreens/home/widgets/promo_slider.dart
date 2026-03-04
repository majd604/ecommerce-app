import 'package:carousel_slider/carousel_slider.dart';
import 'package:ecommerce_app/common/widgets/images/rounded_image.dart';
import 'package:ecommerce_app/common/widgets/shimmer/shimmer_effect.dart';
import 'package:ecommerce_app/features/shop/controllers/banner/banner_controller.dart';
import 'package:ecommerce_app/features/shop/secreens/home/widgets/banner_dot_navigation.dart';
import 'package:ecommerce_app/utlis/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UPromoSlider extends StatelessWidget {
  const UPromoSlider({super.key});

  @override
  Widget build(BuildContext context) {
    final bannerController = Get.put(BannerController());
    return Obx(() {
      if (bannerController.isLoading.value) {
        return UShimmerEffect(width: double.infinity, height: 190);
      }
      if (bannerController.banners.isEmpty) {
        return Text("Banners Not Found");
      }
      return Column(
        children: [
          CarouselSlider(
            items: bannerController.banners
                .map(
                  (banner) => URoundedImage(
                    imageUrl: banner.imageUrl,
                    isImageNetwork: true,
                    onTap: () => Get.toNamed(banner.targetScreen),
                  ),
                )
                .toList(),
            options: CarouselOptions(
              viewportFraction: 1.0,

              onPageChanged: (index, reason) =>
                  bannerController.onPageChanged(index),
            ),
            carouselController: bannerController.carouselController,
          ),
          SizedBox(height: USizes.spaceBtwItems),
          //banner dot navigation
          BannerDotNavigation(),
        ],
      );
    });
  }
}
