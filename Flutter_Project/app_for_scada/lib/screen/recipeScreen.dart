import 'package:app_for_scada/global.dart';
import 'package:flutter/material.dart';
import 'package:app_for_scada/widgets/botNavigation.dart';
import 'package:app_for_scada/widgets/topAppBar.dart';

final double itemSpacing = Global.spacing;
final double padding = Global.padding;
final double fontSize = 20;

class RecipeScreen extends StatefulWidget {
  const RecipeScreen({super.key});

  @override
  State<RecipeScreen> createState() => _RecipeScreenState();
}

class _RecipeScreenState extends State<RecipeScreen> {
  final List<String> baseRecipes = [
    'Công thức 1: Thức ăn cho mèo',
    'Công thức 2: Thức ăn cho chó',
    'Công thức 3: Thức ăn cho cá',
    'Công thức 4: Thức ăn cho gà',
    'Công thức 5: Thức ăn cho lợn',
    'Công thức 6: Thức ăn cho bò',
    'Công thức 7: Thức ăn cho thỏ',
    'Công thức 8: Thức ăn cho chim',
    'Công thức 9: Thức ăn cho rắn',
    'Công thức 10: Thức ăn cho ngựa',
    'Công thức 11: Thức ăn cho dê',
    'Công thức 12: Thức ăn cho cừu',
    'Công thức 13: Thức ăn cho gà con',
    'Công thức 14: Thức ăn cho vịt',
    'Công thức 15: Thức ăn cho ngan',
    'Công thức 16: Thức ăn cho cá koi',
    'Công thức 17: Thức ăn cho cá vàng',
    'Công thức 18: Thức ăn cho cá chép',
    'Công thức 19: Thức ăn cho cá rô',
    'Công thức 20: Thức ăn cho cá trê',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const TopAppBar(title: 'Công thức'),
      backgroundColor: Colors.white,
      // body: SingleChildScrollView(
      //   child: Padding(
      //     padding: EdgeInsets.all(itemSpacing),
      //     child: Center(
      //       child: Column(
      //         crossAxisAlignment:
      //             CrossAxisAlignment.stretch, //ep cac con dan het chieu ngang
      //         children: List.generate(
      //           baseRecipes.length,
      //           (index) =>
      //               Decorations().recipeCard(context, baseRecipes[index]),
      //         ),
      //       ),
      //     ),
      //   ),
      // ),
      body: Padding(
        padding: EdgeInsets.all(itemSpacing),
        child: ListView(
          reverse: false,
          children: List.generate(
            baseRecipes.length,
            (index) => Decorations().recipeCard(context, baseRecipes[index]),
          ),
        ),
      ),
      bottomNavigationBar: const BotNavigation(currentIndex: 1),
    );
  }
}

class Decorations {
  GestureDetector recipeCard(BuildContext context, String text) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, '/detailRecipe');
      },
      child: Card(
        color: Color(0xffC2FCFF),
        margin: EdgeInsets.only(bottom: itemSpacing, top: 0, left: 0, right: 0),
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Padding(
          padding: EdgeInsets.all(padding),
          child: Text(text, style: Global.fontStyleBaloo(fontSize)),
        ),
      ),
    );
  }
}
