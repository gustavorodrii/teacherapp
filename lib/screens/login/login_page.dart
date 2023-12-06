// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:teacherapp/controller/user_controller.dart';

import '../widget/textfield_custom.dart';

class LoginPage extends StatefulWidget {
  final Function()? onTap;

  const LoginPage({
    Key? key,
    this.onTap,
  }) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

final UserController userController = Get.put<UserController>(UserController());

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Login',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 35,
          vertical: 10,
        ),
        child: Column(
          children: [
            TextFieldCustom(
              controller: userController.emailControllerLogin,
              // onChanged: userController.setEmailLogin,
              keyboardType: TextInputType.emailAddress,
              hintText: 'E-mail',
              labelText: 'E-mail',
              prefixIcon: Icon(
                Icons.person,
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            TextFieldCustom(
              controller: userController.passwordControllerLogin,
              // onChanged: userController.setPassLogin,
              hintText: 'Senha',
              labelText: 'Senha',
              prefixIcon: Icon(
                Icons.password,
              ),
              obscureText: true,
            ),
            TextButton(
              onPressed: widget.onTap,
              child: Text('Register'),
            ),
            ElevatedButton(
              onPressed: () {
                userController.signInFireBase(
                  email: userController.emailControllerLogin.text.trim(),
                  pass: userController.passwordControllerLogin.text.trim(),
                );
              },
              child: Text('Entrar'),
            ),
          ],
        ),
      ),
    );
  }
}
