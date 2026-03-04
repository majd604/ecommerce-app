import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_app/data/repositories/authentication_repositry.dart';
import 'package:ecommerce_app/features/personalization/models/address_model.dart';
import 'package:ecommerce_app/utlis/constants/keys.dart';
import 'package:ecommerce_app/utlis/exceptions/firebase_auth_exceptions.dart';
import 'package:ecommerce_app/utlis/exceptions/format_exceptions.dart';
import 'package:ecommerce_app/utlis/exceptions/platform_exceptions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class AddressRepository extends GetxController {
  static AddressRepository get instance => Get.find();

  //Variables
  final _db = FirebaseFirestore.instance;

  ///[Upload] - Funcation to store user address
  Future<String> addAddress(AddressModel address) async {
    try {
      final userId = AuthenticationRepositry.instance.currentUser!.uid;
      final currentAddress = await _db
          .collection(UKeys.userCollection)
          .doc(userId)
          .collection(UKeys.addressCollection)
          .add(address.toJson());
      return currentAddress.id;
    } on FirebaseAuthException catch (e) {
      throw UFirebaseAuthException(e.code).message;
    } on FormatException catch (_) {
      throw UFormatException();
    } on PlatformException catch (e) {
      throw UPlatformException(e.code).message;
    } catch (e) {
      throw 'Something went wrong while saving address information. Please try again ';
    }
  }

  ///[Upload] - Funcation to fetch user address
  Future<List<AddressModel>> fetchUserAddress() async {
    try {
      final userId = AuthenticationRepositry.instance.currentUser!.uid;
      if (userId.isEmpty) throw 'User not found.Please Login again';
      final query = await _db
          .collection(UKeys.userCollection)
          .doc(userId)
          .collection(UKeys.addressCollection)
          .get();
      if (query.docs.isNotEmpty) {
        List<AddressModel> address = query.docs
            .map((doc) => AddressModel.fromDocumentSnapshot(doc))
            .toList();
        return address;
      }
      return [];
    } on FirebaseAuthException catch (e) {
      throw UFirebaseAuthException(e.code).message;
    } on FormatException catch (_) {
      throw UFormatException();
    } on PlatformException catch (e) {
      throw UPlatformException(e.code).message;
    } catch (e) {
      throw 'Unable to find address.Please try again ';
    }
  }

  Future<void> upadteSelectedField(String addressId, bool selected) async {
    try {
      final userId = AuthenticationRepositry.instance.currentUser!.uid;
      await _db
          .collection(UKeys.userCollection)
          .doc(userId)
          .collection(UKeys.addressCollection)
          .doc(addressId)
          .update({'selectedAddress': selected});
    } catch (e) {
      throw 'Unaple to updateb selected address .Please try again ';
    }
  }

  Future<void> deleteAddress(String addressId) async {
    try {
      final userId = AuthenticationRepositry.instance.currentUser!.uid;
      await _db
          .collection(UKeys.userCollection)
          .doc(userId)
          .collection(UKeys.addressCollection)
          .doc(addressId)
          .delete();
    } on FirebaseAuthException catch (e) {
      throw UFirebaseAuthException(e.code).message;
    } on FormatException catch (_) {
      throw UFormatException();
    } on PlatformException catch (e) {
      throw UPlatformException(e.code).message;
    } catch (e) {
      throw 'Unable to delete address. Please try again. ';
    }
  }
}
