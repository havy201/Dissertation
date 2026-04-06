import 'package:app_for_scada/widgets/botCloseDetailScreen.dart';
import 'package:flutter/material.dart';
import 'package:app_for_scada/widgets/topAppBar.dart';
import 'package:app_for_scada/global.dart';

final double space = Global.spacing;
final double fontTitleSize = 16;
final double fontSize = 12;

class DetailRecipe extends StatefulWidget {
  const DetailRecipe({super.key});

  @override
  State<DetailRecipe> createState() => _DetailRecipeState();
}

class _DetailRecipeState extends State<DetailRecipe> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const TopAppBar(title: 'Công thức'),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(space),
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
                        'Thức ăn cá tra',
                        style: Global.fontStyleBaloo(fontTitleSize),
                      ),
                    ],
                  ),
                  _row('Nguyên liệu 1', 'Bột cá'),
                  _row('Tỷ lệ', '22%'),
                  _row('Nguyên liệu 2', 'Bột đậu nành'),
                  _row('Tỷ lệ', '22%'),
                  _row('Nguyên liệu 3', 'Cám gạo'),
                  _row('Tỷ lệ', '30%'),
                  _row('Phụ gia', 'Vitamin, khoáng, chất kết dính'),
                  _row('Tỷ lệ', '1%'),
                  _row('Nước', 'Nước sạch'),
                  _row('Tỷ lệ', '25%'),
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
}

TableRow _row(String title, String content) {
  return TableRow(
    children: [
      Global.tableCell(title, style: Global.fontStyleInter(fontSize)),
      Global.tableCell(content, style: Global.fontStyleInter(fontSize)),
    ],
  );
}
