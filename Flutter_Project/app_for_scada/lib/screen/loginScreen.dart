import 'package:flutter/material.dart';
import 'package:app_for_scada/mixin/mixinDecorations.dart';
import 'package:app_for_scada/mixin/mixinFunctions.dart';
import 'package:app_for_scada/mixin/mixinWidgetWithFunction.dart';
import '../global.dart';

class LoginScreen extends StatefulWidget with mixinNotification {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with
        InputFieldDecorationMixin,
        fontStyleMixin,
        particularFunctionMixin,
        itemDecorationMixin {
  static const double _space = 35;
  static const double _padding = 43;
  static const double _fontSizeLogin = 20;
  static final Color _primaryBlue = Global.primaryBlue;

  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool _isLoading = false;

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
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
        'Đang đăng nhập...',
        fontStyleBaloo(_fontSizeLogin, color: Colors.white),
        _primaryBlue,
      );
      await messageWidget.closed;
      if (!mounted) return;
      // int i = int.parse('abc'); // Lỗi giả lập để test snackbar thất bại
      // TODO: Gọi API thực
      // final account = await ApiService.login(
      //   _usernameController.text,
      //   _passwordController.text,
      // );
      // Navigator.pushReplacementNamed(context, '/homeScreen');
      if (Global.isLoggedIn) {
        final messageWidget = widget.notifyUser(
          context,
          'Đăng nhập thành công!',
          fontStyleBaloo(_fontSizeLogin, color: Colors.white),
          Colors.green[900]!,
        );
        await messageWidget.closed;
        if (!mounted) return;
        Navigator.pushReplacementNamed(context, '/mainShell');
      } else {
        throw Exception('Đăng nhập thất bại');
      }
    } catch (e) {
      if (!mounted) return;
      widget.notifyUser(
        context,
        'Đăng nhập thất bại!',
        fontStyleBaloo(_fontSizeLogin, color: Colors.white),
        Colors.red[900]!,
      );
    } finally {
      blocker.remove();
      if (mounted) {
        _formKey.currentState?.reset();
        _usernameController.clear();
        _passwordController.clear();
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(_padding),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Align(
                alignment: Alignment.centerRight,
                child: Image.asset(
                  'assets/bk.png',
                  width: 58.01,
                  height: 58.37,
                ),
              ),
              const SizedBox(height: _space / 2),
              Image.asset('assets/logo.png', width: 165, height: 165),
              const SizedBox(height: _space),
              Text('BatchFeed', style: fontStyleBaloo(32)),
              Text('Theo dõi từng mẻ', style: fontStyleBaloo(24)),
              const SizedBox(height: _space),

              TextFormField(
                controller: _usernameController,
                enabled: !_isLoading,
                maxLength: 20,
                decoration: InputDecoration(
                  counterText: '',
                  prefixIcon: prefixIconPadding('lib/icons/loginUser.png'),
                  labelText: 'Tên đăng nhập...',
                  labelStyle: fontStyleInter(
                    _fontSizeLogin,
                    color: const Color(0xFF032B91),
                  ),
                  contentPadding: contentPadding(),
                  hintText: 'Ví dụ: nguyenvana123',
                  hintStyle: fontStyleInter(
                    _fontSizeLogin,
                    color: const Color(0xFF032B91),
                  ),
                  border: outlineInputBorder(),
                  enabledBorder: outlineInputBorder(),
                  focusedBorder: outlineInputBorder(),
                ),
                validator: mesIFieldValidator('Vui lòng nhập tên đăng nhập'),
              ),
              const SizedBox(height: _space),

              // ── Password ──────────────────────────────
              TextFormField(
                controller: _passwordController,
                obscureText: _obscurePassword,
                enabled: !_isLoading,
                maxLength: 20,
                decoration: InputDecoration(
                  counterText: '',
                  prefixIcon: prefixIconPadding('lib/icons/loginPassword.png'),
                  suffixIcon: suffixIconPadding(_obscurePassword, () {
                    setState(() => _obscurePassword = !_obscurePassword);
                  }),
                  labelText: 'Mật khẩu...',
                  labelStyle: fontStyleInter(
                    _fontSizeLogin,
                    color: const Color(0xFF032B91),
                  ),
                  contentPadding: contentPadding(),
                  hintText: 'Ví dụ: @123nguyenvana',
                  hintStyle: fontStyleInter(
                    _fontSizeLogin,
                    color: const Color(0xFF032B91),
                  ),
                  border: outlineInputBorder(),
                  enabledBorder: outlineInputBorder(),
                  focusedBorder: outlineInputBorder(),
                ),
                validator: mesIFieldValidator('Vui lòng nhập mật khẩu'),
              ),
              const Spacer(),
              filledBtn(
                _isLoading ? null : _handleLogin,
                'Đăng nhập',
                color: const Color(0xff00F3FF),
              ),
              TextButton(
                onPressed: _isLoading
                    ? null
                    : () => Navigator.pushNamed(context, '/registerScreen'),
                child: Text(
                  'Chưa có tài khoản? Đăng ký ngay!',
                  style: fontStyleBaloo(16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
