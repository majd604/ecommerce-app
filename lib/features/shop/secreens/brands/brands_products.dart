import 'package:ecommerce_app/common/style/padding.dart';
import 'package:ecommerce_app/common/widgets/appbar/appbar.dart';
import 'package:ecommerce_app/common/widgets/brands/brands_cart.dart';
import 'package:ecommerce_app/common/widgets/products/sortable_product.dart';
import 'package:ecommerce_app/common/widgets/shimmer/vertical_product_shimmer.dart';
import 'package:ecommerce_app/features/shop/controllers/brand/brand_controller.dart';
import 'package:ecommerce_app/features/shop/models/brand_model.dart';
import 'package:ecommerce_app/features/shop/models/product_model.dart';

import 'package:ecommerce_app/utlis/constants/sizes.dart';
import 'package:ecommerce_app/utlis/helper/cloud_helper_functions.dart';
import 'package:flutter/material.dart';

class BrandsProductsScreen extends StatelessWidget {
  const BrandsProductsScreen({
    super.key,
    required this.title,
    required this.brand,
  });
  final String title;
  final BrandModel brand;

  @override
  Widget build(BuildContext context) {
    final controller = BrandController.instance;
    return Scaffold(
      appBar: UAppBar(
        showBackArrow: true,
        title: Text(title, style: Theme.of(context).textTheme.headlineMedium),
      ),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Padding(
          padding: UPadding.screenPadding,
          child: Column(
            children: [
              //Brand
              UBrandCart(brand: brand),
              SizedBox(height: USizes.spaceBtwSections),

              //Brand Products
              FutureBuilder(
                future: controller.getBrandProduct(brand.id),
                builder: (context, asyncSnapshot) {
                  const loader = UVerticalProductShimmer();
                  Widget? widget = UCloudHelperFunctions.checkMultiRecordState(
                    snapshot: asyncSnapshot,
                    loader: loader,
                  );
                  if (widget != null) return widget;
                  List<ProductModel> products = asyncSnapshot.data!;
                  return USortableProduct(products: products);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
