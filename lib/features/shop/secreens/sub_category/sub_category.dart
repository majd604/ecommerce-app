import 'package:ecommerce_app/common/style/padding.dart';
import 'package:ecommerce_app/common/widgets/appbar/appbar.dart';
import 'package:ecommerce_app/common/widgets/products/prodect_cards/product_cart_horizontal.dart';
import 'package:ecommerce_app/common/widgets/shimmer/horizontal_product_shimmer.dart';
import 'package:ecommerce_app/common/widgets/texts/section_header.dart';
import 'package:ecommerce_app/features/shop/controllers/category/category_controller.dart';
import 'package:ecommerce_app/features/shop/models/category_model.dart';
import 'package:ecommerce_app/features/shop/models/product_model.dart';
import 'package:ecommerce_app/features/shop/secreens/all_products/all_products.dart';
import 'package:ecommerce_app/utlis/constants/sizes.dart';
import 'package:ecommerce_app/utlis/helper/cloud_helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SubCategoryScreen extends StatelessWidget {
  const SubCategoryScreen({super.key, required this.category});

  final CategoryModel category;

  @override
  Widget build(BuildContext context) {
    final controller = CategoryController.instance;
    return Scaffold(
      appBar: UAppBar(
        showBackArrow: true,
        title: Text(
          category.name,
          style: Theme.of(context).textTheme.headlineMedium,
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: UPadding.screenPadding,
          child: FutureBuilder(
            future: controller.getSubCategory(category.id),
            builder: (context, snapshot) {
              //Handle Loader,Error,Empty
              const loader = UHorizontalProductShimmer();
              final widget = UCloudHelperFunctions.checkMultiRecordState(
                snapshot: snapshot,
                loader: loader,
              );
              if (widget != null) return widget;
              //Data Found ,Subcategory Found
              List<CategoryModel> subCategories = snapshot.data!;
              return ListView.builder(
                shrinkWrap: true,
                itemCount: subCategories.length,
                physics: NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  CategoryModel subCategory = subCategories[index];

                  //Fetch products for susbCategory
                  return FutureBuilder(
                    future: controller.getCategoryProducts(
                      categoryId: subCategory.id,
                    ),
                    builder: (context, snapshot) {
                      //Handle error,Loader,Empty
                      final widget =
                          UCloudHelperFunctions.checkMultiRecordState(
                            snapshot: snapshot,
                            loader: loader,
                          );
                      if (widget != null) return widget;

                      //Data Found - Products Found
                      List<ProductModel> products = snapshot.data!;
                      return Column(
                        children: [
                          //sub categories
                          USectinHeading(
                            title: subCategory.name,
                            onPressed: () => Get.to(
                              () => AllProductsScreen(
                                title: subCategory.name,
                                futureMethod: controller.getCategoryProducts(
                                  categoryId: subCategory.id,
                                  limit: -1,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: USizes.spaceBtwItems / 2),
                          //horizontal product card
                          SizedBox(
                            height: 120,
                            child: ListView.separated(
                              physics: BouncingScrollPhysics(),
                              scrollDirection: Axis.horizontal,
                              itemCount: products.length,
                              separatorBuilder: (context, index) =>
                                  SizedBox(width: USizes.spaceBtwItems / 2),
                              itemBuilder: (context, index) {
                                ProductModel product = products[index];
                                return UProductCartHorizontal(product: product);
                              },
                            ),
                          ),
                        ],
                      );
                    },
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
