// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:teacherapp/controller/user_controller.dart';

import '../../model/user_model.dart';
import '../../utils/custom_colors.dart';
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
    Get.put(UserController());
    return Scaffold(
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Container(
              height: MediaQuery.of(context).size.height,
              width: double.maxFinite,
              color: constLight,
            ),
            Container(
              height: 400,
              padding: const EdgeInsets.only(bottom: 83, left: 24, right: 24),
              width: double.maxFinite,
              color: lowBlue,
              child: Image.asset(
                'assets/images/register_image.png',
                height: 200,
                width: 100,
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 260),
              decoration: const BoxDecoration(
                color: constLight,
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(40),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 35,
                  vertical: 20,
                ),
                child: GetBuilder<UserController>(
                  builder: (controller) {
                    return Column(
                      children: [
                        const Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              'Login',
                              style: TextStyle(
                                fontSize: 34,
                                fontWeight: FontWeight.w500,
                                letterSpacing: 1.5,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        TextFieldCustom(
                          controller: controller.emailControllerLogin,
                          keyboardType: TextInputType.emailAddress,
                          hintText: 'E-mail',
                          labelText: 'E-mail',
                          prefixIcon: const Icon(
                            Icons.person,
                          ),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        TextFieldCustom(
                          controller: controller.passwordControllerLogin,
                          hintText: 'Senha',
                          labelText: 'Senha',
                          prefixIcon: const Icon(
                            Icons.password,
                          ),
                          obscureText: true,
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            TextButton(
                              onPressed: widget.onTap,
                              child: const Text(
                                'Registrar',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                  color: primaryColor,
                                ),
                              ),
                            ),
                            SizedBox(
                                width: MediaQuery.of(context).size.width * 0.2),
                            ElevatedButton(
                              style: ButtonStyle(
                                minimumSize: MaterialStatePropertyAll(
                                  Size(MediaQuery.of(context).size.width * 0.3,
                                      40),
                                ),
                                elevation: const MaterialStatePropertyAll(5),
                              ),
                              onPressed: () async {
                                controller.signInFireBase(
                                  email:
                                      userController.emailControllerLogin.text,
                                  pass: userController
                                      .passwordControllerLogin.text,
                                );
                              },
                              child: const Text(
                                'Cadastrar',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: constLight,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
