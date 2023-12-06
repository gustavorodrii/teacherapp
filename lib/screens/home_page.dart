import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:teacherapp/screens/register/register_page.dart';
import 'package:teacherapp/utils/custom_colors.dart';

import '../controller/user_controller.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final UserController userController = Get.find<UserController>();

  final user = FirebaseAuth.instance.currentUser!;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<UserController>(
      init: UserController(),
      builder: (controller) {
        return Scaffold(
          body: SafeArea(
            child: Column(
              children: [
                Text(
                  'olha ele ${userController.emailLogin}',
                  style: TextStyle(
                    color: primaryColor,
                  ),
                ),
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
      },
    );
  }
}
