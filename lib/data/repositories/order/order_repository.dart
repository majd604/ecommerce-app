import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_app/data/repositories/authentication_repositry.dart';
import 'package:ecommerce_app/features/shop/models/order_model.dart';
import 'package:ecommerce_app/utlis/constants/keys.dart';
import 'package:get/get.dart';

class OrderRepository extends GetxController {
  static OrderRepository get instance => Get.find();

  //Variables
  final _db = FirebaseFirestore.instance;

  ///[Save] save user order
  Future<void> saveOrder(OrderModel order) async {
    try {
      await _db
          .collection(UKeys.userCollection)
          .doc(order.userId)
          .collection(UKeys.orderCollection)
          .add(order.toJson());
    } catch (e) {
      throw 'Something went wrong while saving the order: $e';
    }
  }

  ///[Fetch] fetch user orders
  Future<List<OrderModel>> fetchUserOrders() async {
    try {
      final userId = AuthenticationRepositry.instance.currentUser!.uid;
      if (userId.isEmpty) throw 'Unable to find user information.';
      final query = await _db
          .collection(UKeys.userCollection)
          .doc(userId)
          .collection(UKeys.orderCollection)
          .get();
      if (query.docs.isNotEmpty) {
        List<OrderModel> orders = query.docs
            .map((doc) => OrderModel.fromSnapshot(doc))
            .toList();
        return orders;
      }
      return [];
    } catch (e) {
      throw 'something went wrong while fetching orders';
    }
  }
}
