import 'package:app_for_scada/widgets/titleAppBar.dart';
import 'package:flutter/material.dart';
import '../../global.dart';
import 'package:app_for_scada/mixin/mixinDecorations.dart';

final double itemSpacing = Global.spacing;
final double padding = Global.padding;
final double sizeAvatar = 50;

class ReportDetail extends StatefulWidget {
  const ReportDetail({super.key});

  @override
  State<ReportDetail> createState() => _ReportDetailState();
}

class _ReportDetailState extends State<ReportDetail> with fontStyleMixin {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const TitleAppBar(title: 'Báo cáo'),
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.all(itemSpacing),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Color(0xffEDEDED),
                ),
                child: Padding(
                  padding: EdgeInsets.all(padding),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 37,
                        backgroundColor: Color(0xffE4E4E4),
                        child: CircleAvatar(
                          radius: 36,
                          backgroundColor: Colors.white,
                          child: Image(
                            image: AssetImage('lib/animals/dog.png'),
                            height: sizeAvatar,
                            width: sizeAvatar,
                          ),
                        ),
                      ),
                      SizedBox(width: padding),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('Thức ăn chó', style: fontStyleBaloo(16)),
                          Text('ID: 203', style: fontStyleInter(16)),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: itemSpacing),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Color(0xffEDEDED),
                  ),
                  child: ListView.separated(
                    reverse: false,
                    itemCount: 30, // Số lượng mục trong danh sách
                    separatorBuilder: (context, index) =>
                        Divider(color: Colors.white, height: 2),
                    itemBuilder: (context, index) {
                      return listItem();
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Container listItem() {
    return Container(
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: itemSpacing,
          vertical: itemSpacing / 2,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 30,
              width: 30,
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(5),
              ),
              child: Center(
                child: Image(
                  image: AssetImage('lib/animals/dog.png'),
                  height: 24,
                  width: 24,
                ),
              ),
            ),
            SizedBox(width: itemSpacing),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Nguyên liệu', style: fontStyleBaloo(16)),
                  Text(
                    '100g hạt bắp, 20g đường, 10g sữa đặc, 5g muối, 2g vani, 1000ml nước, 3 quả trứng, 100g bột mì, 30g bơ, 200ml sữa tươi, 4 quả táo',
                    textAlign: TextAlign.justify,
                    style: fontStyleInter(16),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
