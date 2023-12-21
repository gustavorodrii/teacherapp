import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:teacherapp/screens/dialog/create_expense_dialog.dart';
import 'package:teacherapp/utils/custom_colors.dart';

import '../../controller/user_controller.dart';
import '../../model/expense_model.dart';
import '../../utils/my_app_bar.dart';
import 'expenses_widget_item.dart';

class ExpensesPage extends StatefulWidget {
  const ExpensesPage({super.key});

  @override
  State<ExpensesPage> createState() => _ExpensesPageState();
}

class _ExpensesPageState extends State<ExpensesPage> {
  final GlobalKey<ScaffoldState> _key = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    userController.getExpenses();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: Icon(
            Icons.arrow_back_ios_new,
          ),
        ),
        title: Text(
          'Minhas despesas',
        ),
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
                Expense expense = expenses[index];

                return ExpensesWidgetItem(
                  expense: expense,
                );
              },
            );
          }
        },
      ),
    );
  }
}
