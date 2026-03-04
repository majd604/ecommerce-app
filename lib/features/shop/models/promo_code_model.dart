import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_app/utlis/constants/enums.dart';

class PromoCodeModel {
  final String id;
  final String name;
  final double discount;
  final String code;
  final DiscountType? discountType;
  final DateTime? startDate;
  final DateTime? endDate;
  final bool isActive;
  final double minOrderPrice;
  final int noOfPromoCodes;
  final List<String>? userIds;

  PromoCodeModel({
    required this.id,
    required this.name,
    required this.discount,
    required this.code,
    this.discountType,
    this.startDate,
    this.endDate,
    required this.isActive,
    required this.minOrderPrice,
    required this.noOfPromoCodes,
    this.userIds,
  });
  static PromoCodeModel empty() => PromoCodeModel(
    id: '',
    name: '',
    discount: 0,
    code: '',
    isActive: false,
    minOrderPrice: 0,
    noOfPromoCodes: 0,
  );
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'discount': discount,
      'code': code,
      'discountType': discountType.toString(),
      'startData': startDate,
      'endData': endDate,
      'isActive': isActive,
      'minOrderPrice': minOrderPrice,
      'noOfPromoCodes': noOfPromoCodes,
      'userIds': userIds,
    };
  }

  factory PromoCodeModel.fromSnapShot(DocumentSnapshot snapshot) {
    final data = snapshot.data() as Map<String, dynamic>;
    return PromoCodeModel(
      id: snapshot.id,
      name: data['name'] ?? '',
      discount: double.tryParse(data['discount'].toString()) ?? 0.0,
      discountType: DiscountType.values.firstWhere(
        (element) => data['discountType'] == element.toString(),
      ),
      startDate: (data['startData'] as Timestamp).toDate(),
      endDate: (data['endData'] as Timestamp).toDate(),
      code: data['code'] ?? '',
      isActive: data['isActive'] ?? false,
      minOrderPrice: (data['minOrderPrice'] as num).toDouble(),
      noOfPromoCodes: data['noOfPromoCodes'] ?? 0,
      userIds: List.from(data['userIds'] ?? []),
    );
  }
}
