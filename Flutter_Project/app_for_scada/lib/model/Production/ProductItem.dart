import 'dart:convert';

class ProductItem {
  final String? productId;
  final String? productName;

  ProductItem({this.productId, this.productName});

  factory ProductItem.fromMap(Map<String, dynamic> data) {
    return ProductItem(
      productId:
          data['productId']?.toString() ?? data['materialId']?.toString(),
      productName:
          data['productName']?.toString() ?? data['materialName']?.toString(),
    );
  }

  factory ProductItem.fromJson(String json) =>
      ProductItem.fromMap(jsonDecode(json));
}
