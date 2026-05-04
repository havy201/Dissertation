import 'package:flutter/material.dart';
import '../global.dart';
import '../widgets/titleAppBar.dart';
import '../mixin/mixinDecorations.dart';

class HelpScreen extends StatelessWidget
    with itemDecorationMixin, fontStyleMixin {
  const HelpScreen({super.key});

  static const double _lineSpacing = 10.0;
  static const double _fontSize = 20.0;
  static const double _bulletSize = 20.0;

  @override
  Widget build(BuildContext context) {
    final spacing = Global.spacing;
    final padding = Global.padding;
    final titleGap = Global.titleGap;
    final role = Global.currentUser?.role ?? 0; // Mặc định là khách hàng nếu chưa đăng nhập
    final sections = role == 0
        ? _buildCustomerSections(titleGap)
        : _buildStaffSections(titleGap, canAddRecipe: role == 2);

    return Scaffold(
      appBar: TitleAppBar(title: 'Hướng dẫn sử dụng'),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(spacing),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: _buildSectionWidgets(
              sections,
              spacing,
              padding,
              titleGap,
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> _buildSectionWidgets(
    List<GuideSection> sections,
    double spacing,
    double padding,
    double titleGap,
  ) {
    final widgets = <Widget>[];
    for (var i = 0; i < sections.length; i++) {
      widgets.add(_guideSection(sections[i], padding, titleGap));
      if (i < sections.length - 1) {
        widgets.add(SizedBox(height: spacing));
      }
    }
    return widgets;
  }

  Widget _guideSection(GuideSection section, double padding, double titleGap) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(section.title, style: fontStyleBaloo(_fontSize)),
        SizedBox(height: titleGap),
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(padding),
          decoration: containerDecoration(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: _buildGuideItems(section.items, titleGap),
          ),
        ),
      ],
    );
  }

  List<Widget> _buildGuideItems(List<GuideItem> items, double titleGap) {
    final widgets = <Widget>[];
    for (var i = 0; i < items.length; i++) {
      final item = items[i];
      widgets.add(_guideLineItem(item.pathIcon, item.parts, size: item.size));
      if (i < items.length - 1) {
        widgets.add(SizedBox(height: item.gapAfter ?? _lineSpacing));
      }
    }
    return widgets;
  }

  Widget _guideLineItem(String pathIcon, List<TextPart> parts, {double? size}) {
    final primaryBlue = Global.primaryBlue;
    final padding = Global.padding;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Image.asset(
          pathIcon,
          width: size ?? 43,
          height: size ?? 43,
          color: primaryBlue,
        ),
        SizedBox(width: padding),
        Expanded(
          child: Text.rich(
            TextSpan(
              style: fontStyleInter(_fontSize),
              children: parts
                  .map(
                    (part) => TextSpan(
                      text: part.text,
                      style: fontStyleInter(_fontSize, isBold: part.isBold),
                    ),
                  )
                  .toList(),
            ),
            textAlign: TextAlign.justify,
          ),
        ),
      ],
    );
  }

  List<GuideSection> _buildCustomerSections(double titleGap) {
    return [
      GuideSection(
        title: 'Hướng dẫn đặt hàng',
        items: [
          GuideItem('lib/icons/home_light.png', [
            TextPart('Quý khách nhấn vào trang '),
            TextPart('Đặt hàng', isBold: true),
            TextPart('.'),
          ]),
          GuideItem('lib/icons/recipe_light.png', [
            TextPart('Nhấn vào ô chọn '),
            TextPart('Chọn sản phẩm', isBold: true),
            TextPart(' để chọn sản phẩm muốn mua.'),
          ]),
          GuideItem('lib/icons/shoppingBasket.png', [
            TextPart('Nhập '),
            TextPart('số lượng mẻ', isBold: true),
            TextPart(' tương ứng số lượng sản phẩm muốn mua.'),
          ]),
          GuideItem('lib/icons/plus.png', [
            TextPart('Nếu muốn mua thêm sản phẩm khác, nhấn nút '),
            TextPart('Thêm sản phẩm', isBold: true),
            TextPart(' và tiếp tục mua sắm.'),
          ]),
        ],
      ),
      GuideSection(
        title: 'Theo dõi và kiểm tra đơn hàng',
        items: [
          GuideItem('lib/icons/report_light.png', [
            TextPart('Quý khách nhấn vào trang '),
            TextPart('Theo dõi đơn hàng', isBold: true),
            TextPart('. '),
          ]),
          GuideItem('lib/icons/report_light.png', [
            TextPart(
              'Sẽ có các đơn hàng mà khách đã đặt, và các thông tin chung của đơn hàng. ',
            ),
            TextPart('Nhấn vào đơn hàng', isBold: true),
            TextPart(' để xem chi tiết đơn hàng.'),
          ]),
          GuideItem('lib/icons/warning.png', [
            TextPart('Quý khách có thể hủy đơn hàng nếu '),
            TextPart('sản phẩm chưa được xử lý', isBold: true),
            TextPart(
              '. Khi đơn hàng đã được xử lý, quý khách sẽ không thể hủy đơn hàng.',
            ),
          ]),
        ],
      ),
      GuideSection(
        title: 'Kiểm tra thông tin người dùng',
        items: [
          GuideItem('lib/icons/user_account.png', [
            TextPart('Quý khách nhấn vào nút '),
            TextPart('Thông tin người dùng', isBold: true),
            TextPart('. '),
          ]),
          GuideItem('lib/icons/user_account.png', [
            TextPart('Quý khách kiểm tra các thông tin cá nhân tại đây.'),
          ]),
          GuideItem('lib/icons/loginPassword.png', [
            TextPart('Có thể thay đổi '),
            TextPart('mật khẩu', isBold: true),
            TextPart(' để bảo mật tài khoản.'),
          ]),
        ],
      ),
    ];
  }

  List<GuideSection> _buildStaffSections(
    double titleGap, {
    required bool canAddRecipe,
  }) {
    return [
      GuideSection(
        title: 'Hướng dẫn kiểm tra trạng thái sản xuất',
        items: [
          GuideItem('lib/icons/home_light.png', [
            TextPart('Nhân viên nhấn vào '),
            TextPart('Trang chủ', isBold: true),
            TextPart(' để kiểm tra trạng thái sản xuất. '),
          ], gapAfter: titleGap),
          GuideItem(
            'lib/icons/bullet.png',
            [
              TextPart('Gồm 2 chế độ hoạt động: '),
              TextPart('Auto (tự động)', isBold: true),
              TextPart(' và '),
              TextPart('Manu (thủ công)', isBold: true),
              TextPart('.'),
            ],
            size: _bulletSize,
            gapAfter: titleGap,
          ),
          GuideItem(
            'lib/icons/bullet.png',
            [
              TextPart('Gồm 8 trạng thái hoạt động: '),
              TextPart('Idle (khởi tạo hệ thống)', isBold: true),
              TextPart(', '),
              TextPart('Run (đang hoạt động)', isBold: true),
              TextPart(', '),
              TextPart('Abort (hủy bỏ)', isBold: true),
              TextPart(', '),
              TextPart('Stop (dừng)', isBold: true),
              TextPart(', '),
              TextPart('Pause (tạm nghỉ)', isBold: true),
              TextPart(', '),
              TextPart('Hold (giữ)', isBold: true),
              TextPart(', '),
              TextPart('Restart (khởi động lại)', isBold: true),
              TextPart(', '),
              TextPart('Complete (hoàn thành)', isBold: true),
              TextPart('.'),
            ],
            size: _bulletSize,
            gapAfter: titleGap,
          ),
          GuideItem('lib/icons/bullet.png', [
            TextPart('Công đoạn', isBold: true),
            TextPart(
              ' tương ứng với các bước đang được thực hiện trên hệ thống.',
            ),
          ], size: _bulletSize),
        ],
      ),
      GuideSection(
        title: 'Xem các loại công thức',
        items: [
          GuideItem('lib/icons/recipe_light.png', [
            TextPart('Nhân viên nhấn vào nút '),
            TextPart('Công thức', isBold: true),
            TextPart('. '),
          ]),
          GuideItem('lib/icons/recipe_light.png', [
            TextPart('Toàn bộ các loại công thức được hiển thị tại đây.'),
          ]),
          if (canAddRecipe)
            GuideItem('lib/icons/plus.png', [
              TextPart(
                'Nhân viên có thể thêm công thức mới bằng cách nhấn nút ',
              ),
              TextPart('Thêm công thức', isBold: true),
              TextPart('.'),
            ]),
        ],
      ),
      GuideSection(
        title: 'Theo dõi quá trình cân nguyên liệu',
        items: [
          GuideItem('lib/icons/trend_light.png', [
            TextPart('Nhân viên nhấn vào nút '),
            TextPart('Biểu đồ', isBold: true),
            TextPart('. '),
          ]),
          GuideItem('lib/icons/trend_light.png', [
            TextPart(
              'Nhân viên kiểm tra thông tin về quá trình cân 5 loại nguyên liệu tại đây.',
            ),
          ]),
        ],
      ),
      GuideSection(
        title: 'Kiểm tra các cảnh báo hệ thống',
        items: [
          GuideItem('lib/icons/alarm_light.png', [
            TextPart('Nhân viên nhấn vào nút '),
            TextPart('Cảnh báo', isBold: true),
            TextPart('. '),
          ]),
          GuideItem('lib/icons/alarm_light.png', [
            TextPart(
              'Nhân viên kiểm tra các cảnh báo hệ thống tại đây. Bao gồm: ',
            ),
          ]),
          GuideItem('lib/icons/bullet.png', [
            TextPart('Thời gian xảy ra lỗi.'),
          ], size: _bulletSize),
          GuideItem('lib/icons/bullet.png', [
            TextPart('Các loại lỗi. Có 3 loại lỗi: '),
            TextPart('System alarm, System warning, Alarm', isBold: true),
          ], size: _bulletSize),
          GuideItem('lib/icons/bullet.png', [
            TextPart('Lỗi chi tiết.'),
          ], size: _bulletSize),
          GuideItem('lib/icons/bullet.png', [
            TextPart('Trạng thái lỗi. Có 2 trạng thái lỗi: '),
            TextPart('Đã xử lý / Chưa xử lý', isBold: true),
          ], size: _bulletSize),
        ],
      ),
      GuideSection(
        title: 'Theo dõi các đơn hàng của dây chuyền sản xuất',
        items: [
          GuideItem('lib/icons/report_light.png', [
            TextPart('Nhân viên nhấn vào trang '),
            TextPart('Báo cáo', isBold: true),
            TextPart('. '),
          ]),
          GuideItem('lib/icons/report_light.png', [
            TextPart(
              'Sẽ có các đơn hàng mà khách hàng đã đặt, và các thông tin chung của đơn hàng. ',
            ),
            TextPart('Nhấn vào đơn hàng', isBold: true),
            TextPart(' để xem chi tiết đơn hàng.'),
          ]),
        ],
      ),
      GuideSection(
        title: 'Kiểm tra thông tin người dùng',
        items: [
          GuideItem('lib/icons/user_account.png', [
            TextPart('Nhân viên nhấn vào nút '),
            TextPart('Thông tin người dùng', isBold: true),
            TextPart('. '),
          ]),
          GuideItem('lib/icons/user_account.png', [
            TextPart('Nhân viên kiểm tra các thông tin cá nhân tại đây.'),
          ]),
          GuideItem('lib/icons/loginPassword.png', [
            TextPart('Nhân viên có thể thay đổi '),
            TextPart('mật khẩu', isBold: true),
            TextPart(' để bảo mật tài khoản.'),
          ]),
        ],
      ),
    ];
  }
}

class GuideSection {
  final String title;
  final List<GuideItem> items;
  const GuideSection({required this.title, required this.items});
}

class GuideItem {
  final String pathIcon;
  final List<TextPart> parts;
  final double? size;
  final double? gapAfter;
  const GuideItem(this.pathIcon, this.parts, {this.size, this.gapAfter});
}

class TextPart {
  final String text;
  final bool isBold;
  const TextPart(this.text, {this.isBold = false});
}
