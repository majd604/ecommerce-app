import 'package:cached_network_image/cached_network_image.dart';
import 'package:ecommerce_app/features/shop/models/product_model.dart';
import 'package:ecommerce_app/utlis/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ImageController extends GetxController {
  static ImageController get instance => Get.find();

  //Variabels
  RxString selectedProductImages = ''.obs;

  //Funcation to load all images of products

  List<String> getAllProducts(ProductModel product) {
    Set<String> images = {};

    //load Thumbnail image
    images.add(product.thumbnail);

    //assighn thumbnail as selcetd image
    selectedProductImages.value = product.thumbnail;

    //load all images of products

    if (product.images != null && product.images!.isNotEmpty) {
      images.addAll(product.images!);
    }
    //load all images from product variation

    if (product.productVariations != null &&
        product.productVariations!.isNotEmpty) {
      List<String> variationsImages = product.productVariations!
          .map((variations) => variations.image)
          .toList();
      images.addAll(variationsImages);
    }
    return images.toList();
  }

  void shoeEnLaregImage(String image) {
    Get.to(
      fullscreenDialog: true,
      () => Dialog.fullscreen(
        child: Column(
          children: [
            //image
            Padding(
              padding: EdgeInsetsGeometry.symmetric(
                vertical: USizes.defaultSpace * 2,
                horizontal: USizes.defaultSpace,
              ),
              child: CachedNetworkImage(imageUrl: image),
            ),
            SizedBox(height: USizes.spaceBtwSections),
            //Close Button
            Align(
              alignment: Alignment.bottomCenter,
              child: SizedBox(
                width: 150,
                child: OutlinedButton(
                  onPressed: Get.back,
                  child: Text("Close"),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
