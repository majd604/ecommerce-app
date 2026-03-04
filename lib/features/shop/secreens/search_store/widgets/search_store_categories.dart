import 'package:ecommerce_app/common/widgets/images/rounded_image.dart';
import 'package:ecommerce_app/common/widgets/texts/section_header.dart';
import 'package:ecommerce_app/features/shop/controllers/category/category_controller.dart';
import 'package:ecommerce_app/features/shop/models/category_model.dart';
import 'package:ecommerce_app/features/shop/secreens/all_products/all_products.dart';

import 'package:ecommerce_app/utlis/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SearchStoreCategories extends StatelessWidget {
  const SearchStoreCategories({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = CategoryController.instance;
    return Obx(() {
      ///[State] Loading
      if (controller.isCaregoriesLoading.value) {
        return Center(child: CircularProgressIndicator());
      }

      ///[State] Empty
      if (controller.allCategories.isEmpty) {
        return Center(child: Text("No Categories Found"));
      }

      ///[State] Data Found
      List<CategoryModel> categories = controller.allCategories;
      return Column(
        children: [
          //Categories
          USectinHeading(title: "Categories", showActionButton: false),
          ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: categories.length,
            itemBuilder: (context, index) {
              CategoryModel category = categories[index];
              return ListTile(
                onTap: () => Get.to(
                  () => AllProductsScreen(
                    title: category.name,
                    futureMethod: controller.getCategoryProducts(
                      categoryId: category.id,
                    ),
                  ),
                ),
                contentPadding: EdgeInsets.zero,
                leading: URoundedImage(
                  isImageNetwork: true,
                  imageUrl: category.image,
                  borderRadius: 0,
                  width: USizes.iconLg,
                  height: USizes.iconLg,
                ),
                title: Text(category.name),
              );
            },
          ),
        ],
      );
    });
  }
}
