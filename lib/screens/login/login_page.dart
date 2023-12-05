// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

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

TextEditingController emailController = TextEditingController();
TextEditingController passwordController = TextEditingController();

void signInFireBase() async {
  await FirebaseAuth.instance.signInWithEmailAndPassword(
    email: emailController.text.trim(),
    password: passwordController.text.trim(),
  );
}

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
              controller: emailController,
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
              controller: passwordController,
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
              onPressed: signInFireBase,
              child: Text('Entrar'),
            ),
          ],
        ),
      ),
    );
  }
}
