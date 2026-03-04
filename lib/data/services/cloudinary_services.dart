import 'dart:convert';
import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:dio/dio.dart' as dio;
import 'package:ecommerce_app/utlis/constants/apis.dart';
import 'package:ecommerce_app/utlis/constants/keys.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class CloudinaryServices extends GetxController {
  static CloudinaryServices get instance => Get.find();

  //Variables
  final _dio = dio.Dio();

  // [Upload Image] Funcation To Upload Image
  Future<dio.Response> uploadImage(File image, String folderName) async {
    try {
      String api = UApiUrls.uploadApi(UKeys.cloudName);

      dio.FormData formData = dio.FormData.fromMap({
        "upload_preset": UKeys.uploadPreset,
        "folder": folderName,
        "file": await dio.MultipartFile.fromFile(
          image.path,
          filename: image.path.split('/').last,
        ),
      });

      dio.Response response = await _dio.post(api, data: formData);
      return response;
    } catch (e) {
      debugPrint("Error While Upload Profile $e");
      throw "Failed To Upload Your Profile Image,Please Try Again";
    }
  }

  //[Delete Image] Function to delete image
  Future<dio.Response> deleteImage(String publicId) async {
    try {
      String api = UApiUrls.deleteApi(UKeys.cloudName);
      int timestamp = (DateTime.now().microsecondsSinceEpoch / 1000).round();
      String signatureBase =
          'public_id=$publicId&timestamp=$timestamp${UKeys.apiSecret}';
      String signature = sha1.convert(utf8.encode(signatureBase)).toString();
      final formData = dio.FormData.fromMap({
        'public_id': publicId,
        'api_key': UKeys.apiKey,
        'timestamp': timestamp,
        'signature': signature,
      });
      dio.Response response = await _dio.post(api, data: formData);
      return response;
    } catch (e) {
      throw "Somthing went wrong , Please try again";
    }
  }
}
