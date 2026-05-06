import 'dart:convert';

class MaterialItem {
  final String? materialId;
  final String? materialName;
  final double? targetKg;
  final double? toleranceMinKg;
  final double? toleranceMaxKg;

  MaterialItem({
    this.materialId,
    this.materialName,
    this.targetKg,
    this.toleranceMinKg,
    this.toleranceMaxKg,
  });
  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (materialId != null) data['materialId'] = materialId;
    if (materialName != null) data['materialName'] = materialName;
    if (targetKg != null) data['targetKg'] = targetKg;
    if (toleranceMinKg != null) data['toleranceMinKg'] = toleranceMinKg;
    if (toleranceMaxKg != null) data['toleranceMaxKg'] = toleranceMaxKg;
    return data;
  }

  Map<String, dynamic> toPatchMap() {
    return {
      'materialId': materialId,
      'targetKg': targetKg,
      'toleranceMinKg': toleranceMinKg,
      'toleranceMaxKg': toleranceMaxKg,
    };
  }

  String toJson() => jsonEncode(toMap());

  factory MaterialItem.fromMap(Map<String, dynamic> data) {
    return MaterialItem(
      materialId: data['materialId'] as String?,
      materialName: data['materialName'] as String?,
      targetKg: (data['targetKg'] as num?)?.toDouble(),
      toleranceMinKg: (data['toleranceMinKg'] as num?)?.toDouble(),
      toleranceMaxKg: (data['toleranceMaxKg'] as num?)?.toDouble(),
    );
  }

  factory MaterialItem.fromJson(String json) =>
      MaterialItem.fromMap(jsonDecode(json));
}
