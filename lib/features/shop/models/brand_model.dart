import 'package:cloud_firestore/cloud_firestore.dart';

class BrandModel {
  String id;
  String image;
  String name;
  int? productsCount;
  bool? isFeatured;

  BrandModel({
    required this.id,
    required this.image,
    required this.name,
    this.productsCount,
    this.isFeatured,
  });

  static BrandModel empty() => BrandModel(id: '', image: '', name: '');

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'image': image,
      'isFeature': isFeatured,
      'name': name,
      'productCount': productsCount,
    };
  }

  factory BrandModel.fromJsom(Map<String, dynamic> document) {
    final data = document;
    if (data.isEmpty) return BrandModel.empty();
    return BrandModel(
      id: data['id'],
      image: data['image'],
      name: data['name'],
      isFeatured: data['isFeature'],
      productsCount: data['productCount'],
    );
  }
  factory BrandModel.fromSnapshot(
    DocumentSnapshot<Map<String, dynamic>> document,
  ) {
    if (document.data() != null) {
      Map<String, dynamic> data = document.data()!;
      return BrandModel(
        id: data['id'],
        image: data['image'],
        name: data['name'],
        isFeatured: data['isFeature'],
        productsCount: data['productCount'],
      );
    } else {
      return BrandModel.empty();
    }
  }
}
