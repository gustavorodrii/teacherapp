import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/date_symbol_data_file.dart';
import 'package:intl/intl.dart';
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
  String selectedStatus = 'Todas';
  List<Expense> filteredExpenses = [];

  Color todasButtonColor = Color(0xFFDDEAFE);
  Color pagasButtonColor = Color(0xFFDDEAFE);
  Color emAbertoButtonColor = Color(0xFFDDEAFE);

  final GlobalKey<ScaffoldState> _key = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    userController.getExpenses();
    filteredExpenses = userController.expensesList;
  }

  void filterExpenses(String status) {
    setState(() {
      resetButtonColors();
      if (status == 'Todas') {
        filteredExpenses = userController.expensesList;
        todasButtonColor = Colors.white;
      } else if (status == 'Pago') {
        filteredExpenses = userController.expensesList
            .where((expense) => expense.expenseStatus == status)
            .toList();
        pagasButtonColor = Colors.white;
      } else if (status == 'Em aberto') {
        filteredExpenses = userController.expensesList
            .where((expense) => expense.expenseStatus == status)
            .toList();
        emAbertoButtonColor = Colors.white;
      }
      selectedStatus = status;
    });
  }

  void resetButtonColors() {
    todasButtonColor = Color(0xFFDDEAFE);
    pagasButtonColor = Color(0xFFDDEAFE);
    emAbertoButtonColor = Color(0xFFDDEAFE);
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
      body: Container(
        constraints: BoxConstraints(
          minHeight: 100,
        ),
        child: Stack(
          children: [
            Column(
              children: [
                Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            elevation: 3,
                            minimumSize: Size(76, 32),
                            primary: todasButtonColor,
                          ),
                          onPressed: () {
                            filterExpenses('Todas');
                          },
                          child: Text(
                            'Todas',
                            style: TextStyle(
                              color: primaryColor,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        const SizedBox(width: 15),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            elevation: 3,
                            minimumSize: Size(76, 32),
                            primary: pagasButtonColor,
                          ),
                          onPressed: () {
                            filterExpenses('Pago');
                          },
                          child: Text(
                            'Pagas',
                            style: TextStyle(
                              color: primaryColor,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        const SizedBox(width: 15),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            elevation: 3,
                            minimumSize: Size(76, 32),
                            primary: emAbertoButtonColor,
                          ),
                          onPressed: () {
                            filterExpenses('Em aberto');
                          },
                          child: Text(
                            'Em aberto',
                            style: TextStyle(
                              color: primaryColor,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(
                        vertical: 10,
                      ),
                      child: Text(
                        'Despesas - $selectedStatus',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: primaryColor,
                        ),
                      ),
                    ),
                  ],
                ),
                Expanded(
                  child: filteredExpenses.isEmpty
                      ? Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Não há despesas por aqui',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            SizedBox(height: 10),
                            Icon(
                              Icons.sentiment_dissatisfied,
                              size: 50,
                              color: Colors.red.shade500,
                            ),
                          ],
                        )
                      : StreamBuilder<List<Expense>>(
                          stream: userController.expensesStream,
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return Center(
                                child: CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation(
                                    primaryColor,
                                  ),
                                ),
                              );
                            } else if (snapshot.hasError) {
                              return Center(
                                  child: Text('Erro: ${snapshot.error}'));
                            } else if (!snapshot.hasData ||
                                snapshot.data!.isEmpty) {
                              return Center(
                                  child: Text('Nenhuma despesa encontrada.'));
                            } else {
                              List<Expense> expenses = snapshot.data!;

                              return ListView.builder(
                                itemCount: filteredExpenses.length,
                                itemBuilder: (context, index) {
                                  Expense expense = filteredExpenses[index];

                                  return ExpensesWidgetItem(
                                    expense: expense,
                                  );
                                },
                              );
                            }
                          },
                        ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
