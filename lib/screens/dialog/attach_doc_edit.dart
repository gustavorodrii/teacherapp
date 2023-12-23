import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:teacherapp/controller/user_controller.dart';
import 'package:teacherapp/screens/dialog/create_expense_dialog.dart';

import '../../utils/custom_colors.dart';
import '../../utils/drop_down_custom.dart';

class AttachDocEdit extends StatefulWidget {
  const AttachDocEdit({Key? key}) : super(key: key);

  @override
  State<AttachDocEdit> createState() => _AttachDocEditState();
}

class _AttachDocEditState extends State<AttachDocEdit> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        title: Text(
          'Anexo',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(2, 0, 2, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Adicionar documentos relacionados a despesa:',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: primaryColor,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: 'Descrição',
                            style: const TextStyle(
                              fontFamily: 'Montserrat',
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: primaryColor,
                            ),
                          ),
                          TextSpan(
                            text: '',
                            style: const TextStyle(
                              fontFamily: 'Montserrat',
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: Colors.red,
                            ),
                          )
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      height: 32,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: bgTextFieldColor,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 1,
                            blurRadius: 2,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: TextFormField(
                        keyboardType: TextInputType.name,
                        controller:
                            userController.expensesDescriptionAttachEdit,
                        textCapitalization: TextCapitalization.sentences,
                        style: TextStyle(color: Colors.grey),
                        decoration: const InputDecoration(
                          contentPadding: EdgeInsets.symmetric(
                            vertical: 8,
                            horizontal: 5,
                          ),
                          filled: true,
                          fillColor: constLight,
                          border: OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius: BorderRadius.all(
                              Radius.circular(10),
                            ),
                          ),
                          isDense: true,
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          hintText: "Ex.: boleto bancário",
                          hintStyle: TextStyle(
                            fontSize: 14,
                          ),
                        ),
                        validator: (text) {
                          if (text!.isEmpty) {
                            return "Título inválido!";
                          } else {
                            return null;
                          }
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Column(
                  children: [
                    const Row(
                      children: [
                        Text(
                          'Tipo de documento:',
                          style: TextStyle(
                            fontSize: 14.0,
                            fontFamily: 'Montserrat',
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 5),
                    DropDownCustomWidget(
                      widthDropDown: MediaQuery.of(context).size.width * 0.35,
                      errorText: '',
                      useErrorText: true,
                      validator: true,
                      valueDropdown: userController.kindOfDocEdit,
                      onChanged: (item) => setState(
                        () => userController.kindOfDocEdit = item,
                      ),
                      dropOptions: userController.kindOfDocData,
                    ),
                  ],
                ),
                const SizedBox(width: 10),
                GetBuilder<UserController>(
                  builder: (controller) {
                    if (controller.selectedImage != null) {
                      return SizedBox(
                        height: 100,
                        width: 100,
                        child: Image.file(
                          File(controller.selectedImage!.path),
                        ),
                      );
                    } else {
                      return Text(
                        'Não há anexos adicionados',
                      );
                    }
                  },
                ),
                const SizedBox(height: 15),
                ElevatedButton.icon(
                  style: ButtonStyle(
                    shape: MaterialStateProperty.all(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    backgroundColor: MaterialStateProperty.all<Color>(
                      lowBlue,
                    ),
                  ),
                  onPressed: () {
                    userController.getFile();
                    setState(() {});
                  },
                  icon: Image.asset('assets/images/clip_doc.png'),
                  label: Text(
                    'Adicionar documento',
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      style: ButtonStyle(
                        shape: MaterialStateProperty.all(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        backgroundColor: MaterialStateProperty.all<Color>(
                          constLight,
                        ),
                      ),
                      onPressed: () {
                        Get.back();
                      },
                      child: Text(
                        'Voltar',
                        style: TextStyle(
                          color: primaryColor,
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                    ),
                    const SizedBox(width: 20),
                    ElevatedButton(
                      style: ButtonStyle(
                        shape: MaterialStateProperty.all(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        backgroundColor: MaterialStateProperty.all<Color>(
                          primaryColor,
                        ),
                      ),
                      onPressed: () {
                        Get.back();
                      },
                      child: Text(
                        'Salvar',
                        style: TextStyle(
                          color: constLight,
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
