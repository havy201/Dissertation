import 'dart:convert';
import 'package:flutter/material.dart';

import '../Production/MaterialItem.dart';
class RecipeSnapshot {
  final String? recipeId;
  final String? recipeName;
  final int? grindingTimeSeconds;
  final int? mixingTimeSeconds;
  final String? productId;
  final String? productName;
  final String? snapshotCreatedAt;
  final List<MaterialItem>? materials;

  RecipeSnapshot({
    this.recipeId,
    this.recipeName,
    this.grindingTimeSeconds,
    this.mixingTimeSeconds,
    this.productId,
    this.productName,
    this.snapshotCreatedAt,
    this.materials,
  });

  Map<String, dynamic> toMap() {
    Map<String, dynamic> data = <String, dynamic>{
      if (recipeId != null) 'recipeId': recipeId,
      if (recipeName != null) 'recipeName': recipeName,
      if (grindingTimeSeconds != null) 'grindingTimeSeconds': grindingTimeSeconds,
      if (mixingTimeSeconds != null) 'mixingTimeSeconds': mixingTimeSeconds,
      if (productId != null) 'productId': productId,
      if (productName != null) 'productName': productName,
      if (snapshotCreatedAt != null) 'snapshotCreatedAt': snapshotCreatedAt,
      if (materials != null)
        'materials': materials!.map((item) => item.toMap()).toList(),
    };
    return data;
  }

  String toJson() => jsonEncode(toMap());

  factory RecipeSnapshot.fromMap(Map<String, dynamic> json) {
    return RecipeSnapshot(
      recipeId: json['recipeId'] as String?,
      recipeName: json['recipeName'] as String?,
      grindingTimeSeconds: (json['grindingTimeSeconds'] as num?)?.toInt(),
      mixingTimeSeconds: (json['mixingTimeSeconds'] as num?)?.toInt(),
      productId: json['productId'] as String?,
      productName: json['productName'] as String?,
      snapshotCreatedAt: json['snapshotCreatedAt'] as String?,
      materials: (json['materials'] as List?)
          ?.map((item) => MaterialItem.fromMap(item))
          .toList(),
    );
  }


}