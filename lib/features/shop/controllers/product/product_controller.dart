import 'package:ecommerce_app/data/repositories/product/product_repository.dart';
import 'package:ecommerce_app/features/shop/models/product_model.dart';
import 'package:ecommerce_app/utlis/constants/enums.dart';
import 'package:ecommerce_app/utlis/constants/text.dart';
import 'package:ecommerce_app/utlis/popups/snackbar_helpers.dart';
import 'package:get/get.dart';

class ProductController extends GetxController {
  static ProductController get instance => Get.find();

  //Variables
  final _repository = Get.put(ProductRepository());
  RxList<ProductModel> featuredProducts = <ProductModel>[].obs;
  RxBool isLoading = false.obs;

  @override
  void onInit() {
    getFeaturedProducts();
    super.onInit();
  }

  Future<List<ProductModel>> getAllProducts() async {
    try {
      List<ProductModel> products = await _repository.fetchAllProducts();
      return products;
    } catch (e) {
      USnackBarHelpers.errorSnackBar(title: 'Failed', message: e.toString());
      return [];
    }
  }
  //Fucation to get only 4 featured products

  Future<void> getFeaturedProducts() async {
    try {
      //start loadinf
      isLoading.value = true;
      //fetch feuatured products
      List<ProductModel> featuredProducts = await _repository
          .fetchFeaturedProduct();
      //assign products
      this.featuredProducts.assignAll(featuredProducts);
    } catch (e) {
      USnackBarHelpers.errorSnackBar(title: 'Failed', message: e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  //Fucation to get all featured products

  Future<List<ProductModel>> getAllFeaturedProducts() async {
    try {
      //fetch feuatured products
      List<ProductModel> featuredProducts = await _repository
          .fetchAllFeaturedProduct();
      return featuredProducts;
    } catch (e) {
      USnackBarHelpers.errorSnackBar(title: 'Failed', message: e.toString());
      return [];
    }
  }

  //Calculate sale percentage
  String? culculateSalePercentage(double orginalPrice, double? salePrice) {
    if (salePrice == null || salePrice <= 0.0) return null;

    if (orginalPrice <= 0.0) return null;

    double percenTag = ((orginalPrice - salePrice) / orginalPrice) * 100;

    return percenTag.toStringAsFixed(1);
  }

  //get product price or price range for variable products
  String getProductPriced(ProductModel product) {
    double smallesPrice = double.infinity;
    double largestPrice = 0.0;
    //if not variation exist,return the single price or sale price
    if (product.productType == ProductType.single.toString()) {
      return product.salePrice > 0
          ? product.salePrice.toString()
          : product.price.toString();
    } else {
      //calculate the smallest and largest price among varition
      for (final varitaion in product.productVariations!) {
        double varitionPrice = varitaion.salePrice > 0
            ? varitaion.salePrice
            : varitaion.price;
        if (varitionPrice > largestPrice) {
          largestPrice = varitionPrice;
        }
        if (varitionPrice < smallesPrice) {
          smallesPrice = varitionPrice;
        }
      }
      if (smallesPrice.isEqual(largestPrice)) {
        return largestPrice.toStringAsFixed(0);
      } else {
        return '${largestPrice.toStringAsFixed(0)} - ${UItext.currency}${smallesPrice.toStringAsFixed(0)}';
      }
    }
  }

  //get Product stock status
  String getProductStockStock(int stock) {
    return stock > 0 ? 'in Stock' : 'Out of  Stock';
  }
}
