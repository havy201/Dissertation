import 'package:app_for_scada/mixin/mixinFunctions.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../widgets/titleAppBar.dart';
import '../global.dart';
import '../mixin/mixinDecorations.dart';
import '../mixin/mixinWidgetWithFunction.dart';
import 'package:app_for_scada/api/LoginAPIServer.dart';
import 'package:app_for_scada/model/Login/Account.dart';

class RegisterScreen extends StatefulWidget with mixinNotification {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen>
    with
        fontStyleMixin,
        InputFieldDecorationMixin,
        itemDecorationMixin,
        particularFunctionMixin {
  static const double _fontSize = 20;
  static final Color _primaryBlue = Global.primaryBlue;
  static const Color _buttonColor = Color(0xff00F3FF);

  final _formKey = GlobalKey<FormState>();
  final _fullnameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _pinController = TextEditingController();

  bool _obscurePassword = true;
  bool _isShowPINField = false;
  bool _isLoading = false;
  int? _selectedRole; // ✅ Lưu role đã chọn
  @override
  void dispose() {
    _fullnameController.dispose();
    _phoneController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    _pinController.dispose();
    super.dispose();
  }

  Future<void> _handleRegister() async {
    if (!_formKey.currentState!.validate()) return;
    _formKey.currentState!.save();
    setState(() => _isLoading = true);
    final overlay = Overlay.of(context, rootOverlay: true);
    final blocker = OverlayEntry(
      builder: (_) =>
          const ModalBarrier(dismissible: false, color: Colors.transparent),
    );
    overlay.insert(blocker);

    try {
      final messageWidget = widget.notifyUser(
        context,
        'Đang đăng ký...',
        fontStyleBaloo(_fontSize, color: Colors.white),
        _primaryBlue,
      );
      await messageWidget.closed;
      if (!mounted) return;
      final user = Account(
        userName: _usernameController.text.trim(),
        password: _passwordController.text,
        fullName: _fullnameController.text.trim(),
        phoneNumber: _phoneController.text.trim(),
        role: _selectedRole!,
        staffCode: _isShowPINField
            ? int.tryParse(_pinController.text.trim())
            : 0,
      );
      bool isCreated = await LoginAPIServer.instance.createAccount(user);
      if (!mounted) return;

      ScaffoldMessenger.of(context).removeCurrentSnackBar();
      if (isCreated) {
        final messageWidget = widget.notifyUser(
          context,
          'Đăng ký thành công!',
          fontStyleBaloo(_fontSize, color: Colors.white),
          Colors.green[900]!,
        );
        await messageWidget.closed;
        Navigator.pop(context);
      } else {
        throw Exception('Đăng ký thất bại');
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).removeCurrentSnackBar();
      final messageWidget = widget.notifyUser(
        context,
        'Đăng ký thất bại!',
        fontStyleBaloo(_fontSize, color: Colors.white),
        Colors.red[900]!,
      );
      await messageWidget.closed;
      if (!mounted) return;
      print('Lỗi gì đây: $e');
    } finally {
      blocker.remove();
      if (mounted) {
        _formKey.currentState?.reset();
        _fullnameController.clear();
        _phoneController.clear();
        _usernameController.clear();
        _passwordController.clear();
        _pinController.clear();
        setState(() {
          _isLoading = false;
          _isShowPINField = false;
          _selectedRole = null;
        });
      }
    }
  }

  InputDecoration _fieldDecoration({
    required String icon,
    required String label,
    required String hint,
  }) {
    return InputDecoration(
      prefixIcon: prefixIconPadding(icon),
      labelText: label,
      labelStyle: fontStyleInter(_fontSize, color: _primaryBlue),
      contentPadding: contentPadding(),
      hintText: hint,
      hintStyle: fontStyleInter(_fontSize, color: _primaryBlue),
      border: outlineInputBorder(),
      enabledBorder: outlineInputBorder(),
      focusedBorder: outlineInputBorder(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final spacing = Global.spacing;
    return Scaffold(
      appBar: TitleAppBar(title: 'Đăng ký tài khoản'),
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.all(spacing),
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      TextFormField(
                        controller: _fullnameController,
                        enabled: !_isLoading,
                        decoration: _fieldDecoration(
                          icon: 'lib/icons/fullname.png',
                          label: 'Họ và tên...',
                          hint: 'Ví dụ: Nguyễn Văn A',
                        ),
                        validator: mesIFieldValidator(
                          'Vui lòng nhập họ và tên',
                        ),
                      ),
                      SizedBox(height: spacing),
                      TextFormField(
                        controller: _phoneController,
                        enabled: !_isLoading,
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                        decoration: _fieldDecoration(
                          icon: 'lib/icons/phonenumber.png',
                          label: 'Số điện thoại...',
                          hint: 'Ví dụ: 0123456789',
                        ),
                        validator: mesNumberValidator(
                          'Vui lòng nhập số điện thoại',
                        ),
                      ),
                      SizedBox(height: spacing),
                      TextFormField(
                        controller: _usernameController,
                        enabled: !_isLoading,
                        maxLength: 20,
                        decoration: _fieldDecoration(
                          icon: 'lib/icons/loginUser.png',
                          label: 'Tên người dùng...',
                          hint: 'Ví dụ: nguyenvana',
                        ).copyWith(counterText: ''),
                        validator: mesIFieldValidator(
                          'Vui lòng nhập tên người dùng',
                        ),
                      ),
                      SizedBox(height: spacing),
                      TextFormField(
                        controller: _passwordController,
                        enabled: !_isLoading,
                        obscureText: _obscurePassword,
                        maxLength: 20,
                        decoration:
                            _fieldDecoration(
                              icon: 'lib/icons/loginPassword.png',
                              label: 'Mật khẩu...',
                              hint: 'Ví dụ: @123nguyenvana',
                            ).copyWith(
                              counterText: '',
                              suffixIcon: suffixIconPadding(
                                _obscurePassword,
                                () {
                                  setState(
                                    () => _obscurePassword = !_obscurePassword,
                                  );
                                },
                              ),
                            ),
                        validator: mesIFieldValidator('Vui lòng nhập mật khẩu'),
                      ),
                      SizedBox(height: spacing),
                      Theme(
                        data: Theme.of(
                          context,
                        ).copyWith(hintColor: _primaryBlue),
                        child: DropdownButtonFormField<int>(
                          icon: Icon(
                            Icons.arrow_drop_down,
                            color: _primaryBlue,
                          ),
                          iconSize: 35,
                          isExpanded: true,
                          style: fontStyleInter(_fontSize, color: _primaryBlue),
                          borderRadius: BorderRadius.circular(10),
                          dropdownColor: Colors.white,
                          elevation: 4,
                          decoration: _fieldDecoration(
                            icon: 'lib/icons/role.png',
                            label: 'Chọn vai trò...',
                            hint: 'Chọn vai trò...',
                          ),
                          items: const [
                            DropdownMenuItem(
                              value: 0,
                              child: Text('Khách hàng'),
                            ),
                            DropdownMenuItem(
                              value: 1,
                              child: Text('Nhân viên'),
                            ),
                            DropdownMenuItem(value: 2, child: Text('Quản lý')),
                          ],
                          onChanged: _isLoading
                              ? null
                              : (value) {
                                  setState(() {
                                    _selectedRole = value;
                                    _isShowPINField = value == 1 || value == 2;
                                  });
                                },
                          validator: mesDropdownValidation<int>(
                            'Vui lòng chọn loại tài khoản',
                          ),
                        ),
                      ),
                      if (_isShowPINField) ...[
                        SizedBox(height: spacing),
                        TextFormField(
                          controller: _pinController,
                          enabled: !_isLoading,
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                          decoration: _fieldDecoration(
                            icon: 'lib/icons/pin.png',
                            label: 'Mã PIN...',
                            hint: 'Ví dụ: 123456',
                          ),
                          validator: mesNumberValidator('Vui lòng nhập mã PIN'),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ),
            Center(
              child: filledBtn(
                _isLoading ? null : _handleRegister,
                'Đăng ký', // ✅ Sửa label
                color: _buttonColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
