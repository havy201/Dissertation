import 'package:app_for_scada/global.dart';
import 'package:flutter/material.dart';
import 'package:app_for_scada/widgets/botNavigation.dart';
import 'package:app_for_scada/widgets/topAppBar.dart';
import '../model/Recipe.dart';
import '../api/RecipeAPIServer.dart';

final double itemSpacing = Global.spacing;
final double padding = Global.padding;
final double fontSize = 20;

class RecipeScreen extends StatefulWidget {
  const RecipeScreen({super.key});

  @override
  State<RecipeScreen> createState() => _RecipeScreenState();
}

class _RecipeScreenState extends State<RecipeScreen> {
  static Future<List<Recipe>>? _cachedRecipesFuture;
  late Future<List<Recipe>> _recipesFuture;

  @override
  void initState() {
    super.initState();
    _recipesFuture = _cachedRecipesFuture ??= RecipeAPIServer.instance
        .getAllRecipes();
  }

  Future<void> _refreshRecipes() async {
    final future = RecipeAPIServer.instance.getAllRecipes();
    setState(() {
      _recipesFuture = future;
      _cachedRecipesFuture = future;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const TopAppBar(title: 'Công thức'),
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.all(itemSpacing),
        child: RefreshIndicator(
          color: Color(0xFF032B91),
          strokeWidth: 3,
          onRefresh: _refreshRecipes,
          child: FutureBuilder<List<Recipe>>(
            future: _recipesFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Global.loadingIndicator();
              } else if (snapshot.hasError ||
                  !snapshot.hasData ||
                  snapshot.data!.isEmpty) {
                String message = snapshot.hasError
                    ? 'Lỗi khi tải công thức'
                    : 'Không có công thức nào';
                return Global.errorIndicator(message, context);
              } else {
                return ListView(
                  reverse: false,
                  clipBehavior: Clip.none,
                  children: List.generate(
                    snapshot.data!.length,
                    (index) => recipeCard(context, snapshot.data![index]),
                  ),
                );
              }
            },
          ),
        ),
      ),
      bottomNavigationBar: const BotNavigation(currentIndex: 1),
    );
  }
}

GestureDetector recipeCard(BuildContext context, Recipe recipe) {
  return GestureDetector(
    onTap: () {
      Navigator.pushNamed(context, '/detailRecipe', arguments: recipe);
    },
    child: Card(
      color: Color(0xffC2FCFF),
      margin: EdgeInsets.only(bottom: itemSpacing, top: 0, left: 0, right: 0),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: EdgeInsets.all(padding),
        child: Text(recipe.name, style: Global.fontStyleBaloo(fontSize)),
      ),
    ),
  );
}
