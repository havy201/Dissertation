import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../global.dart';

mixin mixinDecoration {
  Padding prefixIconPadding(String assetPath) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
      child: Image.asset(
        assetPath,
        width: 35,
        height: 35,
        color: const Color(0xFF032B91),
      ),
    );
  }

  EdgeInsets contentPadding() {
    return const EdgeInsets.only(left: 21, right: 12, top: 20, bottom: 20);
  }

  OutlineInputBorder outlineInputBorder() {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: const BorderSide(color: Color(0xFF032B91), width: 2),
    );
  }

  Padding suffixIconPadding(bool obscurePassword, Function()? toggleObscure) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
      child: GestureDetector(
        onTap: toggleObscure,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
          child: Image.asset(
            obscurePassword
                ? 'lib/icons/hidePassword.png'
                : 'lib/icons/showPassword.png',
            width: 35,
            height: 35,
          ),
        ),
      ),
    );
  }

  TableCell tableCell(String text, {TextStyle? style}) {
    return TableCell(
      verticalAlignment: TableCellVerticalAlignment.middle,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(text, style: style),
      ),
    );
  }

  BoxDecoration containerDecoration({Color? color}) {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(10),
      border: Border.all(color: color ?? const Color(0xff8C8C8C), width: 3),
    );
  }

  FloatingActionButton floatingBtn(VoidCallback? onPressed) {
    return FloatingActionButton(
      onPressed: onPressed,
      shape: const CircleBorder(
        side: BorderSide(color: Color(0xFF032B91), width: 4),
      ),
      backgroundColor: Colors.white,
      child: const Icon(Icons.add, size: 40, color: Color(0xFF032B91)),
    );
  }

  Widget iconBtnCustom(VoidCallback? onPressed) {
    return FloatingActionButton(
      onPressed: onPressed,
      shape: const CircleBorder(
        side: BorderSide(color: Color(0xFF032B91), width: 4),
      ),
      elevation: 0,
      backgroundColor: Colors.white,
      child: const Icon(Icons.add, size: 40, color: Color(0xFF032B91)),
    );
  }

  SizedBox filledBtn(VoidCallback? onPressed, String text, {Color? color}) {
    return SizedBox(
      width: 276,
      height: 46,
      child: FilledButton(
        onPressed: onPressed,
        style: FilledButton.styleFrom(
          backgroundColor: color ?? const Color(0xFF032B91),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: Text(
          text,
          style: const TextStyle(
            fontFamily: 'Baloo',
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  EdgeInsets screenPadding() {
    final spacing = Global.spacing;
    final bottomWidth = Global.bottomWidth;
    return EdgeInsets.fromLTRB(
      spacing,
      spacing,
      spacing,
      bottomWidth + spacing,
    );
  }

  TextStyle fontStyleBaloo(double size, {Color? color}) {
    return TextStyle(
      fontFamily: 'Baloo',
      fontSize: size,
      fontWeight: FontWeight.bold,
      color: color ?? const Color(0xFF032B91),
    );
  }

  TextStyle fontStyleInter(
    double size, {
    bool isBold = false,
    bool isItalic = false,
    Color? color,
  }) {
    return TextStyle(
      fontFamily: 'Inter',
      fontSize: size,
      fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
      fontStyle: isItalic ? FontStyle.italic : FontStyle.normal,
      color: color ?? Colors.black,
    );
  }
}

mixin mixinFuntions {
  FormFieldValidator<String> mesIFieldValidator(String message) {
    return (value) {
      if (value == null || value.isEmpty) {
        return message;
      }
      return null;
    };
  }

  FormFieldValidator<String> mesNumberValidator(String message) {
    return (value) {
      if (value == null || value.isEmpty) {
        return message;
      }
      if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
        return 'Chỉ được nhập số';
      }
      return null;
    };
  }

  FormFieldValidator<T> mesDropdownValidation<T>(String message) {
    return (value) {
      if (value == null) {
        return message;
      }
      return null;
    };
  }
}

mixin mixinWidgetWithFunction<T extends StatefulWidget>
    on State<T>, mixinDecoration {
  ScaffoldFeatureController<SnackBar, SnackBarClosedReason> notifyUser(
    BuildContext context,
    String text,
    TextStyle textStyle,
    Color color,
  ) {
    final double spacing = Global.spacing;
    final double bottomWidth = Global.bottomWidth;
    return ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        margin: EdgeInsets.only(
          bottom: spacing + bottomWidth,
          left: spacing,
          right: spacing,
        ),
        duration: const Duration(milliseconds: 2000),
        content: Text(text, style: textStyle, textAlign: TextAlign.center),
        behavior: SnackBarBehavior.floating,
        backgroundColor: color,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  Future<void> showConfirmDialog({
    required String title,
    required VoidCallback onConfirm,
    TextStyle? titleStyle,
    TextStyle? actionStyle,
    String confirmText = 'Đồng ý',
    String cancelText = 'Hủy',
  }) {
    return showDialog<void>(
      context: context,
      builder: (dialogContext) => CupertinoAlertDialog(
        title: Text(title, style: titleStyle),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(dialogContext);
              onConfirm();
            },
            child: Text(confirmText, style: actionStyle),
          ),
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text(cancelText, style: actionStyle),
          ),
        ],
      ),
    );
  }

  GestureDetector informationCell(
    BuildContext context,
    String id,
    String customerName,
    String orderDate,
    List<String> productName,
    int status, {
    VoidCallback? onTap,
    double titleFontSize = 12.0,
    double fontSize = 14.0,
    double gapContents = 5.0,
    double gapTitle = 3.0,
  }) {
    final VoidCallback _onTap =
        onTap ?? () => Navigator.pushNamed(context, '/reportDetail');
    return GestureDetector(
      onTap: _onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(
            color: Colors.grey.withValues(alpha: 0.2),
            width: 1,
          ),
          borderRadius: BorderRadius.circular(10),
          boxShadow: const [
            BoxShadow(color: Colors.grey, blurRadius: 4, offset: Offset(4, 4)),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: const Color(0xFF032B91),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  ' ID: $id',
                  overflow: TextOverflow.ellipsis,
                  style: fontStyleBaloo(titleFontSize + 3, color: Colors.white),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(height: gapContents),
              Text('Khách hàng:', style: fontStyleInter(fontSize)),

              Text(
                customerName,
                style: fontStyleInter(fontSize, isBold: true),
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: gapContents),
              Text('Ngày đặt:', style: fontStyleInter(fontSize)),

              Text(orderDate, style: fontStyleInter(fontSize, isBold: true)),
              SizedBox(height: gapContents),
              Text('Các sản phẩm:', style: fontStyleInter(fontSize)),
              productListPreview(productName, fontSize),
              SizedBox(height: gapContents),
              Spacer(),
              Center(child: statusTag(status, fontSize)),
            ],
          ),
        ),
      ),
    );
  }

  Widget productListPreview(List<String> productName, double fontSize) {
    String fullText;
    if (productName.length <= 3) {
      fullText = productName.join('\n');
    } else {
      fullText = '${productName[0]}\n${productName[1]}\n${productName[2]}...';
    }
    return Text(
      fullText,
      style: fontStyleInter(fontSize, isBold: true),
      maxLines: 3,
      overflow: TextOverflow.ellipsis,
    );
  }

  Container statusTag(int status, double fontSize) {
    final tagInfo = statusTagText(status);
    return Container(
      width: 110,
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
    final bool isStaff = Global.currentUser?.role != 0;

    switch (status) {
      case 0:
        return ('Chờ xử lý', const Color(0xFF8C8C8C));
      case 1:
        return ('Đã xác nhận', const Color(0xFF00BBFF));
      case 2:
        return _statusByRole(
          isStaff: isStaff,
          staffStatus: ('Đang sản xuất', const Color(0xFF14AE5C)),
        );
      case 3:
        return _statusByRole(
          isStaff: isStaff,
          staffStatus: ('Tạm dừng', const Color(0xFF8C1D18)),
        );
      case 4:
        return _statusByRole(
          isStaff: isStaff,
          staffStatus: ('Giữ', const Color(0xFF8C1D18)),
        );
      case 5:
        return _statusByRole(
          isStaff: isStaff,
          staffStatus: ('Dừng', const Color(0xFFFFD15B)),
        );
      case 7:
        return _statusByRole(
          isStaff: isStaff,
          staffStatus: ('Dừng khẩn cấp', const Color(0xFF000000)),
        );
      case 6:
        return ('Hoàn thành', const Color(0xFF1F7300));
      case 8:
        return ('Hủy', const Color(0xFFFF0000));
      default:
        return ('Không xác định', const Color(0xFF000000));
    }
  }

  (String, Color) _statusByRole({
    required bool isStaff,
    required (String, Color) staffStatus,
  }) {
    final customerStatus = ('Đang sản xuất', const Color(0xFFFF9600));
    return isStaff ? staffStatus : customerStatus;
  }
}
