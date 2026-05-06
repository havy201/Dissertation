import 'MaterialItem.dart';
import 'dart:convert';

class Recipe {
  final String? recipeId;
  final String? recipeName;
  final int? grindingTimeSeconds;
  final int? mixingTimeSeconds;
  final List<MaterialItem>? materials;
  final List<MaterialItem>? recipeMaterials;

  Recipe({
    this.recipeId,
    this.recipeName,
    this.grindingTimeSeconds,
    this.mixingTimeSeconds,
    this.materials,
    this.recipeMaterials,
  });
  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (recipeId != null) data['recipeId'] = recipeId;
    if (recipeName != null) data['recipeName'] = recipeName;
    if (grindingTimeSeconds != null)
      data['grindingTimeSeconds'] = grindingTimeSeconds;

    if (mixingTimeSeconds != null)
      data['mixingTimeSeconds'] = mixingTimeSeconds;

    if (materials != null)
      data['materials'] = materials!.map((m) => m.toMap()).toList();

    if (recipeMaterials != null)
      data['recipeMaterials'] = recipeMaterials!.map((m) => m.toMap()).toList();
    return data;
  }

  String toJson() => jsonEncode(toMap());

  Map<String, dynamic> toPatchMap() {
    return {
      'recipeId': recipeId,
      'recipeName': recipeName,
      'grindingTimeSeconds': grindingTimeSeconds,
      'mixingTimeSeconds': mixingTimeSeconds,
      'recipeMaterials': recipeMaterials?.map((m) => m.toPatchMap()).toList(),
    };
  }

  String toPatchJson() => jsonEncode(toPatchMap());

  factory Recipe.fromMap(Map<String, dynamic> json) {
    final materialsJson =
        (json['recipeMaterials'] ?? json['materials']) as List? ?? [];

    return Recipe(
      recipeId: json['recipeId'] as String?,
      recipeName: json['recipeName'] as String?,
      grindingTimeSeconds: (json['grindingTimeSeconds'] as num?)?.toInt(),
      mixingTimeSeconds: (json['mixingTimeSeconds'] as num?)?.toInt(),
      materials: materialsJson
          .map((m) => MaterialItem.fromMap(Map<String, dynamic>.from(m)))
          .toList(),
      recipeMaterials: materialsJson
          .map((m) => MaterialItem.fromMap(Map<String, dynamic>.from(m)))
          .toList(),
    );
  }
}
