class CartItemModel {
  String productId;
  String title;
  double price;
  String? image;
  int quantity;
  String variationId;
  String? brandName;
  Map<String, dynamic>? selectedVariation;

  CartItemModel({
    required this.productId,
    required this.quantity,
    this.image,
    this.price = 0.0,
    this.brandName,
    this.title = '',
    this.variationId = '',
    this.selectedVariation,
  });
  //Empty Cart
  static CartItemModel empty() => CartItemModel(productId: '', quantity: 0);

  Map<String, dynamic> toJson() {
    return {
      'productId': productId,
      'quantity': quantity,
      'brandName': brandName,
      'image': image,
      'price': price,
      'title': title,
      'variationId': variationId,
      'selectedVariation': selectedVariation,
    };
  }

  factory CartItemModel.fromJson(Map<String, dynamic> json) {
    return CartItemModel(
      productId: json['productId'],
      quantity: json['quantity'],
      brandName: json['brandName'],
      image: json['image'],
      price: json['price'],
      title: json['title'],
      variationId: json['variationId'],
      selectedVariation: json['selectedVariation'] != null
          ? Map<String, dynamic>.from(json['selectedVariation'])
          : null,
    );
  }
}
