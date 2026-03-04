import 'package:ecommerce_app/common/widgets/appbar/appbar.dart';
import 'package:ecommerce_app/common/widgets/icon/circular_icon.dart';
import 'package:ecommerce_app/common/widgets/layouts/grid_layout.dart';
import 'package:ecommerce_app/common/widgets/loader/animation_loader.dart';
import 'package:ecommerce_app/common/widgets/products/prodect_cards/prodect_card_vertical.dart';
import 'package:ecommerce_app/common/widgets/shimmer/vertical_product_shimmer.dart';
import 'package:ecommerce_app/features/shop/controllers/product/favourite_controller.dart';
import 'package:ecommerce_app/features/shop/models/product_model.dart';

import 'package:ecommerce_app/navigation_menu.dart';
import 'package:ecommerce_app/utlis/constants/images.dart';
import 'package:ecommerce_app/utlis/constants/sizes.dart';
import 'package:ecommerce_app/utlis/helper/cloud_helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:get/state_manager.dart';

import 'package:iconsax/iconsax.dart';

class WishListScreen extends StatelessWidget {
  const WishListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //AppBar
      appBar: UAppBar(
        title: Text(
          "WishList",
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        actions: [
          UCircularIcon(
            icon: Iconsax.add,
            onPressed: () =>
                NavigationController.instance.selectedIndex.value = 0,
          ),
        ],
      ),
      //Body
      body: Padding(
        padding: EdgeInsets.all(USizes.defaultSpace),
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Obx(
            () => FutureBuilder(
              future: FavouriteController.instance.getFavouritesProducts(),
              builder: (context, snapshot) {
                final nothingFound = UAnimationLoader(
                  text: 'WishList is Empty...',
                  animation: UImages.pencilAnimation,
                  showActionButton: true,
                  actionText: "Let's Add Some",
                  onActionPressed: () =>
                      NavigationController.instance.selectedIndex.value = 0,
                );
                const loader = UVerticalProductShimmer(itemCount: 6);

                ///Handle Empty Data,Loading and Error
                final widget = UCloudHelperFunctions.checkMultiRecordState(
                  snapshot: snapshot,
                  loader: loader,
                  nothingFound: nothingFound,
                );
                if (widget != null) return widget;

                //Products Found
                List<ProductModel> products = snapshot.data!;
                return UGridLayot(
                  iteamCount: products.length,
                  itemBuilder: (context, index) =>
                      UProductCardVertical(product: products[index]),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
