import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controller/user_controller.dart';
import 'custom_colors.dart';

class MyAppBar extends StatefulWidget {
  final GlobalKey<ScaffoldState> _scaffoldKey;

  const MyAppBar(this._scaffoldKey);

  @override
  State<MyAppBar> createState() => _MyAppBarState();
}

class _MyAppBarState extends State<MyAppBar> {
  final UserController userController = Get.put<UserController>(
    UserController(),
  );

  User? firebaseUser;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('users')
          .doc(firebaseUser?.uid)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return AppBar(
            title: Text('Carregando...'),
          );
        }
        if (snapshot.hasError) {
          return AppBar(
            title: Text('Error ao carregar dados'),
          );
        }
        var userData = snapshot.data?.data();
        return AppBar(
          backgroundColor: lowBlue,
          elevation: 1,
          titleSpacing: 0,
          leading: IconButton(
            onPressed: () => widget._scaffoldKey.currentState!.openDrawer(),
            icon: const Icon(
              Icons.menu,
              color: primaryColor,
            ),
          ),
          title: Padding(
            padding: const EdgeInsets.only(right: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  userController.userModel?.name != null
                      ? 'Oi, ${userController.userModel?.name?.split(' ')[0]}'
                      : (userController.userData.value != null &&
                              userController.userData.value['name'] != null)
                          ? 'Oi, ${userController.userData.value['name'].split(' ')[0]}'
                          : 'Olá',
                  style: const TextStyle(
                    fontSize: 14,
                    color: primaryColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(width: 10),
                CircleAvatar(
                  maxRadius: 15,
                  backgroundColor: constLight,
                  child: Text(
                    userController.userModel?.name
                            ?.toUpperCase()
                            ?.substring(0, 1) ??
                        (userController.userData.value['name'] != null
                            ? userController.userData.value['name']
                                .toUpperCase()
                                .substring(0, 1)
                            : ''),
                    style: const TextStyle(
                      color: lowBlue,
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
        return Container();
      },
    );
  }
}
