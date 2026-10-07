import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../auth/auth_provider.dart';
import '../../style/colors.dart';
import '../../style/fonts.dart';
import './widgets/PasswordField.dart';
import './widgets/LoginField.dart';
import './change_password_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final loginController = TextEditingController();
  final passwordController = TextEditingController();

  bool loading = false;

  @override
    void dispose() {
      loginController.dispose();
      passwordController.dispose();
      super.dispose();
    }
  
  Future<void> _onLoginPressed() async {
    final login = loginController.text.trim();
    final password = passwordController.text;

    if (login.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Fields cannot be empty')),
      );
      return;
    }

    setState(() => loading = true);

    try {
      final auth = Provider.of<AuthProvider>(context, listen: false);
      await auth.login(login, password);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Login failed')),
      );
    } finally {
      setState(() => loading = false);
    }
  }
   
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: RTColorStyle.dark1000.value,
      body: SafeArea(
	child: SizedBox(
	  width: double.infinity,
	  child: Column(
	    mainAxisAlignment: MainAxisAlignment.center,
	    crossAxisAlignment: CrossAxisAlignment.center,
	    children: [
	      const Spacer(flex: 2),
	      Text(
	      "Добро пожаловать в\n в РТ-Техприемку",
	      style: RTFontStyle.h2.value,
	      textAlign: TextAlign.center,
	      ),
	      Container(
		padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 35.0),
		child: Column(
		  crossAxisAlignment: CrossAxisAlignment.start,
		  children: [
		    Container(
		      padding: EdgeInsets.only(left: 10, bottom: 5),
		      child: Text('Логин', style: RTFontStyle.loginLabels.value),
		      ),
		    LoginField(controller: loginController),
		    const SizedBox(height: 12),
		    Container(
		      padding: EdgeInsets.only(left: 10, bottom: 5),
		      child: Text('Пароль',style: RTFontStyle.loginLabels.value),
		    ),
		    PasswordField(controller: passwordController),
		    const SizedBox(height: 16),
		    SizedBox(
		      width: double.infinity,
		      child: ElevatedButton(
		        onPressed: _onLoginPressed,
		        style: ElevatedButton.styleFrom(
		          backgroundColor: RTColorStyle.dark800.value,
		          foregroundColor: RTColorStyle.light700.value,
		          padding: EdgeInsets.symmetric(horizontal: 24, vertical: 10),
		          shape: RoundedRectangleBorder(
		            borderRadius: BorderRadius.circular(8),
		          ),
		        ),
		        child: Text('Войти', style: TextStyle(fontSize: 18)),
		      ),
		    ),
        const SizedBox(height: 12),
       
        SizedBox(
          width: double.infinity,
          child: TextButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => const ChangePasswordPage(),
                ),
              );
            },
            style: TextButton.styleFrom(
              alignment: Alignment.topRight,
              padding: EdgeInsets.zero,
              minimumSize: Size.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            child: Text(
              'Изменить пароль',
              style: RTFontStyle.loginLabels.value.copyWith(
                fontSize: 15,
              ),
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
      )
    );
  }
}
