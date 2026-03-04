import 'package:ecommerce_app/data/repositories/authentication_repositry.dart';
import 'package:ecommerce_app/features/shop/controllers/product/variation_controller.dart';
import 'package:ecommerce_app/features/shop/models/cart_iteam_model.dart';
import 'package:ecommerce_app/features/shop/models/product_model.dart';
import 'package:ecommerce_app/features/shop/models/product_variation_model.dart';
import 'package:ecommerce_app/features/shop/secreens/check_out/check_out.dart';
import 'package:ecommerce_app/utlis/constants/enums.dart';
import 'package:ecommerce_app/utlis/constants/keys.dart';
import 'package:ecommerce_app/utlis/popups/snackbar_helpers.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class CartController extends GetxController {
  static CartController get instance => Get.find();

  // Variables
  final _storge = GetStorage(AuthenticationRepositry.instance.currentUser!.uid);
  RxInt noOfCartItems = 0.obs;
  RxDouble totalCartPrice = 0.0.obs;
  RxInt productQuantityInCart = 0.obs;
  RxList<CartItemModel> cartItems = <CartItemModel>[].obs;

  final variationController = VariationController.instance;

  CartController() {
    loadCartItems();
  }

  //load all cart items from local storage
  void loadCartItems() {
    List<dynamic>? storedCartItems = _storge.read(UKeys.cartItemsKey);
    if (storedCartItems != null) {
      cartItems.assignAll(
        storedCartItems.map(
          (item) => CartItemModel.fromJson(item as Map<String, dynamic>),
        ),
      );
      updateCartTotal();
    }
  }

  //Add Item In The Cart
  void addToCart(ProductModel product) {
    //Check Quantity of the product
    if (productQuantityInCart < 1) {
      USnackBarHelpers.customToast(message: 'Select Quantity...');
      return;
    }
    //Check Variation of product if it has
    if (product.productType == ProductType.variable.toString() &&
        variationController.selectedVariation.value.id.isEmpty) {
      USnackBarHelpers.customToast(message: "Select Variation...");
      return;
    }
    //Out of Stock Status
    if (product.productType == ProductType.variable.toString()) {
      if (variationController.selectedVariation.value.stock < 1) {
        USnackBarHelpers.warningSnackBar(
          title: 'Out Of Stock...',
          message: 'This Product is out of stock',
        );
        return;
      }
    } else {
      if (product.stock < 1) {
        USnackBarHelpers.warningSnackBar(
          title: 'Out Of Stock...',
          message: 'This Product is out of stock',
        );
      }
    }
    //Convert the productModel to CartItemModel with givin quantity
    CartItemModel selectedCartItem = convertToCartItem(
      product,
      productQuantityInCart.value,
    );
    //check if already added in the cart
    int index = cartItems.indexWhere(
      (cartItem) =>
          cartItem.productId == selectedCartItem.productId &&
          selectedCartItem.variationId == cartItem.variationId,
    );
    if (index > 0) {
      // this quantity is already added or updated/removed from the cart
      cartItems[index].quantity = selectedCartItem.quantity;
    } else {
      cartItems.add(selectedCartItem);
    }
    //Update Cart
    updateCart();
    USnackBarHelpers.customToast(
      message: 'Your Product has been added to the cart',
    );
  }

  Future<void> checkOut(ProductModel product) async {
    //clear the cart
    cartItems.clear();

    //set quantity to 1 by defualt,

    productQuantityInCart.value = 1;

    //Check Vaeiation of product if its variable product
    if (product.productType == ProductType.variable.toString() &&
        variationController.selectedVariation.value.id.isEmpty) {
      USnackBarHelpers.customToast(message: 'Select Variation ');
      return;
    }

    //Out of stock status
    if (product.productType == ProductType.variable.toString()) {
      if (variationController.selectedVariation.value.stock < 1) {
        USnackBarHelpers.warningSnackBar(
          title: 'Out of Stock',
          message: 'This variation is out of stock',
        );
        return;
      } else {
        if (product.stock < 1) {
          USnackBarHelpers.warningSnackBar(
            title: 'Out of Stock',
            message: 'This variation is out of stock',
          );
        }
      }
      //covert the product model to cart iteam model with qiven quantity
      CartItemModel selectedCartItem = convertToCartItem(
        product,
        productQuantityInCart.value,
      );
      //add item to cart
      cartItems.add(selectedCartItem);

      //Update cart total
      updateCartTotal();
      //redirect to check out screen
      await Get.to((() => CheckOutScreen()));
      //loader previes cart items
      loadCartItems();
    }
  }

  //Add one item to cart
  void addOneToCart(CartItemModel item) {
    int index = cartItems.indexWhere(
      (cartitem) =>
          item.productId == cartitem.productId &&
          item.variationId == cartitem.variationId,
    );
    if (index >= 0) {
      cartItems[index].quantity += 1;
    } else {
      cartItems.add(item);
    }
    updateCart();
  }

  //remove one item from the cart
  void removeOneFromCart(CartItemModel item) {
    int index = cartItems.indexWhere(
      (cartitem) =>
          item.productId == cartitem.productId &&
          item.variationId == cartitem.variationId,
    );
    if (index >= 0) {
      if (cartItems[index].quantity > 1) {
        cartItems[index].quantity -= 1;
      } else {
        cartItems[index].quantity == 1
            ? removeFromCartDialog(index)
            : cartItems.removeAt(index);
      }
    }
    updateCart();
  }

  //Show Dialog to Remove item from cart
  void removeFromCartDialog(int index) {
    Get.defaultDialog(
      title: 'Remove Product',
      middleText: 'Are You Sure you want remove this product',
      onConfirm: () {
        cartItems.removeAt(index);
        updateCart();
        USnackBarHelpers.customToast(
          message: 'Your Product Removed From The Cart',
        );
        Get.back();
      },
      onCancel: () {},
    );
  }

  //Get total quantity of same specific product
  int getProductQuantityInCart(String productId) {
    final itemQuantity = cartItems
        .where((cartItem) => cartItem.productId == productId)
        .fold(
          0,
          (previousValue, cartItem) => previousValue + cartItem.quantity,
        );
    return itemQuantity;
  }

  //fet variation's quantity of the specific product
  int getVariationQuantityInCart(String productId, String variationId) {
    CartItemModel cartItemModel = cartItems.firstWhere(
      (item) => item.productId == productId && item.variationId == variationId,
      orElse: () => CartItemModel.empty(),
    );
    return cartItemModel.quantity;
  }

  //Update Cart
  void updateCart() {
    updateCartTotal();
    saveCartItems();
    cartItems.refresh();
  }

  //Save Cart Items into loacl storage
  void saveCartItems() {
    List<Map<String, dynamic>> cartItemsList = cartItems
        .map((item) => item.toJson())
        .toList();
    _storge.write(UKeys.cartItemsKey, cartItemsList);
  }

  //update the total price & no of items of the cart
  void updateCartTotal() {
    double calculateTotalPrice = 0.0;
    int calculateNoOfItems = 0;
    for (final item in cartItems) {
      calculateTotalPrice += (item.price) * item.quantity.toDouble();
      calculateNoOfItems += item.quantity;
    }

    totalCartPrice.value = calculateTotalPrice;
    noOfCartItems.value = calculateNoOfItems;
  }

  //Convert productModel to CartItemModel
  CartItemModel convertToCartItem(ProductModel product, int quantity) {
    if (product.productType == ProductType.single.toString()) {
      //Reset Variation in case of single product
      variationController.resetSelectedAttributes();
    }
    ProductVariationModel variation =
        variationController.selectedVariation.value;
    bool isVariation = variation.id.isNotEmpty;
    String image = isVariation ? variation.image : product.thumbnail;
    double price = isVariation
        ? variation.salePrice > 0.0
              ? variation.salePrice
              : variation.price
        : product.salePrice > 0.0
        ? product.salePrice
        : product.price;
    return CartItemModel(
      productId: product.id,
      quantity: quantity,
      brandName: product.brand != null ? product.brand!.name : '',
      title: product.title,
      image: image,
      price: price,
      selectedVariation: isVariation ? variation.attributeValues : null,
      variationId: variation.id,
    );
  }

  //Initializa already added items count in the cart
  void updateAlreadyAddedProductCount(ProductModel product) {
    if (product.productType == ProductType.single.toString()) {
      productQuantityInCart.value = getProductQuantityInCart(product.id);
    } else {
      String variationId = variationController.selectedVariation.value.id;
      if (variationId.isNotEmpty) {
        productQuantityInCart.value = getVariationQuantityInCart(
          product.id,
          variationId,
        );
      } else {
        productQuantityInCart.value = 0;
      }
    }
  }

  // clear the cart
  void clearCart() {
    productQuantityInCart.value = 0;
    cartItems.clear();
    updateCart();
  }
}
