import 'package:app_for_scada/model/Recipe.dart';
import 'package:app_for_scada/widgets/botCloseDetailScreen.dart';
import 'package:flutter/material.dart';
import 'package:app_for_scada/widgets/topAppBar.dart';
import 'package:app_for_scada/global.dart';
import 'package:app_for_scada/mixin/mixinDecorations.dart';

final double space = Global.spacing;
final double fontTitleSize = 16;
final double fontSize = 12;

class DetailRecipe extends StatelessWidget
    with fontStyleMixin, itemDecorationMixin {
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
                      tableCell(
                        'Tên công thức',
                        style: fontStyleBaloo(fontTitleSize),
                      ),
                      tableCell(
                        recipe.name,
                        style: fontStyleBaloo(fontTitleSize),
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
        tableCell(title, style: fontStyleInter(fontSize)),
        tableCell(content, style: fontStyleInter(fontSize)),
      ],
    );
  }
}
