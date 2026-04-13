import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:app_for_scada/mixin/mixinDecorations.dart';
import 'package:app_for_scada/mixin/mixinFunctions.dart';

final double space = 35;
final double padding = 43;
final double iconSize = 35;
final double fontSizeLogin = 20;
final Duration loginSnackBarDuration = Duration(seconds: 6); //text

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with InputFieldDecorationMixin, fontStyleMixin, functionMixin {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  // Thêm GlobalKey để quản lý trạng thái của Form, phan biet cac form voi nhau
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(padding),
        child: Form(
          key: _formKey, //
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Align(
                alignment: Alignment.centerRight,
                child: Image.asset(
                  'assets/bk.png',
                  width: 58.01,
                  height: 58.37,
                ),
              ),
              SizedBox(height: space / 2),
              Center(
                child: Image.asset('assets/logo.png', width: 165, height: 165),
              ),
              SizedBox(height: space),
              Text('BatchFeed', style: fontStyleBaloo(32)),
              Text('Theo dõi từng mẻ', style: fontStyleBaloo(24)),
              SizedBox(height: space),
              TextFormField(
                controller: _usernameController,
                maxLength: 20,
                decoration: InputDecoration(
                  prefixIcon: prefixIconPadding('lib/icons/loginUser.png'),
                  labelText: 'Tên đăng nhập...',
                  labelStyle: fontStyleInter(
                    fontSizeLogin,
                    isItalic: true,
                    color: Color(0xFF032B91),
                  ),
                  contentPadding: contentPadding(),
                  hintText: 'Ví dụ: nguyenvana123',
                  hintStyle: fontStyleInter(
                    fontSizeLogin,
                    color: Color(0xFF032B91),
                  ),
                  border: outlineInputBorder(),
                  enabledBorder: outlineInputBorder(),
                  focusedBorder: outlineInputBorder(),
                ),
                onSaved: (newValue) => print(
                  'Tên đăng nhập: $newValue',
                ), // Lưu giá trị khi form được lưu
                validator: requiredFieldValidator(
                  'Vui lòng nhập tên đăng nhập',
                ),
              ),
              SizedBox(height: space),
              TextFormField(
                controller: _passwordController,
                obscureText: _obscurePassword,
                maxLength: 20,
                decoration: InputDecoration(
                  prefixIcon: prefixIconPadding('lib/icons/loginPassword.png'),
                  suffixIcon: suffixIconPadding(_obscurePassword, () {
                    setState(() {
                      _obscurePassword = !_obscurePassword;
                    });
                  }),
                  labelText: 'Mật khẩu...',
                  labelStyle: fontStyleInter(
                    fontSizeLogin,
                    isItalic: true,
                    color: Color(0xFF032B91),
                  ),
                  contentPadding: contentPadding(),
                  hintText: 'Ví dụ: @123nguyenvana',
                  hintStyle: fontStyleInter(
                    fontSizeLogin,
                    color: Color(0xFF032B91),
                  ),
                  border: outlineInputBorder(),
                  enabledBorder: outlineInputBorder(),
                  focusedBorder: outlineInputBorder(),
                ),

                onSaved: (newValue) => print(
                  'Mật khẩu: $newValue',
                ), // Lưu giá trị khi form được lưu
                validator: requiredFieldValidator('Vui lòng nhập mật khẩu'),
              ),
              Spacer(),
              FilledButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        duration: loginSnackBarDuration,
                        content: AnimatedTextKit(
                          animatedTexts: [
                            TypewriterAnimatedText(
                              'Đang đăng nhập...',
                              textStyle: fontStyleBaloo(
                                16,
                                color: Colors.white,
                              ),
                              speed: Duration(milliseconds: 100),
                            ),
                          ],
                          totalRepeatCount: 1,
                        ),
                        behavior: SnackBarBehavior.floating,
                        backgroundColor: Colors.green[900],
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    );
                    _formKey.currentState!.reset();
                    _usernameController.clear();
                    _passwordController.clear();
                    setState(() {});
                  }
                },
                style: FilledButton.styleFrom(
                  backgroundColor: const Color(0xff00F3FF),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text(
                  'Đăng nhập',
                  style: fontStyleBaloo(16, color: Colors.white),
                ),
              ),
              TextButton(
                onPressed: () {},
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
