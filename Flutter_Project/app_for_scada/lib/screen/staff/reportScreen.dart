import 'package:app_for_scada/global.dart';
import 'package:flutter/material.dart';
import '../../widgets/botNavigation.dart';
import '../../widgets/topAppBar.dart';
import 'package:app_for_scada/mixin/mixinDecorations.dart';

final double fontSize = 12;
final double fontSizeNote = 10;
final double spacing = Global.spacing;

class ReportScreen extends StatefulWidget {
  const ReportScreen({super.key});

  @override
  State<ReportScreen> createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> with fontStyleMixin {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const TopAppBar(title: 'Báo cáo'),
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.all(spacing),
        child: GridView.count(
          clipBehavior: Clip.none, //ko bị cắt khi có shadow
          childAspectRatio: 167 / 251, //
          mainAxisSpacing: spacing,
          crossAxisSpacing: spacing,
          crossAxisCount: 2,
          children: [
            informationCell(
              context,
              'lib/animals/cat.png',
              'Thức ăn mèo',
              2,
              '203',
              'Hạ Vy',
              '29/10/2025',
              'bột cá, bột đậu nành, cám gạo',
            ),
          ],
        ),
      ),
      bottomNavigationBar: const BotNavigation(currentIndex: 4),
    );
  }

  GestureDetector informationCell(
    BuildContext context,
    String imagePath,
    String productName,
    int status,
    String id,
    String customerName,
    String orderDate,
    String ingredients,
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
              Center(child: Image.asset(imagePath, width: 80, height: 80)),
              SizedBox(height: 2),
              Center(child: Text(productName, style: fontStyleBaloo(20))),
              Spacer(),
              Align(alignment: Alignment.centerRight, child: statusTag(status)),
              Spacer(),
              Text('ID: $id', style: fontStyleInter(fontSize)),
              Spacer(),
              Text(
                'Khách hàng: $customerName',
                style: fontStyleInter(fontSize),
                overflow: TextOverflow.ellipsis,
              ),
              Spacer(),
              Text('Ngày đặt: $orderDate', style: fontStyleInter(fontSize)),
              Spacer(),
              Text(
                'Thành phần: $ingredients',
                softWrap: true,
                overflow: TextOverflow.fade,
                maxLines: 3,
                style: fontStyleInter(
                  fontSizeNote,
                  isItalic: true,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Container statusTag(int status) {
    var tagInfo = statusTagText(status);
    return Container(
      height: 19,
      width: 75,
      decoration: BoxDecoration(
        color: tagInfo.$2,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Center(
        child: Text(
          tagInfo.$1,
          style: fontStyleInter(
            fontSizeNote,
            isBold: true,
            color: Colors.white,
          ),
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
