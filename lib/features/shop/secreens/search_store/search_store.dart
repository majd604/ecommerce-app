import 'package:ecommerce_app/common/style/padding.dart';
import 'package:ecommerce_app/common/widgets/appbar/appbar.dart';
import 'package:ecommerce_app/common/widgets/layouts/grid_layout.dart';
import 'package:ecommerce_app/common/widgets/products/prodect_cards/prodect_card_vertical.dart';
import 'package:ecommerce_app/features/shop/controllers/product/product_controller.dart';
import 'package:ecommerce_app/features/shop/secreens/search_store/widgets/search_store_brands.dart';
import 'package:ecommerce_app/utlis/constants/sizes.dart';
import 'package:ecommerce_app/utlis/helper/cloud_helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'widgets/search_store_categories.dart' show SearchStoreCategories;

class SearchStoreScreen extends StatelessWidget {
  const SearchStoreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    RxString searchText = ''.obs;
    return Scaffold(
      appBar: UAppBar(
        showBackArrow: true,
        title: Text(
          "Search",
          style: Theme.of(context).textTheme.headlineMedium,
        ),
      ),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Padding(
          padding: UPadding.screenPadding,
          child: Column(
            children: [
              ///Search Field
              Hero(
                tag: 'search_animation',
                child: Material(
                  color: Colors.transparent,
                  child: TextFormField(
                    decoration: InputDecoration(
                      prefixIcon: Icon(Iconsax.search_normal),
                      labelText: "Search for products",
                    ),
                    onChanged: (value) => searchText.value = value,
                  ),
                ),
              ),
              const SizedBox(height: USizes.spaceBtwSections),
              Obx(() {
                if (searchText.value.isEmpty) {
                  return Column(
                    children: [
                      //Brands
                      SearchStoreBrands(),
                      const SizedBox(height: USizes.spaceBtwSections),
                      //Categories
                      SearchStoreCategories(),
                    ],
                  );
                }
                return FutureBuilder(
                  future: ProductController.instance.getAllProducts(),
                  builder: (context, snapshot) {
                    //Handle Loading,Error,Empty States
                    final widget = UCloudHelperFunctions.checkMultiRecordState(
                      snapshot: snapshot,
                    );
                    if (widget != null) return widget;
                    //Data Found
                    final products = snapshot.data!;
                    final filteredProduct = products
                        .where(
                          (product) => product.title.toLowerCase().contains(
                            searchText.value.toLowerCase(),
                          ),
                        )
                        .toList();
                    return UGridLayot(
                      iteamCount: filteredProduct.length,
                      itemBuilder: (context, index) {
                        final product = filteredProduct[index];
                        return UProductCardVertical(product: product);
                      },
                    );
                  },
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}
