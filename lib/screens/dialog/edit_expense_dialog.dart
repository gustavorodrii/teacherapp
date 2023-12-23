// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import 'package:teacherapp/controller/user_controller.dart';
import 'package:teacherapp/screens/dialog/create_expense_dialog.dart';
import 'package:teacherapp/utils/custom_colors.dart';
import 'package:teacherapp/utils/data_input_formatter.dart';
import 'package:teacherapp/utils/full_screen_image.dart';
import 'package:teacherapp/utils/textfield_custom.dart';

import '../../model/expense_model.dart';
import 'attach_doc.dart';
import 'attach_doc_edit.dart';

class EditExpenseDialog extends StatefulWidget {
  final Expense expense;
  const EditExpenseDialog({
    Key? key,
    required this.expense,
  }) : super(key: key);

  @override
  State<EditExpenseDialog> createState() => _EditExpenseDialogState();
}

class _EditExpenseDialogState extends State<EditExpenseDialog> {
  @override
  void initState() {
    userController.nomeDespesaEdit =
        TextEditingController(text: widget.expense.nomeDespesa);
    userController.valorDespesaEdit = TextEditingController(
        text: widget.expense.valorDespesa?.toStringAsFixed(2));
    userController.dataDespesaEdit =
        TextEditingController(text: widget.expense.dataDespesa);
    userController.kindOfDocEdit = widget.expense.kindOfDoc;

    userController.selectedTypeEdit = widget.expense.tipoDespesa;

    userController.expensesDescriptionAttachEdit =
        TextEditingController(text: widget.expense.descriptionAttach);
    userController.nomeDespesaEdit =
        TextEditingController(text: widget.expense.nomeDespesa);
    super.initState();
  }

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
        'Editar despesa',
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
              controller: userController.nomeDespesaEdit,
              keyboardType: TextInputType.name,
              hintText: 'Nome da despesa',
              prefixIcon: Icon(
                Icons.abc,
              ),
              labelText: 'Nome',
            ),
            const SizedBox(height: 15),
            TextFieldCustom(
              controller: userController.valorDespesaEdit,
              keyboardType: TextInputType.number,
              hintText: 'Valor da despesa',
              prefixIcon: const Icon(
                Icons.attach_money_outlined,
              ),
              labelText: 'Valor',
            ),
            const SizedBox(height: 15),
            TextFieldCustom(
              controller: userController.dataDespesaEdit,
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
              value: userController.expenseStatusItemEdit,
              items: userController.expenseStatus
                  .map(
                    (item) => DropdownMenuItem<String>(
                      value: item,
                      child: Text(item),
                    ),
                  )
                  .toList(),
              onChanged: (item) =>
                  setState(() => userController.expenseStatusItemEdit = item),
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
              value: userController.selectedTypeEdit,
              items: userController.listTypeOptions
                  .map(
                    (item) => DropdownMenuItem<String>(
                      value: item,
                      child: Text(item),
                    ),
                  )
                  .toList(),
              onChanged: (item) =>
                  setState(() => userController.selectedTypeEdit = item),
            ),
            const SizedBox(height: 15),
            if (widget.expense.image != null)
              SizedBox(
                height: 150,
                width: 100,
                child: GestureDetector(
                  onTap: () {
                    Get.to(
                      FullScreenImage(
                        expense: widget.expense,
                      ),
                    );
                  },
                  child: Image.network(
                    widget.expense.image as String,
                  ),
                ),
              ),
            if (widget.expense.image == null)
              const Text(
                'Não há imagem em anexo',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
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
                  AttachDocEdit(),
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
              onPressed: () async {
                Get.dialog(
                  Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation(
                        primaryColor,
                      ),
                    ),
                  ),
                );

                await Future.delayed(
                  Duration(
                    seconds: 2,
                  ),
                );
                Get.back();
                userController.onClickUpdateExpense(
                  widget.expense.id as String,
                );
                FocusScope.of(context).unfocus();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    backgroundColor: Colors.green.shade100,
                    content: Text(
                      'Despesa editada com sucesso',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: primaryColor,
                      ),
                    ),
                  ),
                );
              },
              child: Text('Editar'),
            ),
          ],
        ),
      ),
    );
  }
}
