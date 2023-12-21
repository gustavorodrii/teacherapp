import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:teacherapp/screens/pages/expenses_page.dart';

import '../../utils/custom_colors.dart';
import '../../utils/my_app_bar.dart';
import '../dialog/create_expense_dialog.dart';
import 'package:intl/intl.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GlobalKey<ScaffoldState> _key = GlobalKey<ScaffoldState>();

  User? firebaseUser;

  @override
  void initState() {
    super.initState();
    firebaseUser = FirebaseAuth.instance.currentUser;
  }

  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;
    String userId = user!.uid;
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(
          60.0,
        ),
        child: MyAppBar(_key),
      ),
      key: _key,
      body: SingleChildScrollView(
        child: Column(
          children: [
            TextButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => ExpensesPage()));
              },
              child: Stack(
                children: [
                  Container(
                    margin: const EdgeInsets.all(10),
                    width: MediaQuery.of(context).size.width,
                    height: 300,
                    decoration: BoxDecoration(
                      color: lowBlue,
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  Positioned(
                    bottom: 10,
                    right: 0,
                    child: Image.asset(
                      'assets/images/notes.png',
                      width: 200,
                      height: 150,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Positioned(
                    bottom: 35,
                    left: 30,
                    child: StreamBuilder(
                      stream: FirebaseFirestore.instance
                          .collection('users')
                          .doc(firebaseUser?.uid)
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Text('Carregando...');
                        }
                        if (snapshot.hasError) {
                          return Text('Error ao carregar dados');
                        }
                        if (snapshot.hasData && snapshot.data!.exists) {
                          var userData = snapshot.data?.data();

                          if (userData?['latestExpenseTimestamp'] != null) {
                            // Obtemos o objeto Timestamp
                            Timestamp timestamp =
                                userData?['latestExpenseTimestamp'];

                            // Convertemos o Timestamp para DateTime
                            DateTime date = timestamp.toDate();

                            // Formata a data como "dd/MM/yyyy"
                            String formattedDate =
                                DateFormat('dd/MM/yyyy').format(date);

                            return Text(
                              'Última att: $formattedDate',
                              style: TextStyle(
                                fontSize: 14,
                                color: primaryColor,
                                fontWeight: FontWeight.w400,
                              ),
                            );
                          } else {
                            return Text(
                              'Dados não encontrado',
                            );
                          }
                        } else {
                          return Text(
                            'Dados não encontrado',
                          );
                        }
                      },
                    ),
                  ),
                  const Positioned(
                    left: 30,
                    top: 35,
                    child: Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text: 'Minhas\n',
                            style: TextStyle(
                              fontSize: 34,
                              fontWeight: FontWeight.w600,
                              color: primaryColor,
                            ),
                          ),
                          TextSpan(
                            text: 'Despesas',
                            style: TextStyle(
                              fontSize: 34,
                              fontWeight: FontWeight.w600,
                              color: primaryColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Row(
              children: [
                TextButton(
                  onPressed: () {},
                  child: Stack(
                    children: [
                      Container(
                        margin: const EdgeInsets.all(10),
                        width: MediaQuery.of(context).size.width / 2.5,
                        height: 300,
                        decoration: BoxDecoration(
                          color: blue,
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      Positioned(
                        bottom: 10,
                        right: 0,
                        child: Image.asset(
                          'assets/images/note-add.png',
                          height: 150,
                          fit: BoxFit.cover,
                        ),
                      ),
                      const Positioned(
                        left: 30,
                        top: 35,
                        child: Text.rich(
                          TextSpan(
                            children: [
                              TextSpan(
                                text: 'A\n',
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.w600,
                                  color: primaryColor,
                                ),
                              ),
                              TextSpan(
                                text: 'A',
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.w600,
                                  color: primaryColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                TextButton(
                  onPressed: () {
                    userController.deleteimage();

                    Get.dialog(
                      CreateExpenseDialog(),
                    );
                  },
                  child: Stack(
                    children: [
                      Container(
                        margin: const EdgeInsets.all(10),
                        width: MediaQuery.of(context).size.width / 2.4,
                        height: 300,
                        decoration: BoxDecoration(
                          color: blue,
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      Positioned(
                        bottom: 10,
                        right: 0,
                        child: Image.asset(
                          'assets/images/note-add.png',
                          height: 150,
                          fit: BoxFit.cover,
                        ),
                      ),
                      const Positioned(
                        left: 30,
                        top: 35,
                        child: Text.rich(
                          TextSpan(
                            children: [
                              TextSpan(
                                text: 'Nova\n',
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.w600,
                                  color: primaryColor,
                                ),
                              ),
                              TextSpan(
                                text: 'Despesa',
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.w600,
                                  color: primaryColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
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
