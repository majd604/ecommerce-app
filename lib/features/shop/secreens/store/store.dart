import 'package:ecommerce_app/common/widgets/appbar/tab_bar.dart';

import 'package:ecommerce_app/common/widgets/brands/brands_cart.dart';
import 'package:ecommerce_app/common/widgets/shimmer/brands_shimmer.dart';

import 'package:ecommerce_app/common/widgets/texts/section_header.dart';
import 'package:ecommerce_app/features/shop/controllers/brand/brand_controller.dart';
import 'package:ecommerce_app/features/shop/controllers/category/category_controller.dart';
import 'package:ecommerce_app/features/shop/models/brand_model.dart';
import 'package:ecommerce_app/features/shop/secreens/brands/all_brands.dart';
import 'package:ecommerce_app/features/shop/secreens/brands/brands_products.dart';
import 'package:ecommerce_app/features/shop/secreens/store/widgets/category_tab.dart';
import 'package:ecommerce_app/features/shop/secreens/store/widgets/store_primary_header.dart';

import 'package:ecommerce_app/utlis/constants/sizes.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class StoreScreen extends StatelessWidget {
  const StoreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = CategoryController.instance;
    final brandController = Get.put(BrandController());
    return DefaultTabController(
      length: controller.featuredCategories.length,
      child: Scaffold(
        body: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) {
            return [
              SliverAppBar(
                automaticallyImplyLeading: false,
                expandedHeight: 350,
                pinned: true,
                floating: false,
                flexibleSpace: SingleChildScrollView(
                  child: Column(
                    children: [
                      UStorePrimaryHeader(),
                      SizedBox(height: USizes.spaceBtwItems),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: USizes.defaultSpace,
                        ),
                        child: Column(
                          children: [
                            USectinHeading(
                              title: "Brands",
                              onPressed: () => Get.to(() => AllBrandsScreen()),
                            ),
                            SizedBox(height: USizes.spaceBtwItems),
                            //Brand Cart
                            SizedBox(
                              height: USizes.brandCardHeigh,
                              child: Obx(() {
                                if (brandController.isLoading.value) {
                                  return UBrandsShimmer();
                                }
                                if (brandController.featuredBrands.isEmpty) {
                                  Text("Brands Not Found");
                                }
                                return ListView.separated(
                                  separatorBuilder: (context, index) =>
                                      SizedBox(width: USizes.spaceBtwItems),
                                  physics: BouncingScrollPhysics(),
                                  itemCount:
                                      brandController.featuredBrands.length,
                                  shrinkWrap: true,
                                  scrollDirection: Axis.horizontal,
                                  itemBuilder: (context, index) {
                                    BrandModel brand =
                                        brandController.featuredBrands[index];
                                    return SizedBox(
                                      width: USizes.brandCardWidth,
                                      child: UBrandCart(
                                        brand: brand,
                                        onTap: () => Get.to(
                                          () => BrandsProductsScreen(
                                            title: brand.name,
                                            brand: brand,
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                );
                              }),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                bottom: UTabBar(
                  tabs: controller.featuredCategories
                      .map((category) => Tab(child: Text(category.name)))
                      .toList(),
                ),
              ),
            ];
          },
          body: TabBarView(
            children: controller.featuredCategories
                .map((category) => UCategoryTab(category: category))
                .toList(),
          ),
        ),
      ),
    );
  }
}
