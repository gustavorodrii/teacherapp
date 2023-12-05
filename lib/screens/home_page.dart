import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:teacherapp/screens/register/register_page.dart';

import '../controller/register_controller.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final RegisterController userController = Get.put<RegisterController>(
    RegisterController(),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Text('UEPA ${userController.userModel?.birth}'),
            ElevatedButton(
              onPressed: () {
                userController.signOut();
              },
              child: Text('Deslogar'),
            ),
          ],
        ),
      ),
    );
  }
}
