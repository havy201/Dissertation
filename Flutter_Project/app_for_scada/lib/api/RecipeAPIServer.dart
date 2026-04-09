import 'package:app_for_scada/model/Recipe.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../global.dart';

class RecipeAPIServer {
  static final RecipeAPIServer instance = RecipeAPIServer._init();
  final String baseUrl = Global.baseUrl;
  final String endpoint = Global.recipeEndpoint;

  RecipeAPIServer._init();

  Future<List<Recipe>> getAllRecipes() async {
    final response = await http.get(Uri.parse('$baseUrl/$endpoint'));
    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      return data.map((item) => Recipe.fromMap(item)).toList();
    } else {
      throw Exception('Failed to load recipes');
    }
  }
}
