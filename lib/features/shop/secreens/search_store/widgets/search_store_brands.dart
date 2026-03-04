import 'package:ecommerce_app/common/widgets/image_text/vertical_image_text.dart';
import 'package:ecommerce_app/common/widgets/texts/section_header.dart';
import 'package:ecommerce_app/features/shop/controllers/brand/brand_controller.dart';
import 'package:ecommerce_app/features/shop/models/brand_model.dart';
import 'package:ecommerce_app/features/shop/secreens/brands/all_brands.dart';
import 'package:ecommerce_app/features/shop/secreens/brands/brands_products.dart';
import 'package:ecommerce_app/utlis/constants/colors.dart';
import 'package:ecommerce_app/utlis/constants/sizes.dart';
import 'package:ecommerce_app/utlis/helper/helper_function.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SearchStoreBrands extends StatelessWidget {
  const SearchStoreBrands({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(BrandController());
    bool dark = UHelperFunctions.isDarkMode(context);
    return Obx(() {
      ///[State] is loading
      if (controller.isLoading.value) {
        return Center(child: CircularProgressIndicator());
      }

      ///[State] is Empty
      if (controller.allBrands.isEmpty) {
        return Text("No Brands Found");
      }

      ///[State]Data Found
      List<BrandModel> brands = controller.allBrands.take(10).toList();
      return Column(
        children: [
          USectinHeading(
            title: "Brands",
            onPressed: () => Get.to(() => AllBrandsScreen()),
          ),
          const SizedBox(height: USizes.spaceBtwItems),
          Wrap(
            spacing: USizes.spaceBtwItems,
            runSpacing: USizes.spaceBtwItems,
            children: brands
                .map(
                  (brand) => UVerticalImageText(
                    onTap: () => Get.to(
                      () =>
                          BrandsProductsScreen(title: brand.name, brand: brand),
                    ),
                    title: brand.name,
                    image: brand.image,
                    textColor: dark ? UColors.light : UColors.dark,
                  ),
                )
                .toList(),
          ),
        ],
      );
    });
  }
}
