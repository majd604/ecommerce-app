// ignore_for_file: avoid_print

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart' as dio;
import 'package:ecommerce_app/data/services/cloudinary_services.dart';
import 'package:ecommerce_app/features/shop/models/product_model.dart';
import 'package:ecommerce_app/utlis/constants/keys.dart';
import 'package:ecommerce_app/utlis/exceptions/firebase_auth_exceptions.dart';
import 'package:ecommerce_app/utlis/exceptions/format_exceptions.dart';
import 'package:ecommerce_app/utlis/exceptions/platform_exceptions.dart';
import 'package:ecommerce_app/utlis/helper/helper_function.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class ProductRepository extends GetxController {
  static ProductRepository get instance => Get.find();

  //Variables
  final _db = FirebaseFirestore.instance;
  final _cloudinaryServices = Get.put(CloudinaryServices());

  ///[Upload Products] -Funcation to upload list of products to firebase
  Future<void> uploadProduct(List<ProductModel> products) async {
    try {
      for (ProductModel product in products) {
        //upload thumnail to cloudinary.
        final Map<String, String> uploadImageMap = {};
        File thumbnailFile = await UHelperFunctions.assetToFile(
          product.thumbnail,
        );
        dio.Response response = await _cloudinaryServices.uploadImage(
          thumbnailFile,
          UKeys.productsFolder,
        );
        if (response.statusCode == 200) {
          String url = response.data['url'];
          uploadImageMap[product.thumbnail] = url;
          product.thumbnail = url;
        }
        if (product.images != null && product.images!.isNotEmpty) {
          List<String> imageUrls = [];
          for (String image in product.images!) {
            File imageFile = await UHelperFunctions.assetToFile(image);
            dio.Response response = await _cloudinaryServices.uploadImage(
              imageFile,
              UKeys.productsFolder,
            );
            if (response.statusCode == 200) {
              imageUrls.add(response.data['url']);
            }
          }
          //Upload product variations image
          if (product.productVariations != null &&
              product.productVariations!.isNotEmpty) {
            for (int i = 0; i < product.images!.length; i++) {
              uploadImageMap[product.images![i]] = imageUrls[i];

              for (final variation in product.productVariations!) {
                final match = uploadImageMap.entries.firstWhere(
                  (entry) => entry.key == variation.image,
                  orElse: () => const MapEntry('', ''),
                );
                if (match.key.isNotEmpty) {
                  variation.image = match.value;
                }
              }
            }
            product.images!.clear();
            product.images!.assignAll(imageUrls);
          }
          //upload products to firestore
        }
        await _db
            .collection(UKeys.productsCollection)
            .doc(product.id)
            .set(product.toJson());
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

  Future<List<ProductModel>> fetchAllProducts() async {
    try {
      final query = await _db.collection(UKeys.productsCollection).get();
      if (query.docs.isNotEmpty) {
        List<ProductModel> products = query.docs
            .map((document) => ProductModel.fromSnapshot(document))
            .toList();
        return products;
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

  Future<ProductModel> fetchSingleProduct(String productId) async {
    try {
      final query = await _db
          .collection(UKeys.productsCollection)
          .doc(productId)
          .get();
      if (query.id.isNotEmpty) {
        ProductModel product = ProductModel.fromSnapshot(query);
        return product;
      }
      return ProductModel.empty();
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

  ///[Fetch] - Funcation to fetch list of products from firebase

  Future<List<ProductModel>> fetchFeaturedProduct() async {
    try {
      final query = await _db
          .collection(UKeys.productsCollection)
          .where('isFeatured', isEqualTo: true)
          .limit(4)
          .get();
      if (query.docs.isNotEmpty) {
        List<ProductModel> products = query.docs
            .map((document) => ProductModel.fromSnapshot(document))
            .toList();
        return products;
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

  ///[Fetch] - Funcation to fetch all list of products from firebase

  Future<List<ProductModel>> fetchAllFeaturedProduct() async {
    try {
      final query = await _db
          .collection(UKeys.productsCollection)
          .where('isFeatured', isEqualTo: true)
          .get();
      if (query.docs.isNotEmpty) {
        List<ProductModel> products = query.docs
            .map((document) => ProductModel.fromSnapshot(document))
            .toList();
        return products;
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

  //[Fetch] - Funcation to fetch all list of products from firebase

  Future<List<ProductModel>> fetchProductsByQuery(Query query) async {
    try {
      final querySnapShot = await query.get();
      if (querySnapShot.docs.isNotEmpty) {
        List<ProductModel> products = querySnapShot.docs
            .map((document) => ProductModel.fromQuerySnapshot(document))
            .toList();
        return products;
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

  ///[Fetch] -Funcation to fetch all list of brand specific products
  Future<List<ProductModel>> getProductsForBrand({
    required String brandId,
    int limit = -1,
  }) async {
    try {
      final query = limit == -1
          ? await _db
                .collection(UKeys.productsCollection)
                .where('brand.id', isEqualTo: brandId)
                .get()
          : await _db
                .collection(UKeys.productsCollection)
                .where('brand.id', isEqualTo: brandId)
                .limit(limit)
                .get();
      if (query.docs.isNotEmpty) {
        List<ProductModel> products = query.docs
            .map((document) => ProductModel.fromSnapshot(document))
            .toList();
        return products;
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

  ///[Fetch] -Funcation to fetch all list of category specific products
  Future<List<ProductModel>> getProductsForCaregory({
    required String categoryId,
    int limit = 4,
  }) async {
    try {
      final productCategoryQuery = limit == -1
          ? await _db
                .collection(UKeys.productCategoryCollection)
                .where('categoryId', isEqualTo: categoryId)
                .get()
          : await _db
                .collection(UKeys.productCategoryCollection)
                .where('categoryId', isEqualTo: categoryId)
                .limit(limit)
                .get();
      List<String> productIds = productCategoryQuery.docs
          .map((doc) => doc['productId'] as String)
          .toList();
      final productQuery = await _db
          .collection(UKeys.productsCollection)
          .where(FieldPath.documentId, whereIn: productIds)
          .get();
      List<ProductModel> products = productQuery.docs
          .map((doc) => ProductModel.fromSnapshot(doc))
          .toList();
      return products;
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

  ///[Fetch] - Funcation to fetch list of products from firebase
  Future<List<ProductModel>> getFavouritesProduct(
    List<String> productIds,
  ) async {
    try {
      // ✅ نظّف الليست: شيل الفاضي والـ null-like والمسافات
      final ids = productIds
          .map((e) => e.trim())
          .where((e) => e.isNotEmpty)
          .toList();

      if (ids.isEmpty) return [];

      final query = await _db
          .collection(UKeys.productsCollection)
          .where(FieldPath.documentId, whereIn: ids)
          .get();

      return query.docs
          .map((document) => ProductModel.fromSnapshot(document))
          .toList();
    } on FirebaseAuthException catch (e) {
      throw UFirebaseAuthException(e.code).message;
    } on FormatException catch (_) {
      throw UFormatException();
    } on PlatformException catch (e) {
      throw UPlatformException(e.code).message;
    } catch (e) {
      throw 'Something went wrong, Please try again';
    }
  }

  // Future<List<ProductModel>> getFavouritesProduct(
  //   List<String> productIds,
  // ) async {
  //   try {
  //     if (productIds.isEmpty) return [];
  //     final query = await _db
  //         .collection(UKeys.productsCollection)
  //         .where(FieldPath.documentId, whereIn: productIds)
  //         .get();

  //     if (query.docs.isNotEmpty) {
  //       List<ProductModel> products = query.docs
  //           .map((document) => ProductModel.fromSnapshot(document))
  //           .toList();
  //       return products;
  //     }
  //     return [];
  //   } on FirebaseAuthException catch (e) {
  //     throw UFirebaseAuthException(e.code).message;
  //   } on FormatException catch (_) {
  //     throw UFormatException();
  //   } on PlatformException catch (e) {
  //     throw UPlatformException(e.code).message;
  //   } catch (e) {
  //     throw 'Something went wrong ,Please try again ';
  //   }
  // }
}
