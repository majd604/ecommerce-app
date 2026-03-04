// ignore_for_file: unnecessary_null_comparison, unused_local_variable
import 'package:ecommerce_app/common/widgets/layouts/grid_layout.dart';
import 'package:ecommerce_app/common/widgets/products/prodect_cards/prodect_card_vertical.dart';
import 'package:ecommerce_app/common/widgets/textfieldes/search_bar.dart';
import 'package:ecommerce_app/common/widgets/texts/section_header.dart';
import 'package:ecommerce_app/features/shop/controllers/home/home_controller.dart';
import 'package:ecommerce_app/features/shop/controllers/product/product_controller.dart';
import 'package:ecommerce_app/features/shop/models/product_model.dart';
import 'package:ecommerce_app/features/shop/secreens/all_products/all_products.dart';
import 'package:ecommerce_app/features/shop/secreens/home/widgets/home_appbar.dart';
import 'package:ecommerce_app/features/shop/secreens/home/widgets/home_categories.dart';
import 'package:ecommerce_app/common/widgets/custom_shapes/primary_header_container.dart';
import 'package:ecommerce_app/features/shop/secreens/home/widgets/promo_slider.dart';
import 'package:ecommerce_app/utlis/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(HomeController());
    final productController = Get.put(ProductController());
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Upper Part
            Stack(
              children: [
                SizedBox(height: USizes.homePrimaryHeaderHeight + 10),
                //primary header container
                UPrimaryHeaderContainer(
                  height: USizes.homePrimaryHeaderHeight,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      //App Bar
                      UHomeAppBar(),
                      SizedBox(height: USizes.spaceBtwSections),
                      //Home Categories
                      UHomeCategories(),
                    ],
                  ),
                ),
                //Search Bar
                USearchBar(),
              ],
            ),

            // Lower Part
            Padding(
              padding: const EdgeInsets.all(USizes.defaultSpace),
              child: Column(
                // Banners
                children: [
                  UPromoSlider(),
                  SizedBox(height: USizes.spaceBtwSections),
                  //section Header
                  USectinHeading(
                    title: "Popular Products",
                    onPressed: () => Get.to(
                      () => AllProductsScreen(
                        title: "Popular Products",
                        futureMethod: productController
                            .getAllFeaturedProducts(),
                      ),
                    ),
                  ),
                  SizedBox(height: USizes.spaceBtwItems),

                  //Grid View Of Prodect Card
                  Obx(() {
                    if (productController.isLoading.value) {
                      return Center(child: CircularProgressIndicator());
                    }
                    if (productController.featuredProducts.isEmpty) {
                      return Text('The Prducts not found');
                    }
                    return UGridLayot(
                      iteamCount: productController.featuredProducts.length,
                      itemBuilder: (context, index) {
                        ProductModel product =
                            productController.featuredProducts[index];
                        return UProductCardVertical(product: product);
                      },
                    );
                  }),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
