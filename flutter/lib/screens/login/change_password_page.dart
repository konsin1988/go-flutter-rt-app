import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../auth/auth_provider.dart';
import '../../style/colors.dart';
import '../../style/fonts.dart';
import './widgets/PasswordField.dart';
import './widgets/LoginField.dart';

class ChangePasswordPage extends StatefulWidget {
  const ChangePasswordPage({super.key});

  @override
  State<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  final loginController = TextEditingController();
  final currentPasswordController = TextEditingController();
  final newPasswordController = TextEditingController();

  bool loading = false;

  @override
  void dispose() {
    loginController.dispose();
    currentPasswordController.dispose();
    newPasswordController.dispose();
    super.dispose();
  }

  Future<void> _onChangePasswordPressed() async {
    final login = loginController.text.trim();
    final currentPassword = currentPasswordController.text;
    final newPassword = newPasswordController.text;

    if (login.isEmpty ||
        currentPassword.isEmpty ||
        newPassword.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Заполните все поля'),
        ),
      );
      return;
    }

    if (newPassword == currentPassword) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Новый пароль должен отличаться от текущего'),
        ),
      );
      return;
    }

    setState(() => loading = true);

    try {
      final auth = Provider.of<AuthProvider>(
        context,
        listen: false,
      );

      await auth.changePassword(
        login,
        currentPassword,
        newPassword,
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Пароль успешно изменён'),
        ),
      );

      Navigator.of(context).pop();
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Не удалось изменить пароль'),
        ),
      );
    } finally {
      if (mounted) {
        setState(() => loading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: RTColorStyle.dark1000.value,
      appBar: AppBar(
        backgroundColor: RTColorStyle.dark1000.value,
        foregroundColor: RTColorStyle.light700.value,
        elevation: 0,
      ),
      body: SafeArea(
        child: SizedBox(
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Spacer(flex: 2),

              Text(
                'Смена пароля',
                style: RTFontStyle.h2.value,
                textAlign: TextAlign.center,
              ),

              Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 16,
                  horizontal: 35,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                        left: 10,
                        bottom: 5,
                      ),
                      child: Text(
                        'Логин',
                        style: RTFontStyle.loginLabels.value,
                      ),
                    ),

                    LoginField(
                      controller: loginController,
                    ),

                    const SizedBox(height: 12),

                    Padding(
                      padding: const EdgeInsets.only(
                        left: 10,
                        bottom: 5,
                      ),
                      child: Text(
                        'Текущий пароль',
                        style: RTFontStyle.loginLabels.value,
                      ),
                    ),

                    PasswordField(
                      controller: currentPasswordController,
                    ),

                    const SizedBox(height: 12),

                    Padding(
                      padding: const EdgeInsets.only(
                        left: 10,
                        bottom: 5,
                      ),
                      child: Text(
                        'Новый пароль',
                        style: RTFontStyle.loginLabels.value,
                      ),
                    ),

                    PasswordField(
                      controller: newPasswordController,
                    ),

                    const SizedBox(height: 16),

                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: loading
                            ? null
                            : _onChangePasswordPressed,
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              RTColorStyle.dark800.value,
                          foregroundColor:
                              RTColorStyle.light700.value,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 10,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: loading
                            ? const SizedBox(
                                width: 22,
                                height: 22,
                                child: CircularProgressIndicator(),
                              )
                            : const Text(
                                'Изменить пароль',
                                style: TextStyle(fontSize: 18),
                              ),
                      ),
                    ),
                  ],
                ),
              ),

              const Spacer(flex: 4),
            ],
          ),
        ),
      ),
    );
  }
}
