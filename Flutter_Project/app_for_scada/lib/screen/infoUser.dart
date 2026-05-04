import 'package:app_for_scada/model/Login/Account.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../widgets/titleAppBar.dart';
import '../global.dart';
import '../mixin/mixinDecorations.dart';

class InfoUser extends StatefulWidget {
  const InfoUser({super.key});

  @override
  State<InfoUser> createState() => _InfoUserState();
}

class _InfoUserState extends State<InfoUser>
    with itemDecorationMixin, fontStyleMixin {
  static const double _frameSize = 120.0;
  static const double _imageSize = 100.0;
  static const double _fontSize = 20.0;
  @override
  Widget build(BuildContext context) {
    final spacing = Global.spacing;
    final titleGap = Global.titleGap;
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
            _buildAvatar(role.$2, user, titleGap),
            SizedBox(height: spacing),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Color(0xffEDEDED),
              ),
              child: _buildInfoList(context, spacing, user, role),
            ),
            const Spacer(),
            filledBtn(
              () {
                Global.currentUser = null;
                Get.offAllNamed('/loginScreen');
              },
              'Đăng xuất',
              color: Color(0xffFF0000),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAvatar(String imagePath, Account? user, double titleGap) {
    const framePadding = (_frameSize - _imageSize) / 2;
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(framePadding),
            width: _frameSize,
            height: _frameSize,
            decoration: containerDecoration(color: const Color(0xff032B91)),
            child: Image.asset(
              imagePath,
              width: _imageSize,
              height: _imageSize,
            ),
          ),
          SizedBox(height: titleGap),
          Text(user?.userName ?? 'N/A', style: fontStyleBaloo(_fontSize)),
        ],
      ),
    );
  }

  Widget _buildInfoList(
    BuildContext context,
    double spacing,
    Account? user,
    (String, String) role,
  ) {
    final infos = [
      ('Họ và tên', user?.fullName ?? 'N/A', 0),
      ('Số điện thoại', user?.phoneNumber ?? 'N/A', 1),
      ('Loại tài khoản', role.$1, 3),
      ('Mật khẩu', 'Cập nhật mật khẩu', 2),
    ];

    return Column(
      children: [
        for (var i = 0; i < infos.length; i++) ...[
          _detailInfo(context, infos[i].$1, infos[i].$2, infos[i].$3),
          if (i < infos.length - 1) _divider(),
        ],
      ],
    );
  }

  Widget _divider() => Divider(color: Colors.white, height: 2);
  Widget _detailInfo(
    BuildContext context,
    String title,
    String content,
    int isEditable,
  ) {
    final padding = Global.padding;
    final spacing = Global.spacing;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: padding, vertical: spacing / 2),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '$title:',
                style: fontStyleInter(
                  _fontSize,
                  color: Colors.black,
                  isBold: true,
                ),
              ),
              Text(content, style: fontStyleBaloo(_fontSize)),
            ],
          ),
          const Spacer(),
          if (isEditable == 0 || isEditable == 1 || isEditable == 2)
            IconButton(
              onPressed: () {
                Navigator.pushNamed(
                  context,
                  '/updateInfoUser',
                  arguments: isEditable,
                ).then((result) {
                  if (result == true) {
                    setState(() {});
                  }
                });
              },
              icon: const Icon(Icons.edit, color: Color(0xff032B91)),
            ),
        ],
      ),
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
