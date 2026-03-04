import 'package:ecommerce_app/common/style/padding.dart';
import 'package:ecommerce_app/common/widgets/button/elevated_button.dart';
import 'package:ecommerce_app/common/widgets/texts/section_header.dart';
import 'package:ecommerce_app/features/shop/controllers/cart/cart_controller.dart';
import 'package:ecommerce_app/features/shop/models/product_model.dart';
import 'package:ecommerce_app/features/shop/secreens/product_details/widgets/bootom_add_to_cart.dart';
import 'package:ecommerce_app/features/shop/secreens/product_details/widgets/product_attributes.dart';
import 'package:ecommerce_app/features/shop/secreens/product_details/widgets/product_meta_data.dart';
import 'package:ecommerce_app/features/shop/secreens/product_details/widgets/product_thumbail_and_slider.dart';
import 'package:ecommerce_app/utlis/constants/enums.dart';
import 'package:ecommerce_app/utlis/constants/sizes.dart';

import 'package:flutter/material.dart';
import 'package:readmore/readmore.dart';

class ProdectDetailsScreen extends StatelessWidget {
  const ProdectDetailsScreen({super.key, required this.product});
  final ProductModel product;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Column(
          children: [
            //Prodect Image With Slider
            UProdectThumbnailAndSlider(product: product),
            //[Product Details]
            Padding(
              padding: UPadding.screenPadding,
              child: Column(
                children: [
                  //Price,Title,Stock And Brand
                  UProductMetaData(product: product),
                  //Attributes
                  if (product.productType ==
                      ProductType.variable.toString()) ...[
                    UProductAttributes(product: product),
                    SizedBox(height: USizes.spaceBtwSections),
                  ],
                  //CheckOut Button
                  UElevatedButton(
                    onPress: () => CartController.instance.checkOut(product),
                    child: Text("Check Out"),
                  ),
                  SizedBox(height: USizes.spaceBtwSections),
                  USectinHeading(title: "Description", showActionButton: false),
                  SizedBox(height: USizes.spaceBtwItems),
                  ReadMoreText(
                    product.description ?? '',
                    trimLines: 2,
                    trimMode: TrimMode.Line,
                    trimCollapsedText: 'Show More',
                    trimExpandedText: "Show Less",
                    moreStyle: TextStyle(
                      fontSize: 14.0,
                      fontWeight: FontWeight.w800,
                    ),
                    lessStyle: TextStyle(
                      fontSize: 14.0,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  SizedBox(height: USizes.spaceBtwSections),
                ],
              ),
            ),
          ],
        ),
      ),

      //Bottom Navigation Bar
      bottomNavigationBar: UBootomAddToCart(product: product),
    );
  }
}
