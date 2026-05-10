import 'dart:convert';
import 'RecipeSnapshot.dart';

class ProductionOrderDetail {
  final String? productionOrderDetailId;
  final String? productName;
  final int? targetBatch;
  final int? currentBatch;
  final RecipeSnapshot? recipeSnapshot;
  final String? productId; // Dùng để gửi lên khi tạo/sửa
  final int? sequenceNo;
  final int? batchQuantity; // Dùng cho POST
  final int? numberOfPieces; // Dùng cho PATCH

  ProductionOrderDetail({
    this.productionOrderDetailId,
    this.productName,
    this.targetBatch,
    this.currentBatch,
    this.recipeSnapshot,
    this.productId,
    this.sequenceNo,
    this.batchQuantity,
    this.numberOfPieces,
  });

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (productionOrderDetailId != null)
      data['productionOrderDetailId'] = productionOrderDetailId;
    if (productName != null) data['productName'] = productName;
    if (targetBatch != null) data['targetBatch'] = targetBatch;
    if (currentBatch != null) data['currentBatch'] = currentBatch;
    if (recipeSnapshot != null)
      data['recipeSnapshot'] = recipeSnapshot!.toMap();
    if (productId != null) data['productId'] = productId;
    if (sequenceNo != null) data['sequenceNo'] = sequenceNo;
    if (batchQuantity != null) data['batchQuantity'] = batchQuantity;
    if (numberOfPieces != null) data['numberOfPieces'] = numberOfPieces;
    return data;
  }

  String toJson() => jsonEncode(toMap());

  factory ProductionOrderDetail.fromMap(Map<String, dynamic> json) =>
      ProductionOrderDetail(
        productionOrderDetailId: json['productionOrderDetailId'] as String?,
        productName: json['productName'] as String?,
        targetBatch: (json['targetBatch'] as num?)?.toInt(),
        currentBatch: (json['currentBatch'] as num?)?.toInt(),
        recipeSnapshot: json['recipeSnapshot'] != null
            ? RecipeSnapshot.fromMap(
                Map<String, dynamic>.from(json['recipeSnapshot'] as Map),
              )
            : null,
        productId: json['productId'] as String?,
        sequenceNo: (json['sequenceNo'] as num?)?.toInt(),
        batchQuantity: (json['batchQuantity'] as num?)?.toInt(),
        numberOfPieces: (json['numberOfPieces'] as num?)?.toInt(),
      );
  factory ProductionOrderDetail.fromJson(String json) =>
      ProductionOrderDetail.fromMap(jsonDecode(json));
}
