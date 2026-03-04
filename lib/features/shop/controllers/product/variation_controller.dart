import 'package:ecommerce_app/features/shop/controllers/cart/cart_controller.dart';
import 'package:ecommerce_app/features/shop/controllers/product/image_controller.dart';
import 'package:ecommerce_app/features/shop/models/product_model.dart';
import 'package:ecommerce_app/features/shop/models/product_variation_model.dart';
import 'package:get/get.dart';

class VariationController extends GetxController {
  static VariationController get instance => Get.find();

  //Variables
  RxMap selectedAttributes = {}.obs; //{color:[Blue,Green,Red]}
  Rx<ProductVariationModel> selectedVariation =
      ProductVariationModel.empty().obs;
  RxString variationStockStaus = ''.obs;

  //selected Attributes and Variation
  void onAttributesSelected(
    ProductModel product,
    attributesName,
    attributeValue,
  ) {
    Map<String, dynamic> selectedAttributes = Map<String, dynamic>.from(
      this.selectedAttributes,
    );
    selectedAttributes[attributesName] = attributeValue;
    this.selectedAttributes[attributesName] = attributeValue;

    //get selected variation
    ProductVariationModel selectedVariation = product.productVariations!
        .firstWhere(
          (variations) => isSameAttributesValue(
            variations.attributeValues,
            selectedAttributes,
          ),
          orElse: () => ProductVariationModel.empty(),
        );
    //show the selected image as min image
    if (selectedVariation.image.isNotEmpty) {
      ImageController.instance.selectedProductImages.value =
          selectedVariation.image;
    }
    if (selectedVariation.id.isNotEmpty) {
      final cartController = CartController.instance;
      cartController.productQuantityInCart.value = cartController
          .getVariationQuantityInCart(product.id, selectedVariation.id);
    }
    //Assign selected variation to Rx variable
    this.selectedVariation(selectedVariation);
    getProductVariationStockStatus();
  }

  //Check if selected attribute matches any varation attribute
  bool isSameAttributesValue(
    Map<String, dynamic> variationAttributes,
    Map<String, dynamic> selectedAttributes,
  ) {
    //if selectedAttributes contains 3 attributes and current variatiom contains 2 then return
    if (variationAttributes.length != selectedAttributes.length) return false;
    //if ant of the attributes is different then return ['Green':'Lareg']!=['Green':'Small']
    for (final key in variationAttributes.keys) {
      if (variationAttributes[key] != selectedAttributes[key]) return false;
    }
    return true;
  }

  Set<String?> getAttributesAvilabilityInVariation(
    List<ProductVariationModel> variations,
    String atrributName,
  ) {
    //pass the variation to check wich attributes are availabel and stock is not 0
    final availlableAttributesValues = variations
        .where(
          (variation) =>
              variation.attributeValues[atrributName]!.isNotEmpty &&
              variation.attributeValues[atrributName] != null &&
              variation.stock > 0,
        )
        .map((variation) => variation.attributeValues[atrributName])
        .toSet();
    return availlableAttributesValues;
  }

  //Get Product Variation Price

  String getVariationPrice() {
    return (selectedVariation.value.salePrice > 0
            ? selectedVariation.value.salePrice
            : selectedVariation.value.price)
        .toStringAsFixed(0);
  }

  //check product variation stock status
  void getProductVariationStockStatus() {
    variationStockStaus.value = selectedVariation.value.stock > 0
        ? 'In Stock'
        : 'Out of Stock';
  }

  //Reset Selected Attributes when switching products
  void resetSelectedAttributes() {
    selectedAttributes.clear();
    variationStockStaus.value = '';
    selectedVariation.value = ProductVariationModel.empty();
  }
}
