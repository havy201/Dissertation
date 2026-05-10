import 'dart:convert';
import 'ProductionOrderDetail.dart';

class ProductionOrder {
  final String? productionOrderId;
  final String? customerName;
  final String? fullName;
  final String? phone;
  final String? orderDay;
  final int? status;
  final String? plannedStartTime;
  final String? plannedEndTime;
  final String? actualStartTime;
  final String? actualEndTime;
  final List<ProductionOrderDetail>? details;
  final int? priority;
  final String? userName;

  ProductionOrder({
    this.productionOrderId,
    this.customerName,
    this.fullName,
    this.phone,
    this.orderDay,
    this.status,
    this.plannedStartTime,
    this.plannedEndTime,
    this.actualStartTime,
    this.actualEndTime,
    this.details,
    this.priority,
    this.userName,
  });

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (productionOrderId != null)
      data['productionOrderId'] = productionOrderId;
    if (customerName != null) data['customerName'] = customerName;
    if (fullName != null) data['fullName'] = fullName;
    if (phone != null) data['phone'] = phone;
    if (orderDay != null) data['orderDay'] = orderDay;
    if (status != null) data['status'] = status;
    if (plannedStartTime != null) data['plannedStartTime'] = plannedStartTime;
    if (plannedEndTime != null) data['plannedEndTime'] = plannedEndTime;
    if (actualStartTime != null) data['actualStartTime'] = actualStartTime;
    if (actualEndTime != null) data['actualEndTime'] = actualEndTime;
    if (details != null)
      data['details'] = details!.map((detail) => detail.toMap()).toList();
    if (priority != null) data['priority'] = priority;
    if (userName != null) data['userName'] = userName;
    return data;
  }

  String toJson() => jsonEncode(toMap());

  factory ProductionOrder.fromMap(Map<String, dynamic> json) => ProductionOrder(
    productionOrderId: json['productionOrderId'] as String?,
    customerName: json['customerName'] as String?,
    fullName: json['fullName'] as String?,
    phone: json['phone'] as String?,
    orderDay: json['orderDay'] as String?,
    status: (json['status'] as num?)?.toInt(),
    plannedStartTime: json['plannedStartTime'] as String?,
    plannedEndTime: json['plannedEndTime'] as String?,
    actualStartTime: json['actualStartTime'] as String?,
    actualEndTime: json['actualEndTime'] as String?,
    details: (json['details'] as List?)
        ?.map(
          (item) =>
              ProductionOrderDetail.fromMap(Map<String, dynamic>.from(item)),
        )
        .toList(),
    priority: (json['priority'] as num?)?.toInt(),
    userName: json['userName'] as String?,
  );

  factory ProductionOrder.fromJson(String json) =>
      ProductionOrder.fromMap(jsonDecode(json) as Map<String, dynamic>);
}
