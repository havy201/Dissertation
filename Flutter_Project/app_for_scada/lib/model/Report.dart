import 'dart:convert';

class Report {
  String id;
  String productName;
  String customerName;
  DateTime orderDate;
  String ingredients;
  int targetQuantity;
  int actualQuantity;
  int status;
  DateTime startTime;
  DateTime endTime;
  List<int> scaleData = [];


  Report({
    required this.id,
    required this.productName,
    required this.customerName,
    required this.orderDate,
    required this.ingredients,
    required this.status,
    required this.targetQuantity,
    required this.actualQuantity,
    required this.startTime,
    required this.endTime,
  });

  Map<String, dynamic> toData() {
    return {
      'id': id,
      'productName': productName,
      'customerName': customerName,
      'orderDate': orderDate,
      'ingredients': ingredients,
      'status': status,
      'targetQuantity': targetQuantity,
      'actualQuantity': actualQuantity,
      'startTime': startTime,
      'endTime': endTime,
      'scaleData': scaleData,
    };
  }

  Map<String, dynamic> toMap() => toData();

  String toJson() => jsonEncode(toData());

  factory Report.fromMap(Map<String, dynamic> data) {
    return Report(
      id: data['id'],
      productName: data['productName'],
      customerName: data['customerName'],
      orderDate: data['orderDate'],
      ingredients: data['ingredients'],
      status: data['status'],
      targetQuantity: data['targetQuantity'] ?? 0,
      actualQuantity: data['actualQuantity'] ?? 0,
      startTime: data['startTime'] ?? DateTime.now(),
      endTime: data['endTime'] ?? DateTime.now(),
    );
  }

  factory Report.fromJson(String json) {
    Map<String, dynamic> map = jsonDecode(json);
    return Report(
      id: map['id'],
      productName: map['productName'],
      customerName: map['customerName'],
      orderDate: map['orderDate'],
      ingredients: map['ingredients'],
      status: map['status'],
      targetQuantity: map['targetQuantity'] ?? 0,
      actualQuantity: map['actualQuantity'] ?? 0,
      startTime: map['startTime'] ?? DateTime.now(),
      endTime: map['endTime'] ?? DateTime.now(),
    );
  }

  @override
  String toString() {
    return 'Report(id: $id, productName: $productName, customerName: $customerName, orderDate: $orderDate, ingredients: $ingredients, status: $status)';
  }
}