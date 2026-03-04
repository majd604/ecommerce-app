import 'package:ecommerce_app/data/repositories/category/category_repository.dart';
import 'package:ecommerce_app/data/repositories/product/product_repository.dart';
import 'package:ecommerce_app/features/shop/models/category_model.dart';
import 'package:ecommerce_app/features/shop/models/product_model.dart';
import 'package:ecommerce_app/utlis/popups/snackbar_helpers.dart';
import 'package:get/get.dart';

class CategoryController extends GetxController {
  static CategoryController get instance => Get.find();
  RxBool isCaregoriesLoading = false.obs;

  @override
  void onInit() {
    fetshCategories();
    super.onInit();
  }

  //Variables
  final _repostiory = Get.put(CategoryRepository());
  RxList<CategoryModel> allCategories = <CategoryModel>[].obs;
  RxList<CategoryModel> featuredCategories = <CategoryModel>[].obs;
  //Funcation to get all categories & featured categories from firebase
  Future<void> fetshCategories() async {
    try {
      //start loading
      isCaregoriesLoading.value = true;
      //fetch categories
      List<CategoryModel> categories = await _repostiory.getAllCategories();
      allCategories.assignAll(categories);
      //get featured categories
      featuredCategories.assignAll(
        categories.where(
          (category) => category.isFeatured && category.parentId.isEmpty,
        ),
      );
    } catch (e) {
      USnackBarHelpers.errorSnackBar(title: "Failed", message: e.toString());
    } finally {
      //stop loading
      isCaregoriesLoading.value = false;
    }
  }

  //Get Category Products
  Future<List<ProductModel>> getCategoryProducts({
    required String categoryId,
    int limit = 4,
  }) async {
    try {
      final producst = ProductRepository.instance.getProductsForCaregory(
        categoryId: categoryId,
        limit: limit,
      );
      return producst;
    } catch (e) {
      USnackBarHelpers.errorSnackBar(title: 'Failed', message: e.toString());
      return [];
    }
  }

  //Get Sub Category of selected categories
  Future<List<CategoryModel>> getSubCategory(String categoryId) async {
    try {
      final subCategory = await _repostiory.getSubCategories(categoryId);
      return subCategory;
    } catch (e) {
      USnackBarHelpers.errorSnackBar(title: 'Failed', message: e.toString());
      return [];
    }
  }
}
