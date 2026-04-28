import 'package:app_for_scada/global.dart';
import 'package:flutter/material.dart';
import '../../widgets/topAppBar.dart';
import 'package:app_for_scada/mixin/mixinDecorations.dart';

final double fontSize = 12.0;
final double titleFontSize = 16.0;
final double gapContents = 5.0;
final double gapTitle = 3.0;
final double spacing = Global.spacing;

class ReportScreen extends StatefulWidget {
  const ReportScreen({super.key});

  @override
  State<ReportScreen> createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen>
    with fontStyleMixin, itemDecorationMixin {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const TopAppBar(title: 'Báo cáo'),
      backgroundColor: Colors.white,
      body: Padding(
        padding: screenPadding(),
        child: GridView.count(
          clipBehavior: Clip.none, //ko bị cắt khi có shadow
          childAspectRatio: 167 / 220, //
          mainAxisSpacing: spacing,
          crossAxisSpacing: spacing,
          crossAxisCount: 2,
          children: [
            informationCell(context, '203', "Đoàn Hạ Vy", "29/10/2025", [
              "Thức ăn mèo",
              "Nước uống",
              "Đồ chơi",
              "Vòng cổ",
              "Giường ngủ",
            ], 2),
          ],
        ),
      ),
    );
  }

  GestureDetector informationCell(
    BuildContext context,
    String id,
    String customerName,
    String orderDate,
    List<String> productName,
    int status,
  ) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, '/reportDetail');
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(
            color: Colors.grey.withValues(alpha: 0.2),
            width: 1,
          ),
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(color: Colors.grey, blurRadius: 4, offset: Offset(4, 4)),
          ],
        ),
        child: Padding(
          padding: EdgeInsets.all(10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Color(0xFF032B91),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  'ID: $id',
                  style: fontStyleBaloo(titleFontSize, color: Colors.white),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(height: gapContents),
              Text(
                'Tên khách hàng:',
                style: fontStyleInter(fontSize, isItalic: true),
              ),
              SizedBox(height: gapTitle),
              Text(
                customerName,
                style: fontStyleInter(fontSize, isBold: true),
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: gapContents),
              Text(
                'Ngày đặt:',
                style: fontStyleInter(fontSize, isItalic: true),
              ),
              SizedBox(height: gapTitle),
              Text(orderDate, style: fontStyleInter(fontSize, isBold: true)),
              SizedBox(height: gapContents),
              Text(
                'Các sản phẩm:',
                style: fontStyleInter(fontSize, isItalic: true),
              ),
              SizedBox(height: gapTitle),
              productListPreview(productName),
              Spacer(),
              Center(child: statusTag(status)),
            ],
          ),
        ),
      ),
    );
  }

  Widget productListPreview(List<String> productName) {
    String fullText;
    if (productName.length <= 3) {
      fullText = productName.join('\n');
    } else {
      fullText = "${productName[0]}\n${productName[1]}\n${productName[2]}...";
    }
    return Text(
      fullText,
      style: fontStyleInter(fontSize, isBold: true),
      maxLines: 3,
      overflow: TextOverflow.ellipsis, // Cắt bỏ phần dư thừa để mờ đúng vị trí
    );
  }

  Container statusTag(int status) {
    var tagInfo = statusTagText(status);
    return Container(
      width: 100,
      decoration: BoxDecoration(
        color: tagInfo.$2,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Center(
        child: Text(
          tagInfo.$1,
          style: fontStyleInter(fontSize, isBold: true, color: Colors.white),
        ),
      ),
    );
  }

  (String, Color) statusTagText(int status) {
    switch (status) {
      case 0:
        return ('Hủy', Color(0xFFFF0000));
      case 1:
        return ('Chờ xử lý', Color(0xFF8C8C8C));
      case 2:
        return ('Đang xử lý', Color(0xFF00BBFF));
      case 3:
        return ('Hoàn thành', Color(0xFF1F7300));
      case 4:
        return ('Đang sản xuất', Colors.green);
      default:
        return ('Không xác định', Color(0xFF000000));
    }
  }
}
