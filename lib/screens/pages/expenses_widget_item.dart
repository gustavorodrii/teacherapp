// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';

import 'package:teacherapp/model/expense_model.dart';
import 'package:teacherapp/screens/dialog/create_expense_dialog.dart';

import '../../utils/custom_colors.dart';
import '../../utils/dropdown_custon_edit_delete.dart';
import '../../utils/full_screen_image.dart';
import '../dialog/edit_expense_dialog.dart';

class ExpensesWidgetItem extends StatefulWidget {
  final Expense expense;
  const ExpensesWidgetItem({
    Key? key,
    required this.expense,
  }) : super(key: key);

  @override
  State<ExpensesWidgetItem> createState() => _ExpensesWidgetItemState();
}

class _ExpensesWidgetItemState extends State<ExpensesWidgetItem> {
  bool isOpen = false;

  void setOpen(bool value) {
    setState(() {
      isOpen = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 10,
      ),
      child: Container(
        constraints: BoxConstraints(
          minHeight: 100,
        ),
        padding: EdgeInsets.symmetric(
          horizontal: 5,
          vertical: 5,
        ),
        decoration: BoxDecoration(
          color: Color(0xFFFAFAFA),
          boxShadow: [
            BoxShadow(
              color: blue,
              spreadRadius: 2,
              offset: Offset.fromDirection(
                2,
                5,
              ),
            ),
          ],
          borderRadius: BorderRadius.circular(5),
        ),
        child: Column(
          children: [
            ListTile(
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        widget.expense.nomeDespesa.toString(),
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Stack(
                        children: [
                          DropDownCustonEditDelete(
                            itens: const ["Editar", "Excluir"],
                            onChanged: (value) async {
                              if (value == "Excluir") {
                                await userController.deleteExpense(
                                  widget.expense.id as String,
                                );

                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    backgroundColor: Colors.red.shade100,
                                    content: Text(
                                      'Despesa excluída com sucesso',
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                        color: primaryColor,
                                      ),
                                    ),
                                  ),
                                );
                              } else {
                                userController.resetControllers();
                                userController.deleteimage();

                                Get.dialog(
                                  EditExpenseDialog(
                                    expense: widget.expense,
                                  ),
                                );
                              }
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(
                              text: 'Valor: ',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            TextSpan(
                              text: 'R\$ ${widget.expense.valorDespesa?.toStringAsFixed(2)}',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 5),
                  Row(
                    children: [
                      Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(
                              text: 'Status da despesa: ',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            TextSpan(
                              text: widget.expense.expenseStatus,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 5),
                  Row(
                    children: [
                      Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(
                              text: 'Data de pagamento: ',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            TextSpan(
                              text: '${widget.expense.dataDespesa}',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Spacer(),
                      if (!isOpen)
                        InkWell(
                          onTap: () {
                            setOpen(!isOpen);
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: lowBlue,
                            ),
                            child: Icon(
                              Icons.arrow_drop_down_sharp,
                              size: 20,
                              color: constLight,
                            ),
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
            if (isOpen)
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 10,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Tipo de despesa',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text(
                            widget.expense.tipoDespesa.toString(),
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      if (widget.expense.image != null)
                        Container(
                          padding: EdgeInsets.all(10),
                          height: 200,
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            border: Border.all(
                              color: blue,
                              width: 2,
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Anexo',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              Container(
                                child: SizedBox(
                                  height: 150,
                                  width: 100,
                                  child: GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => FullScreenImage(
                                            expense: widget.expense,
                                          ),
                                        ),
                                      );
                                    },
                                    child: Image.network(
                                      widget.expense.image as String,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      const SizedBox(height: 30),
                      InkWell(
                        onTap: () {
                          setOpen(!isOpen);
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: lowBlue,
                              ),
                              child: Icon(
                                isOpen ? Icons.arrow_drop_up_sharp : null,
                                size: 20,
                                color: constLight,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
