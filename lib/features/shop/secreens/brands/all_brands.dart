import 'package:ecommerce_app/common/style/padding.dart';
import 'package:ecommerce_app/common/widgets/appbar/appbar.dart';
import 'package:ecommerce_app/common/widgets/brands/brands_cart.dart';
import 'package:ecommerce_app/common/widgets/layouts/grid_layout.dart';
import 'package:ecommerce_app/common/widgets/shimmer/brands_shimmer.dart';
import 'package:ecommerce_app/common/widgets/texts/section_header.dart';
import 'package:ecommerce_app/features/shop/controllers/brand/brand_controller.dart';
import 'package:ecommerce_app/features/shop/models/brand_model.dart';
import 'package:ecommerce_app/features/shop/secreens/brands/brands_products.dart';

import 'package:ecommerce_app/utlis/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AllBrandsScreen extends StatelessWidget {
  const AllBrandsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = BrandController.instance;
    return Scaffold(
      appBar: UAppBar(
        showBackArrow: true,
        title: Text("Brand", style: Theme.of(context).textTheme.headlineMedium),
      ),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Padding(
          padding: UPadding.screenPadding,
          child: Column(
            children: [
              //[Text]--Brands
              USectinHeading(title: "Brands", showActionButton: false),
              SizedBox(height: USizes.spaceBtwItems),

              //List oF Brands
              Obx(() {
                if (controller.isLoading.value) {
                  return UBrandsShimmer();
                }
                if (controller.featuredBrands.isEmpty) {
                  return Text("No Brands Here");
                }
                return UGridLayot(
                  iteamCount: controller.allBrands.length,
                  itemBuilder: (context, index) {
                    BrandModel brand = controller.allBrands[index];
                    return UBrandCart(
                      onTap: () => Get.to(
                        () => BrandsProductsScreen(
                          title: brand.name,
                          brand: brand,
                        ),
                      ),
                      brand: brand,
                    );
                  },
                  mainAxisExten: 80,
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}
