import 'dart:convert';

import 'package:ecommerce_app/data/repositories/authentication_repositry.dart';
import 'package:ecommerce_app/data/repositories/product/product_repository.dart';
import 'package:ecommerce_app/features/shop/models/product_model.dart';
import 'package:ecommerce_app/utlis/popups/snackbar_helpers.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class FavouriteController extends GetxController {
  static FavouriteController get instance => Get.find();

  //Variables

  RxMap<String, bool> favourites = <String, bool>{}.obs;

  final _storge = GetStorage(AuthenticationRepositry.instance.currentUser!.uid);

  @override
  void onInit() {
    initFavourites();
    super.onInit();
  }

  //load favourites from local storge
  Future<void> initFavourites() async {
    String? encodeFavourites = _storge.read('favourites');
    if (encodeFavourites == null) return;
    Map<String, dynamic> storedFavourites =
        jsonDecode(encodeFavourites) as Map<String, dynamic>;

    favourites.assignAll(
      storedFavourites.map((key, value) => MapEntry(key, value as bool)),
    );
  }

  //Funcation to add or remove product to wishlist
  void toggleFavouriteProduct(String productId) {
    if (favourites.containsKey(productId)) {
      favourites.remove(productId);
      saveFavouritesStorge();
      USnackBarHelpers.customToast(
        message: 'Product has been removed from WishList',
      );
    } else {
      favourites[productId] = true;
      saveFavouritesStorge();
      USnackBarHelpers.customToast(
        message: 'Product has been added from WishList',
      );
    }
  }

  //Funcation to store favourites in local storge
  void saveFavouritesStorge() {
    String encodeFavourites = jsonEncode(favourites);
    _storge.write('favourites', encodeFavourites);
  }

  //check if the product availabel in favourite
  bool isFavourite(String productId) {
    return favourites[productId] ?? false;
  }

  //Funcation to get all favourites  products only
  Future<List<ProductModel>> getFavouritesProducts() async {
    final productIds = favourites.keys.toList();
    return await ProductRepository.instance.getFavouritesProduct(productIds);
  }
}
