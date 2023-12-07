import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:teacherapp/model/user_model.dart';
import 'package:teacherapp/screens/dialog/create_expense_dialog.dart';
import 'package:teacherapp/screens/register/register_page.dart';
import 'package:teacherapp/utils/custom_colors.dart';

import '../controller/user_controller.dart';
import '../model/expense_model.dart';
import '../utils/my_app_bar.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final UserController userController = Get.find<UserController>();
  final GlobalKey<ScaffoldState> _key = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    userController.getExpenses();

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
          }
          // } else if (snapshot.hasError) {
          else if (snapshot.hasError) {
            return Center(child: Text('Erro: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('Nenhuma despesa encontrada.'));
          } else {
            List<Expense> expenses = snapshot.data!;

            return ListView.builder(
              itemCount: expenses.length,
              itemBuilder: (context, index) {
                Expense expense = expenses[index];

                return ListTile(
                  title: Text(expense.nomeDespesa.toString()),
                  subtitle: Text('Valor: ${expense.valorDespesa.toString()}'),
                );
              },
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Theme.of(context).primaryColor,
        onPressed: () {
          Get.dialog(
            CreateExpenseDialog(),
          );
        },
        label: Text(
          'Nova despesa',
        ),
      ),
    );
  }
}
