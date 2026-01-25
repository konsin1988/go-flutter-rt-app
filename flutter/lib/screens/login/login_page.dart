import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../auth/auth_provider.dart';
import '../../style/colors.dart';
import '../../style/fonts.dart';
import './widgets/PasswordField.dart';
import './widgets/LoginField.dart';

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
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context, listen: false);

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(controller: loginController),
            TextField(
              controller: passwordController,
              obscureText: true,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: loading
                  ? null
                  : () async {
                      setState(() => loading = true);
                      try {
                        await auth.login(
                          loginController.text,
                          passwordController.text,
                        );
			
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Login failed')),
                        );
                      }
                      setState(() => loading = false);
                    },
              child: const Text('Login'),
            ),
          ],
        ),
      ),
    );
  }
}


//class LoginPage extends StatelessWidget {
//  const LoginPage({super.key});
//
//   
//  @override
//  Widget build(BuildContext context) {
//    return Scaffold(
//      backgroundColor: RTColorStyle.dark1000.value,
//      body: SafeArea(
//	child: SizedBox(
//	  width: double.infinity,
//	  child: Column(
//	    mainAxisAlignment: MainAxisAlignment.center,
//	    crossAxisAlignment: CrossAxisAlignment.center,
//	    children: [
//	      const Spacer(flex: 2),
//	      Text(
//	      "Добро пожаловать в\n в РТ-Техприемку",
//	      style: RTFontStyle.h2.value,
//	      textAlign: TextAlign.center,
//	      ),
//	      Container(
//		padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 35.0),
//		child: Column(
//		  crossAxisAlignment: CrossAxisAlignment.start,
//		  children: [
//		    Container(
//		      child: Text('Логин', style: RTFontStyle.loginLabels.value),
//		      padding: EdgeInsets.only(left: 10, bottom: 5),
//		      ),
//		    LoginField(),
//		    const SizedBox(height: 12),
//		    Container(
//		      child: Text('Пароль',style: RTFontStyle.loginLabels.value),
//		      padding: EdgeInsets.only(left: 10, bottom: 5),
//		    ),
//		    PasswordField(),
//		    const SizedBox(height: 16),
//		    SizedBox(
//		      width: double.infinity,
//		      child: ElevatedButton(
//		        onPressed: () {
//		          print('Button pressed');
//		        },
//		        style: ElevatedButton.styleFrom(
//		          backgroundColor: RTColorStyle.dark800.value,
//		          foregroundColor: RTColorStyle.light700.value,
//		          padding: EdgeInsets.symmetric(horizontal: 24, vertical: 10),
//		          shape: RoundedRectangleBorder(
//		            borderRadius: BorderRadius.circular(8),
//		          ),
//		        ),
//		        child: Text('Войти', style: TextStyle(fontSize: 18)),
//		      ),
//		    ),
//		  ],
//		),
//	      ),
//	      const Spacer(flex: 4),
//	    ],
//	  ), 
//	),
//      )
//    );
//  }
//}
