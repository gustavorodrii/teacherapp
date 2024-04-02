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
  Color todasButtonColor = Color(0xFFDDEAFE);
  Color pagasButtonColor = Color(0xFFDDEAFE);
  Color emAbertoButtonColor = Color(0xFFDDEAFE);

  final GlobalKey<ScaffoldState> _key = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    userController.filterExpenses('Todas');
    todasButtonColor = Colors.white;
    super.initState();
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
                            resetButtonColors();
                            todasButtonColor = Colors.white;

                            userController.filterExpenses('Todas');
                            setState(() {});
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
                            resetButtonColors();
                            pagasButtonColor = Colors.white;

                            userController.filterExpenses('Pago');
                            setState(() {});
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
                            resetButtonColors();
                            emAbertoButtonColor = Colors.white;
                            userController.filterExpenses('Em aberto');
                            setState(() {});
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
                        'Despesas - ${userController.selectedStatus}',
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
                  child: userController.filteredExpenses.isEmpty
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
                      : ListView.builder(
                          itemCount: userController.filteredExpenses.length,
                          itemBuilder: (context, index) {
                            Expense expense = userController.filteredExpenses[index];
                            return ExpensesWidgetItem(
                              expense: expense,
                            );
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
