import 'package:app_for_scada/api/LoginAPIServer.dart';
import 'package:app_for_scada/model/Login/Account.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../widgets/titleAppBar.dart';
import '../global.dart';
import '../mixin/mixinDecorations.dart';
import '../mixin/mixinFunctions.dart';
import '../mixin/mixinWidgetWithFunction.dart';

// ✅ Model config cho từng loại update
class _UpdateConfig {
  final String title;
  final String icon;
  final int maxLength;
  final String oldLabel;
  final String oldHint;
  final String oldJsonField;
  final String newLabel;
  final String newHint;
  final String newJsonField;
  final int type; // 0: fullName, 1: phoneNumber, 2: password
  final TextInputType keyboardType;
  final List<TextInputFormatter> inputFormatters;

  const _UpdateConfig({
    required this.title,
    required this.icon,
    required this.maxLength,
    required this.oldLabel,
    required this.oldHint,
    required this.oldJsonField,
    required this.newLabel,
    required this.newHint,
    required this.newJsonField,
    required this.type,
    this.keyboardType = TextInputType.text,
    this.inputFormatters = const [],
  });
}

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
  static const Color _buttonColor = Color(0xff00F3FF);

  // ✅ Tất cả config tập trung 1 chỗ — dễ thêm/sửa sau này
  static Map<int, _UpdateConfig> _configs = {
    0: _UpdateConfig(
      title: 'họ và tên',
      icon: 'lib/icons/loginUser.png',
      maxLength: 50,
      oldLabel: '',
      oldHint: '',
      oldJsonField: '',
      newLabel: 'Họ và tên mới',
      newHint: 'Ví dụ: Nguyen Van B',
      newJsonField: 'fullName',
      type: 0,
    ),
    1: _UpdateConfig(
      title: 'số điện thoại',
      icon: 'lib/icons/phonenumber.png',
      maxLength: 10,
      oldLabel: '',
      oldHint: '',
      oldJsonField: '',
      newLabel: 'Số điện thoại mới',
      newHint: 'Ví dụ: 0123456789',
      newJsonField: 'phoneNumber',
      keyboardType: TextInputType.number,
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      type: 1,
    ),
    2: _UpdateConfig(
      title: 'mật khẩu',
      icon: 'lib/icons/loginPassword.png',
      maxLength: 20,
      oldLabel: 'oldPassword',
      oldHint: 'Ví dụ: nguyen@123',
      oldJsonField: 'oldPassword',
      newLabel: 'Mật khẩu mới',
      newHint: 'Ví dụ: nguyen@456',
      newJsonField: 'newPassword',
      type: 2,
    ),
  };

  final _formKey = GlobalKey<FormState>();
  final _oldController = TextEditingController();
  final _newController = TextEditingController();

  bool _oldObscured = true;
  bool _newObscured = true;
  bool _isLoading = false;

  String get _avatarPath => switch (Global.currentUser?.role) {
    0 => 'lib/icons/ava_customer.png',
    1 => 'lib/icons/ava_staff.png',
    2 => 'lib/icons/ava_manager.png',
    _ => 'lib/icons/null.png',
  };

  @override
  void dispose() {
    _oldController.dispose();
    _newController.dispose();
    super.dispose();
  }

  void _checkValidator(_UpdateConfig config) {
    if (!_formKey.currentState!.validate()) return;
    _formKey.currentState!.save();
    _showDialog(config);
  }

  void _showDialog(_UpdateConfig config) {
    showDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: Text(
          'Cập nhật ${config.title}?',
          style: fontStyleBaloo(_fontSize),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _handleUpdate(config);
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

  Future<void> _handleUpdate(_UpdateConfig config) async {
    setState(() => _isLoading = true);
    final primaryBlue = Global.primaryBlue;
    final overlay = Overlay.of(context, rootOverlay: true);
    final blocker = OverlayEntry(
      builder: (_) =>
          const ModalBarrier(dismissible: false, color: Colors.transparent),
    );
    overlay.insert(blocker);

    try {
      final messageWidget = widget.notifyUser(
        context,
        'Đang cập nhật ${config.title}...',
        fontStyleBaloo(_fontSize, color: Colors.white),
        primaryBlue,
      );
      await messageWidget.closed;
      if (!mounted) return;
      final info = Account(
        userName: Global.currentUser!.userName,
        fullName: config.type == 0 ? _newController.text.trim() : null,
        phoneNumber: config.type == 1 ? _newController.text.trim() : null,
        oldPassword: config.type == 2 ? _oldController.text : null,
        newPassword: config.type == 2 ? _newController.text : null,
      );
      bool isUpdated = await LoginAPIServer.instance.updateUser(info);
      if (!mounted) return;

      ScaffoldMessenger.of(context).removeCurrentSnackBar();
      if (isUpdated) {
        final success = widget.notifyUser(
          context,
          'Cập nhật ${config.title} thành công!',
          fontStyleBaloo(_fontSize, color: Colors.white),
          Colors.green,
        );
        if (config.type == 0) {
          Global.currentUser!.fullName = _newController.text.trim();
        }
        // Nếu là Cập nhật Số điện thoại (type == 1)
        else if (config.type == 1) {
          Global.currentUser!.phoneNumber = _newController.text.trim();
        }
        await success.closed;
        if (!mounted) return;
        Navigator.pop(context, true); // Trả về true để trigger set
      } else {
        throw Exception('Cập nhật thất bại');
      }
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
        _oldController.clear();
        _newController.clear();
        setState(() => _isLoading = false);
      }
    }
  }

  Widget _valueField({
    required TextEditingController controller,
    bool isObscured = false,
    VoidCallback? onToggle,
    required int maxLength,
    required String path,
    required String label,
    required String hint,
    required String validationMessage,
    TextInputType keyboardType = TextInputType.number,
    List<TextInputFormatter> inputFormatters = const [],
  }) {
    final primaryBlue = Global.primaryBlue;
    return TextFormField(
      controller: controller,
      enabled: !_isLoading,
      obscureText: isObscured,
      maxLength: maxLength,
      keyboardType: keyboardType,
      inputFormatters: inputFormatters,
      decoration: InputDecoration(
        counterText: '',
        prefixIcon: prefixIconPadding(path),
        suffixIcon: onToggle != null
            ? suffixIconPadding(isObscured, onToggle)
            : null,
        labelText: label,
        labelStyle: fontStyleInter(_fontSize, color: primaryBlue),
        contentPadding: contentPadding(),
        hintText: hint,
        hintStyle: fontStyleInter(
          _fontSize,
          isItalic: true,
          color: primaryBlue,
        ),
        border: outlineInputBorder(),
        enabledBorder: outlineInputBorder(),
        focusedBorder: outlineInputBorder(),
      ),
      validator: mesIFieldValidator(validationMessage),
    );
  }

  @override
  Widget build(BuildContext context) {
    final type = ModalRoute.of(context)!.settings.arguments as int;
    final config = _configs[type] ?? _configs[0]!; // ✅ fallback an toàn
    final spacing = Global.spacing;
    const framePadding = (_frameSize - _imageSize) / 2;

    return Scaffold(
      appBar: TitleAppBar(title: 'Cập nhật ${config.title}'),
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.all(spacing),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // ── Avatar ────────────────────────────
              Center(
                child: Container(
                  padding: const EdgeInsets.all(framePadding),
                  width: _frameSize,
                  height: _frameSize,
                  decoration: containerDecoration(color: Global.primaryBlue),
                  child: Image.asset(
                    _avatarPath,
                    width: _imageSize,
                    height: _imageSize,
                  ),
                ),
              ),
              SizedBox(height: spacing),

              if (config.type != 2) ...[
                // ✅ Case không phải password — chỉ 1 field
                _valueField(
                  controller: _newController,
                  maxLength: config.maxLength,
                  path: config.icon,
                  label: config.newLabel,
                  hint: config.newHint,
                  validationMessage: 'Vui lòng nhập ${config.title}',
                  keyboardType: config.keyboardType,
                  inputFormatters: config.inputFormatters,
                ),
              ] else ...[
                // ✅ Case password — 2 field + obscure
                _valueField(
                  controller: _oldController,
                  maxLength: config.maxLength,
                  isObscured: _oldObscured,
                  onToggle: () => setState(() => _oldObscured = !_oldObscured),
                  path: config.icon,
                  label: config.oldLabel,
                  hint: config.oldHint,
                  validationMessage:
                      'Vui lòng nhập ${config.oldLabel.toLowerCase()}',
                ),
                SizedBox(height: spacing),
                _valueField(
                  controller: _newController,
                  maxLength: config.maxLength,
                  isObscured: _newObscured,
                  onToggle: () => setState(() => _newObscured = !_newObscured),
                  path: config.icon,
                  label: config.newLabel,
                  hint: config.newHint,
                  validationMessage:
                      'Vui lòng nhập ${config.newLabel.toLowerCase()}',
                ),
              ],

              const Spacer(),
              filledBtn(
                _isLoading ? null : () => _checkValidator(config),
                'Cập nhật ${config.title}',
                color: _buttonColor,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
