import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:teacherapp/model/user_model.dart';
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
                Text('${userController.userModel?.name}'),
                Text('${userController.userModel?.lastName}'),
                Text('${userController.userModel?.phone}'),
                Text('${userController.userModel?.email}'),
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

  Widget buildUser(UserModel user) => ListTile(
        title: Text(user.email.toString()),
        subtitle: Text(user.phone.toString()),
      );
}
