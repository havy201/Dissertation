import 'package:app_for_scada/model/Recipe.dart';
import 'package:app_for_scada/widgets/botCloseDetailScreen.dart';
import 'package:flutter/material.dart';
import 'package:app_for_scada/widgets/topAppBar.dart';
import 'package:app_for_scada/global.dart';

final double space = Global.spacing;
final double fontTitleSize = 16;
final double fontSize = 12;

class DetailRecipe extends StatelessWidget {
  const DetailRecipe({super.key});

  @override
  Widget build(BuildContext context) {
    final Recipe recipe = ModalRoute.of(context)!.settings.arguments as Recipe;
    return Scaffold(
      appBar: const TopAppBar(title: 'Công thức'),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(left: space, right: space, top: space),
          child: Column(
            children: [
              Table(
                columnWidths: {0: FlexColumnWidth(1.5), 1: FlexColumnWidth(2)},
                border: TableBorder.all(
                  color: Colors.grey,
                  width: 1,
                  borderRadius: BorderRadius.circular(10),
                ),
                defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                children: [
                  TableRow(
                    decoration: BoxDecoration(color: Color(0xFFF0F0F0)),
                    children: [
                      Global.tableCell(
                        'Tên công thức',
                        style: Global.fontStyleBaloo(fontTitleSize),
                      ),
                      Global.tableCell(
                        recipe.name,
                        style: Global.fontStyleBaloo(fontTitleSize),
                      ),
                    ],
                  ),
                  _row('Nguyên liệu 1', recipe.ingredient1),
                  _row('Tỷ lệ', recipe.ratio1.toString()),
                  _row('Nguyên liệu 2', recipe.ingredient2),
                  _row('Tỷ lệ', recipe.ratio2.toString()),
                  _row('Nguyên liệu 3', recipe.ingredient3),
                  _row('Tỷ lệ', recipe.ratio3.toString()),
                  _row('Phụ gia', recipe.spice),
                  _row('Tỷ lệ', recipe.ratioSpice.toString()),
                  _row('Nước', recipe.water),
                  _row('Tỷ lệ', recipe.ratioWater.toString()),
                ],
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const BotCloseDetailScreen(
        screenName: 'recipeScreen',
      ),
    );
  }

  TableRow _row(String title, String content) {
    return TableRow(
      children: [
        Global.tableCell(title, style: Global.fontStyleInter(fontSize)),
        Global.tableCell(content, style: Global.fontStyleInter(fontSize)),
      ],
    );
  }
}
