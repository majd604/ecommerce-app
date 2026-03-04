// ignore_for_file: avoid_print

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_app/data/services/cloudinary_services.dart';
import 'package:ecommerce_app/features/shop/models/banners_model.dart';
import 'package:ecommerce_app/utlis/constants/keys.dart';
import 'package:ecommerce_app/utlis/exceptions/firebase_auth_exceptions.dart';
import 'package:ecommerce_app/utlis/exceptions/format_exceptions.dart';
import 'package:ecommerce_app/utlis/exceptions/platform_exceptions.dart';
import 'package:ecommerce_app/utlis/helper/helper_function.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart' as dio;

class BannerRepository extends GetxController {
  static BannerRepository get instance => Get.find();

  //Variables
  final _db = FirebaseFirestore.instance;
  final _cloudinaryServices = Get.put(CloudinaryServices());

  //[Upload Banners] Funcation to upload List of Banners
  Future<void> uploadBanner(List<BannerModel> banners) async {
    try {
      for (final banner in banners) {
        //convert assetPath to File
        File image = await UHelperFunctions.assetToFile(banner.imageUrl);
        //upload banner image to cloudinary
        dio.Response response = await _cloudinaryServices.uploadImage(
          image,
          UKeys.bannersFolder,
        );
        if (response.statusCode == 200) {
          banner.imageUrl = response.data['url'];
        }

        await _db.collection(UKeys.bannerCollection).doc().set(banner.toJson());
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

  //[Fetch Banners]funcation to fetch all active banners only
  Future<List<BannerModel>> fetchActiveBanner() async {
    try {
      final query = await _db
          .collection(UKeys.bannerCollection)
          .where('active', isEqualTo: true)
          .get();
      if (query.docs.isNotEmpty) {
        List<BannerModel> banners = query.docs
            .map((document) => BannerModel.fromDocument(document))
            .toList();
        return banners;
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
