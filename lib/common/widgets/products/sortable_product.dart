import 'package:ecommerce_app/common/widgets/layouts/grid_layout.dart';
import 'package:ecommerce_app/common/widgets/products/prodect_cards/prodect_card_vertical.dart';
import 'package:ecommerce_app/features/shop/controllers/product/all_products_controller.dart';
import 'package:ecommerce_app/features/shop/models/product_model.dart';
import 'package:ecommerce_app/utlis/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class USortableProduct extends StatelessWidget {
  const USortableProduct({super.key, required this.products});
  final List<ProductModel> products;

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(AllProductsController());
    controller.assignProducts(products);

    return Column(
      children: [
        //Filter
        DropdownButtonFormField(
          value: controller.selectedSortOption.value,
          decoration: InputDecoration(prefixIcon: Icon(Iconsax.sort)),
          items: ['Name', 'Low Price', 'Higher Price', 'Sale', 'Newest'].map((
            filter,
          ) {
            return DropdownMenuItem(value: filter, child: Text(filter));
          }).toList(),
          onChanged: (value) => controller.sortProducts(value!),
        ),
        SizedBox(height: USizes.spaceBtwSections),
        //Products
        Obx(
          () => UGridLayot(
            iteamCount: controller.products.length,
            itemBuilder: (context, index) =>
                UProductCardVertical(product: controller.products[index]),
          ),
        ),
      ],
    );
  }
}
