import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:teacherapp/screens/dialog/create_expense_dialog.dart';
import 'package:teacherapp/utils/custom_colors.dart';

import '../../controller/user_controller.dart';
import '../../model/expense_model.dart';
import '../../utils/my_app_bar.dart';

class ExpensesPage extends StatefulWidget {
  const ExpensesPage({super.key});

  @override
  State<ExpensesPage> createState() => _ExpensesPageState();
}

class _ExpensesPageState extends State<ExpensesPage> {
  final UserController userController = Get.find<UserController>();
  final GlobalKey<ScaffoldState> _key = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(
          60.0,
        ),
        child: MyAppBar(_key),
      ),
      key: _key,
      body: StreamBuilder<List<Expense>>(
        stream: userController.expensesStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation(
                  primaryColor,
                ),
              ),
            );
          } else if (snapshot.hasError) {
            return Center(child: Text('Erro: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('Nenhuma despesa encontrada.'));
          } else {
            List<Expense> expenses = snapshot.data!;

            return ListView.builder(
              itemCount: expenses.length,
              itemBuilder: (context, index) {
                print(expenses);
                Expense expense = expenses[index];

                return ListTile(
                  title: Text(expense.nomeDespesa.toString()),
                  subtitle: Text('Valor: ${expense.valorDespesa.toString()}'),
                  trailing: IconButton(
                    onPressed: () {
                      userController.deleteExpense(expense.id as String);
                    },
                    icon: Icon(
                      Icons.delete,
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
