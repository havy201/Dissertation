import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../widgets/titleAppBar.dart';
import '../global.dart';
import '../mixin/mixinDecorations.dart';
import '../mixin/mixinFunctions.dart';
import '../mixin/mixinWidgetWithFunction.dart';

class UpdateInfoUser extends StatefulWidget with mixinNotification {
  const UpdateInfoUser({super.key});

  @override
  State<UpdateInfoUser> createState() => _UpdateInfoUserState();
}

class _UpdateInfoUserState extends State<UpdateInfoUser>
    with
        itemDecorationMixin,
        fontStyleMixin,
        InputFieldDecorationMixin,
        particularFunctionMixin {
  static const double _frameSize = 120.0;
  static const double _imageSize = 100.0;
  static const double _fontSize = 20.0;
  static final Color _primaryBlue = Global.primaryBlue;
  static const Color _buttonColor = Color(0xff00F3FF);

  final _formKey = GlobalKey<FormState>();
  final _oldValue = TextEditingController();
  final _newValue = TextEditingController();

  bool _oldPasswordObscured = true;
  bool _newPasswordObscured = true;
  bool _isLoading = false;

  String get _avatarPath => switch (Global.currentUser.role) {
    0 => 'lib/icons/ava_customer.png',
    1 => 'lib/icons/ava_staff.png',
    2 => 'lib/icons/ava_manager.png',
    _ => 'lib/icons/null.png',
  };

  @override
  void dispose() {
    _oldValue.dispose();
    _newValue.dispose();
    super.dispose();
  }

  void _checkValidator(String title) {
    if (!_formKey.currentState!.validate()) return;
    _formKey.currentState!.save();
    _showDialog(title);
  }

  void _showDialog(String title) {
    showDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: Text('Cập nhật ${title}?', style: fontStyleBaloo(_fontSize)),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _handleUpdate(title);
            },
            child: Text('Đồng ý', style: fontStyleBaloo(_fontSize)),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Hủy', style: fontStyleBaloo(_fontSize)),
          ),
        ],
      ),
    );
  }

  Future<void> _handleUpdate(String title) async {
    setState(() => _isLoading = true);

    final overlay = Overlay.of(context, rootOverlay: true);
    final blocker = OverlayEntry(
      builder: (_) =>
          const ModalBarrier(dismissible: false, color: Colors.transparent),
    );
    overlay.insert(blocker);

    try {
      final controller = widget.notifyUser(
        context,
        'Đang cập nhật ${title}...',
        fontStyleBaloo(_fontSize, color: Colors.white),
        _primaryBlue,
      );

      await controller.closed;
      if (!mounted) return;

      // TODO: Gọi API thực
      // await ApiService.updatePassword(
      //   oldPassword: _oldPasswordController.text,
      //   newPassword: _newPasswordController.text,
      // );
      if (Global.isLoggedIn) {
        final messageWidget = widget.notifyUser(
          context,
          'Cập nhật ${title} thành công!',
          fontStyleBaloo(_fontSize, color: Colors.white),
          Colors.green,
        );
        await messageWidget.closed;
        if (!mounted) return;
      } else {
        throw Exception('Cập nhật thất bại');
      }
      Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;
      widget.notifyUser(
        context,
        'Cập nhật thất bại!',
        fontStyleBaloo(_fontSize, color: Colors.white),
        Colors.red,
      );
    } finally {
      blocker.remove();
      if (mounted) {
        _formKey.currentState?.reset();
        _oldValue.clear();
        _newValue.clear();
        setState(() => _isLoading = false);
      }
    }
  }

  // ✅ Tách widget password — thêm enabled
  Widget _passwordField({
    required TextEditingController controller,
    required bool isObscured,
    required VoidCallback onToggle,
    required String label,
    required String hint,
    required String validationMessage,
    String? Function(String?)? extraValidator,
  }) {
    return TextFormField(
      controller: controller,
      enabled: !_isLoading,
      obscureText: isObscured,
      maxLength: 20,
      decoration: InputDecoration(
        counterText: '',
        prefixIcon: prefixIconPadding('lib/icons/loginPassword.png'),
        suffixIcon: suffixIconPadding(isObscured, onToggle),
        labelText: label,
        labelStyle: fontStyleInter(_fontSize, color: _primaryBlue),
        contentPadding: contentPadding(),
        hintText: hint,
        hintStyle: fontStyleInter(
          _fontSize,
          isItalic: true,
          color: _primaryBlue,
        ),
        border: outlineInputBorder(),
        enabledBorder: outlineInputBorder(),
        focusedBorder: outlineInputBorder(),
      ),
      validator: extraValidator ?? mesIFieldValidator(validationMessage),
    );
  }

  @override
  Widget build(BuildContext context) {
    final String title = ModalRoute.of(context)!.settings.arguments as String;
    final spacing = Global.spacing;
    const framePadding = (_frameSize - _imageSize) / 2;
    return Scaffold(
      appBar: TitleAppBar(title: 'Cập nhật ${title}'),
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.all(spacing),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Center(
                child: Container(
                  padding: const EdgeInsets.all(framePadding),
                  width: _frameSize,
                  height: _frameSize,
                  decoration: containerDecoration(color: _primaryBlue),
                  child: Image.asset(
                    _avatarPath,
                    width: _imageSize,
                    height: _imageSize,
                  ),
                ),
              ),
              SizedBox(height: spacing),
              _passwordField(
                controller: _oldValue,
                isObscured: _oldPasswordObscured,
                onToggle: () => setState(
                  () => _oldPasswordObscured = !_oldPasswordObscured,
                ),
                label: 'Mật khẩu cũ',
                hint: 'Ví dụ: nguyen@123',
                validationMessage: 'Vui lòng nhập mật khẩu cũ',
              ),
              SizedBox(height: spacing),
              _passwordField(
                controller: _newValue,
                isObscured: _newPasswordObscured,
                onToggle: () => setState(
                  () => _newPasswordObscured = !_newPasswordObscured,
                ),
                label: 'Mật khẩu mới',
                hint: 'Ví dụ: nguyen@456',
                validationMessage: 'Vui lòng nhập mật khẩu mới',
              ),
              SizedBox(height: spacing),
              const Spacer(),
              filledBtn(
                _isLoading ? null : () => _checkValidator(title),
                'Cập nhật ${title}',
                color: _buttonColor,
              ),
              SizedBox(height: spacing),
              filledBtn(
                _isLoading ? null : () => Navigator.pop(context),
                'Hủy',
                color: const Color(0xffB9B9B9),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
