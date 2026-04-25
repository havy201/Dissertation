import 'dart:convert';

class ReportOrder {
  final String productionOrderId;
  final String customerName;
  final String phone;
  final DateTime orderDay;
  final int status;
  final DateTime plannedStartTime;
  final DateTime plannedEndTime;
  final DateTime? actualStartTime;
  final DateTime? actualEndTime;
  final List<ProductionOrderDetail> details;

  ReportOrder({
    required this.productionOrderId,
    required this.customerName,
    required this.phone,
    required this.orderDay,
    required this.status,
    required this.plannedStartTime,
    required this.plannedEndTime,
    this.actualStartTime,
    this.actualEndTime,
    required this.details,
  });
}

class ProductionOrderDetail {
  final String id;
  final String name;
  final int sequenceNo;
  final int targetBatch;
  final int currentBatch;
  final RecipeSnapshot recipeSnapshot;

  ProductionOrderDetail({
    required this.id,
    required this.name,
    required this.sequenceNo,
    required this.targetBatch,
    required this.currentBatch,
    required this.recipeSnapshot,
  });
}

class RecipeSnapshot {}
