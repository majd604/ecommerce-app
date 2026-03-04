import 'package:cached_network_image/cached_network_image.dart';
import 'package:ecommerce_app/common/widgets/appbar/appbar.dart';
import 'package:ecommerce_app/common/widgets/images/rounded_image.dart';
import 'package:ecommerce_app/common/widgets/products/favourite/favourite_icon.dart';
import 'package:ecommerce_app/features/shop/controllers/product/image_controller.dart';
import 'package:ecommerce_app/features/shop/models/product_model.dart';
import 'package:ecommerce_app/utlis/constants/colors.dart';
import 'package:ecommerce_app/utlis/constants/sizes.dart';
import 'package:ecommerce_app/utlis/helper/helper_function.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UProdectThumbnailAndSlider extends StatelessWidget {
  const UProdectThumbnailAndSlider({super.key, required this.product});
  final ProductModel product;

  @override
  Widget build(BuildContext context) {
    final dark = UHelperFunctions.isDarkMode(context);
    final controller = Get.put(ImageController());
    List<String> images = controller.getAllProducts(product);
    return Container(
      color: dark ? UColors.darkGrey : UColors.light,
      child: Stack(
        children: [
          //Image -Main Image Or Thumbnail
          SizedBox(
            height: 400,
            child: Padding(
              padding: EdgeInsets.all(USizes.productImageRadius * 2),
              child: Center(
                child: Obx(() {
                  final image = controller.selectedProductImages.value;
                  return GestureDetector(
                    onTap: () => controller.shoeEnLaregImage(image),
                    child: CachedNetworkImage(
                      imageUrl: image,
                      progressIndicatorBuilder: (context, url, progress) =>
                          CircularProgressIndicator(
                            color: UColors.primary,
                            value: progress.progress,
                          ),
                    ),
                  );
                }),
              ),
            ),
          ),
          //Image Slider
          Positioned(
            left: USizes.defaultSpace,
            right: 0,
            bottom: 30,
            child: SizedBox(
              height: 80,
              child: ListView.separated(
                separatorBuilder: (context, index) =>
                    SizedBox(width: USizes.spaceBtwItems),
                itemCount: images.length,
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) => Obx(() {
                  bool isSelectedImage =
                      controller.selectedProductImages.value == images[index];
                  return URoundedImage(
                    width: 80,
                    onTap: () =>
                        controller.selectedProductImages.value = images[index],
                    isImageNetwork: true,
                    backgroundColor: dark ? UColors.dark : UColors.white,
                    padding: EdgeInsets.all(USizes.sm),
                    border: Border.all(
                      color: isSelectedImage
                          ? UColors.primary
                          : Colors.transparent,
                    ),
                    imageUrl: images[index],
                  );
                }),
              ),
            ),
          ),
          //[AppBar] back_arrow and favourite button
          UAppBar(
            showBackArrow: true,
            actions: [UFavouriteIcon(productId: product.id)],
          ),
        ],
      ),
    );
  }
}
