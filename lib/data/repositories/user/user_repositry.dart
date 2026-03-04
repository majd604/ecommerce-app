// ignore_for_file: dead_code_on_catch_subtype
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_app/data/repositories/authentication_repositry.dart';
import 'package:ecommerce_app/data/services/cloudinary_services.dart';
import 'package:ecommerce_app/features/authentication/models/user_model.dart';
import 'package:ecommerce_app/utlis/constants/keys.dart';
import 'package:ecommerce_app/utlis/exceptions/firebase_auth_exceptions.dart';
import 'package:ecommerce_app/utlis/exceptions/platform_exceptions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart' as dio;

class UserRepositry extends GetxController {
  static UserRepositry get instance => Get.find();

  //Variables
  final _db = FirebaseFirestore.instance;
  final _cloudinaryServices = Get.put(CloudinaryServices());
  //Function To Store User Data

  Future<void> saveUserRecord(UserModel user) async {
    try {
      await _db
          .collection(UKeys.userCollection)
          .doc(user.id)
          .set(user.toJson());
    } on FirebaseAuthException catch (e) {
      throw UFirebaseAuthException(e.code).message;
    } on FirebaseAuthException catch (e) {
      throw UFirebaseAuthException(e.code).message;
    } on PlatformException catch (e) {
      throw UPlatformException(e.code).message;
    } catch (e) {
      throw 'Something went wrong ,Please try again ';
    }
  }

  //[Read] Function to fetsh user details based on current user
  Future<UserModel> fetshUserDetail() async {
    try {
      final documentSnapShot = await _db
          .collection(UKeys.userCollection)
          .doc(AuthenticationRepositry.instance.currentUser!.uid)
          .get();
      if (documentSnapShot.exists) {
        UserModel user = UserModel.fromSnapshot(documentSnapShot);
        return user;
      }
      return UserModel.empty();
    } on FirebaseAuthException catch (e) {
      throw UFirebaseAuthException(e.code).message;
    } on FirebaseAuthException catch (e) {
      throw UFirebaseAuthException(e.code).message;
    } on PlatformException catch (e) {
      throw UPlatformException(e.code).message;
    } catch (e) {
      throw 'Something went wrong ,Please try again ';
    }
  }

  //[Update] Funcation to update user single field
  Future<void> updateSingleField(Map<String, dynamic> map) async {
    try {
      await _db
          .collection(UKeys.userCollection)
          .doc(AuthenticationRepositry.instance.currentUser!.uid)
          .update(map);
    } on FirebaseAuthException catch (e) {
      throw UFirebaseAuthException(e.code).message;
    } on FirebaseAuthException catch (e) {
      throw UFirebaseAuthException(e.code).message;
    } on PlatformException catch (e) {
      throw UPlatformException(e.code).message;
    } catch (e) {
      throw 'Something went wrong ,Please try again ';
    }
  }

  //[Delete] Funcation to delete user record
  Future<void> removeUserRecord(String userId) async {
    try {
      await _db.collection(UKeys.userCollection).doc(userId).delete();
    } on FirebaseAuthException catch (e) {
      throw UFirebaseAuthException(e.code).message;
    } on FirebaseAuthException catch (e) {
      throw UFirebaseAuthException(e.code).message;
    } on PlatformException catch (e) {
      throw UPlatformException(e.code).message;
    } catch (e) {
      throw 'Something went wrong ,Please try again ';
    }
  }
  //[Upload Image]Funcation To Upload User Profile Image

  Future<dio.Response> uoploadImage(File image) async {
    try {
      dio.Response response = await _cloudinaryServices.uploadImage(
        image,
        UKeys.profileFolder,
      );

      return response;
    } catch (e) {
      throw "Failed To Upload Your Profile Image,Please Try Again";
    }
  }

  //[Delete Image] Function to delete profile picture
  Future<dio.Response> deleteProfilePicture(String publicId) async {
    try {
      dio.Response response = await _cloudinaryServices.deleteImage(publicId);
      return response;
    } catch (e) {
      throw "Somthing went wrong , Please try again";
    }
  }
}
