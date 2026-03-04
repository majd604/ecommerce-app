import 'package:ecommerce_app/common/widgets/brands/brand_show_case.dart';
import 'package:ecommerce_app/common/widgets/shimmer/boxes_shimmer.dart';
import 'package:ecommerce_app/common/widgets/shimmer/list_tile_shimmer.dart';
import 'package:ecommerce_app/features/shop/controllers/brand/brand_controller.dart';
import 'package:ecommerce_app/features/shop/models/category_model.dart';
import 'package:ecommerce_app/utlis/constants/sizes.dart';
import 'package:ecommerce_app/utlis/helper/cloud_helper_functions.dart';
import 'package:flutter/widgets.dart';

class CategoryBrands extends StatelessWidget {
  const CategoryBrands({super.key, required this.category});

  final CategoryModel category;
  @override
  Widget build(BuildContext context) {
    final controller = BrandController.instance;
    return //Brand Show_case 1
    FutureBuilder(
      future: controller.getBrandsForCategory(category.id),
      builder: (context, snapshot) {
        final loader = Column(
          children: [
            UListTileShimmer(),
            const SizedBox(height: USizes.spaceBtwItems),
            UBoxesShimmer(),
            const SizedBox(height: USizes.spaceBtwItems),
          ],
        );
        //Handle loader,no Records, Error
        final widget = UCloudHelperFunctions.checkMultiRecordState(
          snapshot: snapshot,
          loader: loader,
        );
        if (widget != null) return widget;
        // Brands Found
        final brands = snapshot.data!;
        return ListView.builder(
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: brands.length,
          itemBuilder: (context, index) {
            final brand = brands[index];
            return FutureBuilder(
              future: controller.getBrandProduct(brand.id, limit: 3),
              builder: (context, snapshot) {
                //Handle loader,no Records, Error
                final widget = UCloudHelperFunctions.checkMultiRecordState(
                  snapshot: snapshot,
                );
                if (widget != null) return widget;
                //Products Found
                final products = snapshot.data!;
                return UBrandShowCase(
                  brand: brand,
                  images: products.map((product) => product.thumbnail).toList(),
                );
              },
            );
          },
        );
      },
    );
  }
}
