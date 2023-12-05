// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:teacherapp/controller/register_controller.dart';
import 'package:teacherapp/model/user_model.dart';
import 'package:teacherapp/utils/custom_colors.dart';

import '../../utils/data_input_formatter.dart';
import '../../utils/telefone_input_formatter.dart';
import '../widget/textfield_custom.dart';

class RegisterPage extends StatefulWidget {
  final Function()? onTap;

  const RegisterPage({
    Key? key,
    this.onTap,
  }) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  @override
  Widget build(BuildContext context) {
    DateTime? _auxBirth;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: constLight,
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
                child: GetBuilder<RegisterController>(
                  init: RegisterController(),
                  builder: (controller) {
                    return Column(
                      children: [
                        const Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              'Cadastro',
                              style: TextStyle(
                                fontSize: 34,
                                fontWeight: FontWeight.w500,
                                letterSpacing: 1.5,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        Row(
                          children: [
                            Expanded(
                              child: TextFieldCustom(
                                // controller: controller.nameController,
                                hintText: 'Nome',
                                labelText: 'Nome',
                                onChanged: controller.setName,
                                onSubmitted: (name) {},
                                prefixIcon: const Icon(
                                  Icons.perm_contact_cal,
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Expanded(
                              child: TextFieldCustom(
                                // controller: controller.lastNameController,
                                hintText: 'Sobrenome',
                                labelText: 'Sobrenome',
                                onChanged: controller.setLastName,
                                prefixIcon: const Icon(
                                  Icons.perm_contact_cal,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        TextFieldCustom(
                          // controller: controller.phoneController,
                          hintText: 'Telefone',
                          labelText: 'Telefone',
                          onChanged: controller.setPhone,
                          prefixIcon: const Icon(
                            Icons.phone_android,
                          ),
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            TelefoneInputFormatter()
                          ],
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        TextFieldCustom(
                          // controller: controller.emailController,
                          hintText: 'E-mail',
                          labelText: 'E-mail',
                          onChanged: controller.setEmail,
                          prefixIcon: const Icon(
                            Icons.person,
                          ),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        TextFieldCustom(
                          // controller: controller.birthController,
                          hintText: 'Data de nascimento',
                          labelText: 'Data de nascimento',
                          onChanged: controller.setBirth,
                          prefixIcon: const Icon(
                            Icons.person,
                          ),
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            DataInputFormatter()
                          ],
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        TextFieldCustom(
                          // controller: controller.passwordController,
                          hintText: 'Senha',
                          labelText: 'Senha',
                          onChanged: controller.setPass,
                          prefixIcon: const Icon(
                            Icons.password,
                          ),
                          obscureText: true,
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        TextFieldCustom(
                          // controller: controller.confirmPasswordController,
                          hintText: 'Confirme sua senha',
                          labelText: 'Confirme sua senha',
                          onChanged: controller.setPassConfirm,
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
                                'Já tem cadastro?',
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
                                final Map<String, dynamic> userData = {
                                  "name": controller.name.value.trim(),
                                  "lastName": controller.lastName.value.trim(),
                                  "email": controller.email.value
                                      .trim()
                                      .toLowerCase(),
                                  "phone": controller.phone.value,
                                  "registrationDate": Timestamp.now(),
                                  "birthDate": controller.birth.toString()
                                };

                                controller.signUpFireBase(
                                  userData: UserModel.fromJson(userData),
                                  pass: controller.pass.value,
                                );
                              },
                              child: const Text(
                                'Entrar',
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
