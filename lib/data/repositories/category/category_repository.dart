// ignore_for_file: dead_code_on_catch_subtype, avoid_print

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart' as dio;
import 'package:ecommerce_app/data/services/cloudinary_services.dart';
import 'package:ecommerce_app/features/shop/models/brand_category_model.dart';
import 'package:ecommerce_app/features/shop/models/category_model.dart';
import 'package:ecommerce_app/features/shop/models/product_category_model.dart';
import 'package:ecommerce_app/utlis/constants/keys.dart';
import 'package:ecommerce_app/utlis/exceptions/firebase_auth_exceptions.dart';
import 'package:ecommerce_app/utlis/exceptions/format_exceptions.dart';
import 'package:ecommerce_app/utlis/exceptions/platform_exceptions.dart';
import 'package:ecommerce_app/utlis/helper/helper_function.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class CategoryRepository extends GetxController {
  static CategoryRepository get instance => Get.find();

  //Varibals
  final _db = FirebaseFirestore.instance;
  final _cloudinaryServices = Get.put(CloudinaryServices());

  ///[Upload] - Funcation To Upload List of Brand Categories
  Future<void> uploadBrandCategory(
    List<BrandCategoryModel> brandCategories,
  ) async {
    try {
      for (final brandCategory in brandCategories) {
        await _db
            .collection(UKeys.brandCategoryCollection)
            .doc()
            .set(brandCategory.toJson());
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

  ///[Upload] - Funcation To Upload List of Brand Categories
  Future<void> uploadProductCategory(
    List<ProductCategoryModel> productCategories,
  ) async {
    try {
      for (final productCategory in productCategories) {
        await _db
            .collection(UKeys.productCategoryCollection)
            .doc()
            .set(productCategory.toJson());
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

  /// [UploadCategory] - Function to upload list of brand categories
  Future<void> uploadCategories(List<CategoryModel> categories) async {
    try {
      for (final category in categories) {
        File image = await UHelperFunctions.assetToFile(category.image);
        dio.Response response = await _cloudinaryServices.uploadImage(
          image,
          UKeys.categoryFolder,
        );
        if (response.statusCode == 200) {
          category.image = response.data['url'];
        }
        await _db
            .collection(UKeys.categoryCollection)
            .doc(category.id)
            .set(category.toJson());
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

  /// [FetchCategories] - Function to fetch list of categories

  Future<List<CategoryModel>> getAllCategories() async {
    try {
      final query = await _db.collection(UKeys.categoryCollection).get();
      if (query.docs.isNotEmpty) {
        List<CategoryModel> categories = query.docs
            .map((document) => CategoryModel.fromSnapShot(document))
            .toList();
        return categories;
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

  /// [FetchSubCategories] - Function to fetch list of sub categories

  Future<List<CategoryModel>> getSubCategories(String categoryId) async {
    try {
      final query = await _db
          .collection(UKeys.categoryCollection)
          .where('parentId', isEqualTo: categoryId)
          .get();
      if (query.docs.isNotEmpty) {
        List<CategoryModel> categories = query.docs
            .map((document) => CategoryModel.fromSnapShot(document))
            .toList();
        return categories;
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
}
