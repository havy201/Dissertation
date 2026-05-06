import 'package:app_for_scada/model/Production/IngredientItem.dart';
import 'package:app_for_scada/model/Production/Recipe.dart';
import 'package:app_for_scada/model/Production/Product.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../global.dart';

class ProductAPIServer {
  static final ProductAPIServer instance = ProductAPIServer._init();
  final String baseUrl = Global.baseUrl;
  final String endpointProduct = Global.productEndpoint;
  final String endpointIngredient = Global.ingredientEndpoint;
  final String endpointRecipe = Global.recipeEndpoint;

  ProductAPIServer._init();

  Future<List<Product>> getAllProducts() async {
    final response = await http.get(
      Uri.parse('$baseUrl/$endpointProduct/GetAll'),
    );

    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body); // Debug log
      return data.map((item) => Product.fromMap(item)).toList();
    } else {
      throw Exception('Failed to load products: ${response.statusCode}');
    }
  }

  Future<bool> createProduction(Product product) async {
    final response = await http.post(
      Uri.parse('$baseUrl/$endpointProduct/CreateProduct'),
      headers: {'Content-Type': 'application/json'},
      body: product.toJson(),
    );

    if (response.statusCode == 200 ||
        response.statusCode == 201 ||
        response.statusCode == 204) {
      return true;
    } else {
      throw Exception(
        'Failed to create production: ${response.statusCode} - ${response.body}',
      );
    }
  }

  Future<bool> updateProduction(Product product) async {
    final response = await http.patch(
      Uri.parse('$baseUrl/$endpointProduct'),
      headers: {'Content-Type': 'application/json'},
      body: product.toJson(),
    );

    if (response.statusCode == 200 || response.statusCode == 204) {
      return true;
    } else {
      throw Exception(
        'Failed to update production: ${response.statusCode} - ${response.body}',
      );
    }
  }

  Future<String> createRecipe(Recipe recipe) async {
    final response = await http.post(
      Uri.parse('$baseUrl/$endpointRecipe'),
      headers: {'Content-Type': 'application/json'},
      body: recipe.toJson(),
    );

    if (response.statusCode == 200 ||
        response.statusCode == 201 ||
        response.statusCode == 204) {
      return response.body;
    } else {
      throw Exception(
        'Failed to create recipe: ${response.statusCode} - ${response.body}',
      );
    }
  }

  Future<bool> updateRecipe(Recipe recipe) async {
    final body = recipe.toPatchJson();
    final response = await http.patch(
      Uri.parse('$baseUrl/$endpointRecipe'),
      headers: {'Content-Type': 'application/json'},
      body: body,
    );
    print('Recipe gui di: $body'); // Debug log
    if (response.statusCode == 200 || response.statusCode == 204) {
      print('Hoan thanh thay doi don hang');
      return true;
    } else {
      print(
        'Loi khi thay doi don hang: ${response.statusCode} - ${response.body}',
      );
      throw Exception(
        'Failed to update recipe: ${response.statusCode} - ${response.body}',
      );
    }
  }

  Future<List<IngredientItem>> getAllIngredients() async {
    final response = await http.get(
      Uri.parse('$baseUrl/$endpointIngredient/GetAll'),
    );

    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body); // Debug log
      return data.map((item) => IngredientItem.fromMap(item)).toList();
    } else {
      throw Exception('Failed to load ingredients: ${response.statusCode}');
    }
  }
}
