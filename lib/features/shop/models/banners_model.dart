import 'package:cloud_firestore/cloud_firestore.dart';

class BannerModel {
  String imageUrl;
  final String targetScreen;
  bool active;

  BannerModel({
    required this.imageUrl,
    required this.targetScreen,
    required this.active,
  });

  static BannerModel empty() =>
      BannerModel(imageUrl: '', targetScreen: '', active: false);

  Map<String, dynamic> toJson() {
    return {
      'imageUrl': imageUrl,
      'taregetScreen': targetScreen,
      'active': active,
    };
  }

  factory BannerModel.fromDocument(
    DocumentSnapshot<Map<String, dynamic>> snapshots,
  ) {
    if (snapshots.data() != null) {
      Map<String, dynamic> data = snapshots.data()!;

      return BannerModel(
        imageUrl: data['imageUrl'] ?? '',
        targetScreen: data['taregetScreen'] ?? '',
        active: data['active'] ?? '',
      );
    } else {
      return BannerModel.empty();
    }
  }
}
