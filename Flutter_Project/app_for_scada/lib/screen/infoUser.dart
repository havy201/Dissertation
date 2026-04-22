import 'package:app_for_scada/model/Account.dart';
import 'package:flutter/material.dart';
import '../widgets/titleAppBar.dart';
import '../global.dart';
import '../mixin/mixinDecorations.dart';

class InfoUser extends StatelessWidget
    with itemDecorationMixin, fontStyleMixin {
  const InfoUser({super.key});

  static const double _frameSize = 120.0;
  static const double _imageSize = 100.0;
  static const double _fontSize = 20.0;

  @override
  Widget build(BuildContext context) {
    final spacing = Global.spacing;
    final Account? user = Global.currentUser;
    final (String, String) role = roleOfUser(user?.role ?? 3);

    return Scaffold(
      appBar: TitleAppBar(title: 'Thông tin tài khoản'),
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.all(spacing),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _buildAvatar(role.$2),
            SizedBox(height: spacing),
            _buildInfoList(spacing, user, role),
            const Spacer(),
            filledBtn(
              () => Navigator.pushNamed(context, '/updateInfoUser'),
              'Đổi mật khẩu',
              color: const Color(0xff00F3FF),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAvatar(String imagePath) {
    const framePadding = (_frameSize - _imageSize) / 2;
    return Center(
      child: Container(
        padding: const EdgeInsets.all(framePadding),
        width: _frameSize,
        height: _frameSize,
        decoration: containerDecoration(color: const Color(0xff032B91)),
        child: Image.asset(imagePath, width: _imageSize, height: _imageSize),
      ),
    );
  }

  Widget _buildInfoList(double spacing, Account? user, (String, String) role) {
    final infos = [
      ('Loại tài khoản', role.$1),
      ('Họ và tên', user?.fullname ?? 'N/A'),
      ('Số điện thoại', user?.phone ?? 'N/A'),
      ('Tên đăng nhập', user?.username ?? 'N/A'),
    ];

    return Column(
      children: [
        for (var i = 0; i < infos.length; i++) ...[
          _detailInfo(infos[i].$1, infos[i].$2),
          if (i < infos.length - 1) SizedBox(height: spacing),
        ],
      ],
    );
  }

  Widget _detailInfo(String title, String content) {
    return Row(
      children: [
        Expanded(
          child: Text(
            '$title:',
            style: fontStyleBaloo(_fontSize),
            textAlign: TextAlign.left,
          ),
        ),
        Expanded(
          child: Text(
            content,
            style: fontStyleBaloo(_fontSize, color: Colors.black),
            textAlign: TextAlign.right,
          ),
        ),
      ],
    );
  }

  (String, String) roleOfUser(int role) {
    switch (role) {
      case 0:
        return ('Khách hàng', 'lib/icons/ava_customer.png');
      case 1:
        return ('Nhân viên', 'lib/icons/ava_staff.png');
      case 2:
        return ('Quản lý', 'lib/icons/ava_manager.png');
      default:
        return ('N/A', 'lib/icons/null.png');
    }
  }
}
