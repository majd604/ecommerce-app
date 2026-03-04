import 'package:ecommerce_app/data/repositories/brand/brand_repository.dart';
import 'package:ecommerce_app/data/repositories/product/product_repository.dart';
import 'package:ecommerce_app/features/shop/models/brand_model.dart';
import 'package:ecommerce_app/features/shop/models/product_model.dart';
import 'package:ecommerce_app/utlis/popups/snackbar_helpers.dart';
import 'package:get/get.dart';

class BrandController extends GetxController {
  static BrandController get instance => Get.find();

  //Variables
  final _respository = Get.put(BrandRepository());
  RxList<BrandModel> allBrands = <BrandModel>[].obs;
  RxList<BrandModel> featuredBrands = <BrandModel>[].obs;
  RxBool isLoading = false.obs;
  @override
  void onInit() {
    getBrands();
    super.onInit();
  }

  //Get All Brands And Featured Brands
  Future<void> getBrands() async {
    try {
      //start loading
      isLoading.value = true;
      List<BrandModel> allBrands = await _respository.fetshBrands();
      this.allBrands.assignAll(allBrands);
      featuredBrands.assignAll(
        allBrands.where((brand) => brand.isFeatured ?? false).toList(),
      );
    } catch (e) {
      USnackBarHelpers.errorSnackBar(title: 'Failed', message: e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  //Get Brands Specific Products
  Future<List<ProductModel>> getBrandProduct(
    String brandId, {
    int limit = -1,
  }) async {
    try {
      List<ProductModel> products = await ProductRepository.instance
          .getProductsForBrand(brandId: brandId, limit: limit);
      return products;
    } catch (e) {
      USnackBarHelpers.errorSnackBar(title: 'Failed', message: e.toString());
      return [];
    }
  }

  //Get Brands Specific Category
  Future<List<BrandModel>> getBrandsForCategory(String categoryId) async {
    try {
      final brands = await _respository.fetshBrandsForCategory(categoryId);
      return brands;
    } catch (e) {
      USnackBarHelpers.errorSnackBar(title: 'Failed', message: e.toString());
      return [];
    }
  }
}
