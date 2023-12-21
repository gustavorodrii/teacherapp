import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:teacherapp/controller/user_controller.dart';
import 'package:teacherapp/utils/textfield_custom.dart';
import 'package:teacherapp/utils/custom_colors.dart';
import 'package:teacherapp/utils/data_input_formatter.dart';

import 'attach_doc.dart';

class CreateExpenseDialog extends StatefulWidget {
  const CreateExpenseDialog({super.key});

  @override
  State<CreateExpenseDialog> createState() => _CreateExpenseDialogState();
}

final UserController userController = Get.put<UserController>(UserController());

class _CreateExpenseDialogState extends State<CreateExpenseDialog> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(30),
        ),
      ),
      elevation: 50,
      title: const Text(
        'Cadastrar despesa',
        style: TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.w500,
        ),
        textAlign: TextAlign.center,
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 5),
            TextFieldCustom(
              controller: userController.nomeDespesa,
              keyboardType: TextInputType.name,
              hintText: 'Nome da despesa',
              prefixIcon: Icon(
                Icons.abc,
              ),
              labelText: 'Nome',
            ),
            const SizedBox(height: 15),
            TextFieldCustom(
              controller: userController.valorDespesa,
              keyboardType: TextInputType.number,
              hintText: 'Valor da despesa',
              prefixIcon: const Icon(
                Icons.attach_money_outlined,
              ),
              labelText: 'Valor',
            ),
            const SizedBox(height: 15),
            TextFieldCustom(
              controller: userController.dataDespesa,
              keyboardType: TextInputType.datetime,
              hintText: 'Data da despesa',
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                DataInputFormatter(),
              ],
              prefixIcon: const Icon(
                Icons.date_range,
              ),
              labelText: 'Data',
            ),
            const SizedBox(height: 15),
            DropdownButtonFormField<String>(
              decoration: InputDecoration(
                enabled: false,
                disabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(
                    width: 1,
                    color: lowBlue,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(
                    width: 1,
                    color: lowBlue,
                  ),
                ),
              ),
              value: userController.selectedType,
              items: userController.listTypeOptions
                  .map(
                    (item) => DropdownMenuItem<String>(
                      value: item,
                      child: Text(item),
                    ),
                  )
                  .toList(),
              onChanged: (item) =>
                  setState(() => userController.selectedType = item),
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
              onPressed: () async {
                Get.dialog(
                  AttachDoc(),
                );
              },
              icon: Image.asset(
                'assets/images/clip_doc.png',
              ),
              label: Text(
                'Adicionar documento',
              ),
            ),
            const SizedBox(height: 15),
            ElevatedButton(
              style: ButtonStyle(
                minimumSize: MaterialStateProperty.all(
                  Size(
                    110,
                    35,
                  ),
                ),
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
                userController.saveExpense();
              },
              child: Text('Cadastrar'),
            ),
          ],
        ),
      ),
    );
  }
}
