import '../model/Order/ProductionOrder.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../global.dart';

class OrderAPIServer {
  static final OrderAPIServer instance = OrderAPIServer._init();
  final String baseUrl = Global.baseUrl;
  final String endpointProductionOrder = Global.productionOrderEndpoint;
  OrderAPIServer._init();
  //dat hang san xuat moi
  Future<bool> createProductionOrder(ProductionOrder order) async {
    final response = await http.post(
      Uri.parse('$baseUrl/$endpointProductionOrder'),
      headers: {'Content-Type': 'application/json'},
      body: order.toJson(),
    );
    if (response.statusCode == 200 ||
        response.statusCode == 201 ||
        response.statusCode == 204) {
      return true;
    } else {
      throw Exception(
        'Failed to create production order: ${response.statusCode} - ${response.body}',
      );
    }
  }

  //chinh sua don hang -> khach huy don o day
  Future<bool> updateProductionOrder(ProductionOrder order) async {
    final response = await http.patch(
      Uri.parse('$baseUrl/$endpointProductionOrder/'),
      headers: {'Content-Type': 'application/json'},
      body: order.toJson(),
    );
    if (response.statusCode == 200 || response.statusCode == 204) {
      print('Cập nhật thành công');
      return true;
    } else {
      print('Thất bại do: ${response.statusCode} - ${response.body}');
      throw Exception(
        'Failed to update production order: ${response.statusCode} - ${response.body}',
      );
    }
  }

  //nhan don hang
  Future<bool> confirmOrder(ProductionOrder order) async {
    final response = await http.patch(
      Uri.parse('$baseUrl/$endpointProductionOrder/ConfirmReady'),
      headers: {'Content-Type': 'application/json'},
      body: order.toJson(),
    );
    if (response.statusCode == 200 || response.statusCode == 204) {
      print('Cập nhật thành công');
      return true;
    } else {
      print('Thất bại do: ${response.statusCode} - ${response.body}');
      throw Exception('Failed to confirm order: ${response.statusCode}');
    }
  }

  //theo doi don hang dua tren username nguoi dung
  Future<List<ProductionOrder>> getProductionOrderByUsername(
    String username,
  ) async {
    final response = await http.get(
      Uri.parse(
        '$baseUrl/$endpointProductionOrder/GetOrderReportByUserName?UserName=$username',
      ),
    );

    if (response.statusCode == 200) {
      return (json.decode(response.body) as List)
          .map((e) => ProductionOrder.fromMap(e))
          .toList();
    } else {
      throw Exception(
        'Failed to fetch production order: ${response.statusCode} - ${response.body}',
      );
    }
  }

  //theo doi don hang dua tren thoi gian dat hang, cu phap thoi gian : 2026-04-01
  Future<List<ProductionOrder>> getProductionOrderByTime(
    String startTime,
    String endTime,
  ) async {
    final response = await http.get(
      Uri.parse(
        '$baseUrl/$endpointProductionOrder/GetAllProductionOrderByTime?StartTime=$startTime&&EndTime=$endTime',
      ),
    );

    if (response.statusCode == 200) {
      return (json.decode(response.body) as List)
          .map((e) => ProductionOrder.fromMap(e))
          .toList();
    } else {
      throw Exception(
        'Failed to fetch production order: ${response.statusCode} - ${response.body}',
      );
    }
  }

  //xoa don hang
  Future<bool> deleteProductionOrder(String productionOrderId) async {
    final response = await http.delete(
      Uri.parse(
        '$baseUrl/$endpointProductionOrder?ProductionOrderId=$productionOrderId',
      ),
    );
    if (response.statusCode == 200 || response.statusCode == 204) {
      return true;
    } else {
      throw Exception(
        'Failed to delete production order: ${response.statusCode}',
      );
    }
  }
}
