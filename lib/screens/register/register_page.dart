// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class RegisterPage extends StatefulWidget {
  final Function()? onTap;

  const RegisterPage({
    Key? key,
    this.onTap,
  }) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

TextEditingController emailController = TextEditingController();
TextEditingController passwordController = TextEditingController();
TextEditingController confirmPasswordController = TextEditingController();

void signUpFireBase() async {
  try {
    await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: emailController.text.trim(),
      password: passwordController.text.trim(),
    );

    await FirebaseFirestore.instance.collection('users').add({
      'email': emailController.text.trim(),
    });
  } catch (e) {}
}

class _RegisterPageState extends State<RegisterPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Cadastro',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      body: Column(
        children: [
          TextField(
            controller: emailController,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              hintText: 'E-mail',
            ),
          ),
          TextField(
            controller: passwordController,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              hintText: 'Senha',
            ),
          ),
          TextField(
            controller: confirmPasswordController,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              hintText: 'Confirmar Senha',
            ),
          ),
          ElevatedButton(
            onPressed: signUpFireBase,
            child: Text('Entrar'),
          ),
        ],
      ),
    );
  }
}
