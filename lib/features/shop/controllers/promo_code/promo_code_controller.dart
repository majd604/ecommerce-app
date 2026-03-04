import 'package:ecommerce_app/data/repositories/authentication_repositry.dart';
import 'package:ecommerce_app/data/repositories/promo_code/promo_code_repository.dart';
import 'package:ecommerce_app/features/shop/controllers/cart/cart_controller.dart';
import 'package:ecommerce_app/features/shop/models/promo_code_model.dart';
import 'package:ecommerce_app/utlis/constants/enums.dart';
import 'package:ecommerce_app/utlis/constants/text.dart';
import 'package:ecommerce_app/utlis/helper/network_manager.dart';
import 'package:ecommerce_app/utlis/helper/pricing_calculator.dart';
import 'package:ecommerce_app/utlis/popups/snackbar_helpers.dart';
import 'package:get/get.dart';

class PromoCodeController extends GetxController {
  static PromoCodeController get instance => Get.find();

  //Variables
  final _repository = Get.put(PromoCodeRepository());
  final cartController = CartController.instance;
  Rx<PromoCodeModel> appliedPromoCode = PromoCodeModel.empty().obs;
  RxString promoCode = ''.obs;
  RxBool isLoading = false.obs;
  //on Prome Change
  void onPromeChange(String value) => promoCode.value = value;
  //Apply Promo Code
  Future<void> applyPromeCode() async {
    try {
      //Start Loading
      isLoading.value = true;
      //Check internet Connection
      bool isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) {
        USnackBarHelpers.warningSnackBar(
          title: 'No Internet Connection',
          message: 'Please check your internet connection and try again',
        );
        return;
      }

      //get prome code details
      PromoCodeModel promoCode = await _repository.fetchSinglePromoCode(
        this.promoCode.value,
      );
      if (promoCode.id.isEmpty) {
        USnackBarHelpers.warningSnackBar(
          title: 'Invalid Promo Code',
          message:
              'The promo code you entered is invalid. Please try again with a valid promo code.',
        );
        return;
      }

      //Check Prome Code Durations
      DateTime now = DateTime.now();
      if (promoCode.endDate!.isBefore(now)) {
        USnackBarHelpers.warningSnackBar(
          title: 'Promo Code Expired',
          message:
              'The promo code you entered has expired. Please try again with a valid promo code.',
        );
        return;
      }

      //check if the promo code is active
      if (!promoCode.isActive) {
        USnackBarHelpers.warningSnackBar(
          title: 'Prome Code Is Not Active',
          message:
              'The promo code you entered is not active. Please try again with a valid promo code.',
        );
        return;
      }
      //check order minimum price
      double subTotal = cartController.totalCartPrice.value;
      double totalPrice = UPricingCalculator.calculateTotalPrice(
        subTotal,
        'Egypt',
      );
      if (!(totalPrice >= promoCode.minOrderPrice)) {
        USnackBarHelpers.warningSnackBar(
          title: 'Promo Code Not Applicable',
          message:
              'Minimum order amount must be ${UItext.currency}${promoCode.minOrderPrice.toStringAsFixed(0)} to use this promo code.',
        );
        return;
      }

      //check available prome codes
      if (!(promoCode.noOfPromoCodes > 0)) {
        USnackBarHelpers.warningSnackBar(
          title: 'Promo Code Expired',
          message:
              'The promo code you entered has expired. Please try again with a valid promo code.',
        );
        return;
      }
      //check
      List<String> userids = promoCode.userIds ?? [];
      String currentUserId = AuthenticationRepositry.instance.currentUser!.uid;
      if (userids.contains(currentUserId)) {
        USnackBarHelpers.warningSnackBar(
          title: 'Already Applied',
          message: 'You Have Already Apllied This Promo Code',
        );
        return;
      }
      //assign to Rx Variable
      appliedPromoCode.value = promoCode;
    } catch (e) {
      USnackBarHelpers.errorSnackBar(
        title: 'Promo Code Error',
        message: e.toString(),
      );
    } finally {
      isLoading.value = false;
    }
  }

  //Calculate price after promo code applied
  double calculatePriceAfterDiscount(
    PromoCodeModel promoCode,
    double totalPrice,
  ) {
    if (promoCode.id.isNotEmpty) {
      if (promoCode.discountType == DiscountType.percentage) {
        return UPricingCalculator.calculatePercentageDiscount(
          totalPrice,
          promoCode.discount,
        );
      } else {
        return UPricingCalculator.calculateFixedDiscount(
          totalPrice,
          promoCode.discount,
        );
      }
    }
    return totalPrice;
  }

  //Get Discount Price
  String getDiscountPrice() {
    if (appliedPromoCode.value.id.isEmpty) return '';

    if (appliedPromoCode.value.discountType == DiscountType.percentage) {
      return '${appliedPromoCode.value.discount}%';
    } else {
      return '${UItext.currency}${appliedPromoCode.value.discount}';
    }
  }

  /// Decrase no of promo codes after successfully applied
  Future<void> decreaseNoOfPromoCode() async {
    try {
      if (appliedPromoCode.value.id.isEmpty) return;
      int noOfPromoCodes = appliedPromoCode.value.noOfPromoCodes - 1;
      _repository.updateSinfleField(
        appliedPromoCode.value,
        'noOfPromoCodes',
        noOfPromoCodes,
      );
    } catch (e) {
      USnackBarHelpers.errorSnackBar(
        title: 'Promo Code Error',
        message: e.toString(),
      );
    }
  }

  ///Funcation to add the user to applied promo code
  Future<void> addUserToPromoCode() async {
    try {
      if (appliedPromoCode.value.id.isEmpty) return;
      List<String> userIds = appliedPromoCode.value.userIds ?? [];
      userIds.add(AuthenticationRepositry.instance.currentUser!.uid);

      await _repository.updateSinfleField(
        appliedPromoCode.value,
        'userIds',
        userIds,
      );
    } catch (e) {
      USnackBarHelpers.errorSnackBar(title: 'Error', message: e.toString());
    }
  }
}
