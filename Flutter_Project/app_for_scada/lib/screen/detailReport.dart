import 'package:app_for_scada/widgets/botCloseDetailScreen.dart';
import 'package:app_for_scada/widgets/topAppBar.dart';
import 'package:flutter/material.dart';
import '../global.dart';

final double itemSpacing = Global.spacing;
final double padding = Global.padding;
final double sizeAvatar = 50;

class DetailReport extends StatefulWidget {
  const DetailReport({super.key});

  @override
  State<DetailReport> createState() => _DetailReportState();
}

class _DetailReportState extends State<DetailReport> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TopAppBar(title: 'Báo cáo'),
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
                          Text('Thức ăn chó', style: Global.fontStyleBaloo(16)),
                          Text('ID: 203', style: Global.fontStyleInter(16)),
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
                      return ListTile(
                        leading: Icon(
                          Icons.person,
                          color: Colors.blue,
                        ), // Thay bằng Container bọc Icon nếu muốn giống ảnh
                        title: Text(
                          'Khách hàng',
                          style: Global.fontStyleInter(16, isBold: true),
                        ),
                        subtitle: Text(
                          'Hạ Vy',
                          style: Global.fontStyleInter(
                            16,
                            isItalic: true,
                            color: Colors.grey,
                          ),
                        ),
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 4,
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const BotCloseDetailScreen(
        screenName: 'reportScreen',
      ),
    );
  }
}
