import 'dart:convert';

class IngredientItem {
  final String? materialId;
  final String? materialName;

  IngredientItem({this.materialId, this.materialName});

  factory IngredientItem.fromMap(Map<String, dynamic> data) {
    return IngredientItem(
      materialId: data['materialId'] as String?,
      materialName: data['materialName'] as String?,
    );
  }

  factory IngredientItem.fromJson(String json) =>
      IngredientItem.fromMap(jsonDecode(json));
}
