import 'package:app_for_scada/model/Production/MaterialItem.dart';
import 'package:app_for_scada/model/Production/Product.dart';
import 'package:app_for_scada/model/Production/Recipe.dart';
import 'package:flutter/material.dart';
import 'package:app_for_scada/widgets/titleAppBar.dart';
import 'package:app_for_scada/global.dart';
import 'package:app_for_scada/mixin/mixinDecorations.dart';
import 'package:get/get.dart';

final double space = Global.spacing;
final double fontTitleSize = 16;
final double fontSize = 16;

class RecipeDetail extends StatefulWidget {
  const RecipeDetail({super.key});

  @override
  State<RecipeDetail> createState() => _RecipeDetailState();
}

class _RecipeDetailState extends State<RecipeDetail>
    with fontStyleMixin, itemDecorationMixin {
  Product? _product;
  List<MaterialItem> _materials = [];
  bool isReload = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_product == null) {
      final args = ModalRoute.of(context)?.settings.arguments;
      if (args is Product) {
        _product = args;
        _materials = _product?.recipe?.recipeMaterials ?? [];
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final product =
        _product ?? ModalRoute.of(context)!.settings.arguments as Product;
    final recipe = product.recipe;
    

    return Scaffold(
      appBar: TitleAppBar(title: 'Công thức', isReload: isReload),
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.all(space),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: SizedBox(
                width: double.infinity,
                child: SingleChildScrollView(
                  child: Table(
                    columnWidths: const {
                      0: FlexColumnWidth(1.5),
                      1: FlexColumnWidth(2),
                    },
                    border: TableBorder.all(
                      color: Colors.grey,
                      width: 1,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                    children: [
                      TableRow(
                        decoration: const BoxDecoration(
                          color: Color(0xFFF0F0F0),
                        ),
                        children: [
                          tableCell(
                            'Tên công thức',
                            style: fontStyleBaloo(fontTitleSize),
                          ),
                          tableCell(
                            product.productName ?? '',
                            style: fontStyleBaloo(fontTitleSize),
                          ),
                        ],
                      ),
                      if (recipe == null)
                        TableRow(
                          children: [
                            tableCell(
                              'Công thức',
                              style: fontStyleInter(fontSize),
                            ),
                            tableCell(
                              'Chưa có dữ liệu công thức',
                              style: fontStyleInter(fontSize),
                            ),
                          ],
                        )
                      else
                        for (var i = 0; i < _materials.length; i++) ...[
                          _row(
                            'Nguyên liệu ${i + 1}',
                            _materials[i].materialName ?? '',
                          ),
                          _row(
                            'Tỷ lệ',
                            _materials[i].targetKg?.toStringAsFixed(3) ?? '',
                          ),
                        ],
                    ],
                  ),
                ),
              ),
            ),
            if (Global.currentUser?.role == 2)
              Align(
                alignment: Alignment.bottomCenter,
                child: filledBtn(
                  () async {
                    final value = await Get.toNamed(
                      '/recipeChange',
                      arguments: product,
                    );

                    if (value != null && value is Recipe) {
                      if (value.recipeMaterials != null) {
                        List<MaterialItem> updatedMaterials = [];
                        for (
                          int i = 0;
                          i < value.recipeMaterials!.length;
                          i++
                        ) {
                          MaterialItem item = MaterialItem(
                            materialId: value.recipeMaterials![i].materialId,
                            materialName:
                                _materials[i].materialName,
                            targetKg: value.recipeMaterials![i].targetKg,
                            toleranceMaxKg: value.recipeMaterials![i].toleranceMaxKg,
                            toleranceMinKg: value.recipeMaterials![i].toleranceMinKg,
                          );
                          updatedMaterials.add(item);
                        }
                        setState(() {
                          _materials = updatedMaterials;
                          isReload = true;
                        });
                      }
                    }
                  },
                  'Cập nhật',
                  color: const Color(0xff00F3FF),
                ),
              ),
          ],
        ),
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
