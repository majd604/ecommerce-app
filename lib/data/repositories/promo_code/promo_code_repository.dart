import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_app/features/shop/models/promo_code_model.dart';
import 'package:ecommerce_app/utlis/constants/keys.dart';
import 'package:ecommerce_app/utlis/exceptions/firebase_auth_exceptions.dart';
import 'package:ecommerce_app/utlis/exceptions/format_exceptions.dart';
import 'package:ecommerce_app/utlis/exceptions/platform_exceptions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class PromoCodeRepository extends GetxController {
  static PromoCodeRepository get instance => Get.find();

  //Variables
  final _db = FirebaseFirestore.instance;

  ///[Upload] Funcation to upload List of promo codes to Firestore
  Future<void> uploadPromoCode(List<PromoCodeModel> promoCodes) async {
    try {
      for (final promoCode in promoCodes) {
        await _db
            .collection(UKeys.promoCodeCollection)
            .doc(promoCode.id)
            .set(promoCode.toJson());
      }
    } on FirebaseAuthException catch (e) {
      throw UFirebaseAuthException(e.code).message;
    } on FormatException catch (_) {
      throw UFormatException();
    } on PlatformException catch (e) {
      throw UPlatformException(e.code).message;
    } catch (e) {
      throw 'Something went wrong ,Please try again ';
    }
  }

  ///[Fetch] Funcation to fetch single promo code from Firestore
  Future<PromoCodeModel> fetchSinglePromoCode(String code) async {
    try {
      final query = await _db
          .collection(UKeys.promoCodeCollection)
          .where('code', isEqualTo: code)
          .get();
      if (query.docs.isNotEmpty) {
        PromoCodeModel promoCode = PromoCodeModel.fromSnapShot(
          query.docs.first,
        );
        return promoCode;
      }
      return PromoCodeModel.empty();
    } on FirebaseAuthException catch (e) {
      throw UFirebaseAuthException(e.code).message;
    } on FormatException catch (_) {
      throw UFormatException();
    } on PlatformException catch (e) {
      throw UPlatformException(e.code).message;
    } catch (e) {
      throw 'Something went wrong ,Please try again ';
    }
  }

  ///[Update] - Funcation to update single field of promo codes
  Future<void> updateSinfleField(
    PromoCodeModel promoCode,
    String key,
    dynamic value,
  ) async {
    try {
      _db.collection(UKeys.promoCodeCollection).doc(promoCode.id).update({
        key: value,
      });
    } on FirebaseAuthException catch (e) {
      throw UFirebaseAuthException(e.code).message;
    } on FormatException catch (_) {
      throw UFormatException();
    } on PlatformException catch (e) {
      throw UPlatformException(e.code).message;
    } catch (e) {
      throw 'Something went wrong ,Please try again ';
    }
  }
}
