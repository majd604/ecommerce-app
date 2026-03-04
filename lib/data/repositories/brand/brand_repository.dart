// ignore_for_file: avoid_print

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_app/data/services/cloudinary_services.dart';
import 'package:ecommerce_app/features/shop/models/brand_category_model.dart';
import 'package:ecommerce_app/features/shop/models/brand_model.dart';
import 'package:ecommerce_app/utlis/constants/keys.dart';
import 'package:ecommerce_app/utlis/exceptions/firebase_auth_exceptions.dart';
import 'package:ecommerce_app/utlis/exceptions/format_exceptions.dart';
import 'package:ecommerce_app/utlis/exceptions/platform_exceptions.dart';
import 'package:ecommerce_app/utlis/helper/helper_function.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart' as dio;

class BrandRepository extends GetxController {
  static BrandRepository get instance => Get.find();

  //Variables
  final _db = FirebaseFirestore.instance;
  final _cloudinaryServices = Get.put(CloudinaryServices());

  ///[Upload ]function to upload all brands

  Future<void> uploadBrands(List<BrandModel> brands) async {
    try {
      for (BrandModel brand in brands) {
        //convert asset path to file
        File brandImage = await UHelperFunctions.assetToFile(brand.image);
        //upload brand image to cloudinary
        dio.Response response = await _cloudinaryServices.uploadImage(
          brandImage,
          UKeys.brandsFolder,
        );

        if (response.statusCode == 200) {
          brand.image = response.data['url'];
        }
        //store data to fire base fire store
        await _db
            .collection(UKeys.brandsCollection)
            .doc(brand.id)
            .set(brand.toJson());
        print('Brands ${brand.name}Uploaded Succeffuly');
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

  ///[Fetsh ] dunction to get all brands
  Future<List<BrandModel>> fetshBrands() async {
    try {
      final query = await _db.collection(UKeys.brandsCollection).get();
      if (query.docs.isNotEmpty) {
        final brands = query.docs
            .map((document) => BrandModel.fromSnapshot(document))
            .toList();
        return brands;
      }
      return [];
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

  ///[Fetch] - Funcation To Get Category Specific brands

  Future<List<BrandModel>> fetshBrandsForCategory(String categoryId) async {
    try {
      //Query to get all documents where categoryId matches the provided categoryId
      final brandCategoryQuery = await _db
          .collection(UKeys.brandCategoryCollection)
          .where('categoryId', isEqualTo: categoryId)
          .get();

      //Convert documents to Meodel
      List<BrandCategoryModel> brandCategories = brandCategoryQuery.docs
          .map((doc) => BrandCategoryModel.fromSnapshot(doc))
          .toList();
      // Extract brandId from BrandCategoryModel
      List<String> brandIds = brandCategories
          .map((brandCategory) => brandCategory.brandId)
          .toList();
      //Query to get brands based on brandIds
      final brandsQuery = await _db
          .collection(UKeys.brandsCollection)
          .where(FieldPath.documentId, whereIn: brandIds)
          .limit(2)
          .get();
      //Convert documents to model
      List<BrandModel> brands = brandsQuery.docs
          .map((doc) => BrandModel.fromSnapshot(doc))
          .toList();

      return brands;
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
