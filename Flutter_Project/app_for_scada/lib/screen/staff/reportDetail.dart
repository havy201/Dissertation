import 'package:app_for_scada/widgets/titleAppBar.dart';
import 'package:flutter/material.dart';
import '../../global.dart';
import 'package:app_for_scada/mixin/mixinDecorations.dart';

final double spacing = Global.spacing;
final double padding = Global.padding;
final double sizeAvatar = 50;
final double fontSize = 20;
final double fontSizeTitle = 18;
final double fontSizeContent = 16;

class ReportDetail extends StatefulWidget {
  const ReportDetail({super.key});

  @override
  State<ReportDetail> createState() => _ReportDetailState();
}

class _ReportDetailState extends State<ReportDetail>
    with fontStyleMixin, itemDecorationMixin {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const TitleAppBar(title: 'Báo cáo'),
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.all(spacing),
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
                      Image.asset(
                        'lib/icons/animalfood.png',
                        width: sizeAvatar,
                        height: sizeAvatar,
                      ),
                      SizedBox(width: padding),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Mã đơn hàng',
                              style: fontStyleBaloo(fontSize),
                            ),
                            Text(
                              'ID: 203',
                              style: fontStyleBaloo(
                                fontSize,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: spacing),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Color(0xffEDEDED),
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        _buildInfoRow(
                          'lib/icons/customer.png',
                          Color(0xff2196F3),
                          'Khách hàng',
                          'Nguyễn Văn A',
                        ),
                        _divider(),
                        _buildInfoRow(
                          'lib/icons/phonenumber.png',
                          Color(0xff006923),
                          'Số điện thoại',
                          '0123456789',
                        ),
                        _divider(),
                        _buildInfoRow(
                          'lib/icons/shoppingBasket.png',
                          Color(0xffCC3300),
                          'Trạng thái',
                          'Đang xử lí',
                        ),
                        _divider(),
                        _buildInfoRow(
                          'lib/icons/startTime.png',
                          Color(0xff9D9D9D),
                          'Thời gian bắt đầu',
                          '08:00 AM',
                        ),
                        _divider(),
                        _buildInfoRow(
                          'lib/icons/endTime.png',
                          Color(0xff9D9D9D),
                          'Thời gian kết thúc',
                          '08:00 AM',
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(
    String path,
    Color color,
    String title,
    String value, {
    bool showArrow = false,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: padding, vertical: spacing / 2),
      child: Row(
        children: [
          Container(
            height: 30,
            width: 30,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(5),
            ),
            child: Center(
              child: Image.asset(
                path,
                height: 24,
                width: 24,
                color: Colors.white,
              ),
            ),
          ),
          SizedBox(width: padding),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: fontStyleInter(fontSizeTitle)),
                Text(
                  value,
                  style: fontStyleInter(
                    fontSizeContent,
                    isItalic: true,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
          if (showArrow)
            IconButton(
              icon: Icon(
                Icons.arrow_forward_ios,
                size: 24,
                color: Colors.black,
              ),
              onPressed: () {
                _showProductDetails(context);
              },
            ),
        ],
      ),
    );
  }

  Widget _divider() => Divider(color: Colors.white, height: 2);

  void _showProductDetails(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: true, // Bấm ra ngoài để đóng
      builder: (BuildContext context) {
        return Center(
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: spacing),
            padding: EdgeInsets.all(padding),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: const Color(0xFF032B91),
                width: 3,
              ), // Viền xanh đậm
            ),
            child: Material(
              // Cần Material để Text không bị gạch chân vàng
              color: Colors.transparent,
              child: Column(
                mainAxisSize: MainAxisSize.min, // Để bảng cao vừa khít nội dung
                children: [
                  Text(
                    'Thức ăn chó',
                    style: fontStyleBaloo(
                      fontSize,
                      color: const Color(0xFF032B91),
                    ),
                  ),
                  SizedBox(height: padding),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Tỷ lệ thành phần:',
                      style: fontStyleBaloo(fontSizeTitle),
                    ),
                  ),
                  SizedBox(height: padding),
                  Text(
                    '100g hạt bắp, 20g đường, 10g sữa đặc, 5g muối, 2g vani, 1000ml nước, 3 quả trứng, 100g bột mì, 30g bơ, 200ml sữa tươi, 4 quả táo',
                    textAlign: TextAlign.justify,
                    style: fontStyleBaloo(fontSizeContent, color: Colors.black),
                  ),
                  SizedBox(height: padding),
                  _rowInfo('Số lượng đặt hàng', '1000'),
                  SizedBox(height: padding),
                  _rowInfo('Số lượng đã sản xuất', '800'),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _rowInfo(String title, String content) {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: Text(
            '$title:',
            style: fontStyleBaloo(fontSizeTitle),
            textAlign: TextAlign.left,
          ),
        ),
        Expanded(
          child: Text(
            content,
            style: fontStyleBaloo(fontSizeContent, color: Colors.black),
            textAlign: TextAlign.right,
          ),
        ),
      ],
    );
  }
}
