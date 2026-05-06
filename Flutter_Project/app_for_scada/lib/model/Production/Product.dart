import 'dart:convert';
import 'Recipe.dart';

class Product {
  final String? productId;
  final String? productName;
  final Recipe? recipe;
  final String? recipeId;
  final int? weightPerPieceKg;

  Product({
    this.productId,
    this.productName,
    this.recipe,
    this.recipeId,
    this.weightPerPieceKg,
  });
  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (productId != null) data['productId'] = productId;
    if (productName != null) data['productName'] = productName;
    if (recipe != null) data['recipe'] = recipe!.toMap();
    if (recipeId != null) data['recipeId'] = recipeId;
    if (weightPerPieceKg != null) data['weightPerPieceKg'] = weightPerPieceKg;
    return data;
  }

  String toJson() => jsonEncode(toMap());

  factory Product.fromMap(Map<String, dynamic> json) => Product(
    productId: json['productId'] as String?,
    productName: json['productName'] as String?,
    recipe: json['recipe'] != null
        ? Recipe.fromMap(Map<String, dynamic>.from(json['recipe'] as Map))
        : null,
    recipeId: json['recipeId'] as String?,
    weightPerPieceKg: (json['weightPerPieceKg'] as num?)?.toInt(),
  );
}
