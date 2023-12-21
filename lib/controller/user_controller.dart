import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:teacherapp/model/user_model.dart';
import 'package:teacherapp/screens/login/login_page.dart';

import '../model/expense_model.dart';

class UserController extends GetxController {
  RxBool isLoading = false.obs;
  Rx<Map<String, dynamic>> userData =
      Rx<Map<String, dynamic>>(<String, dynamic>{});
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  UserModel? userModel;

  User? firebaseUser;

  Future<void> _saveUserData(UserModel userData) async {
    userModel = userData;

    await firestore
        .collection("users")
        .doc(firebaseUser!.uid)
        .set(userModel!.toMap());
  }

  void signUpFireBase({
    required UserModel userData,
    required String pass,
  }) async {
    isLoading.value = true;
    update();

    await FirebaseAuth.instance
        .createUserWithEmailAndPassword(
      email: userData.email!,
      password: pass,
    )
        .then((value) async {
      firebaseUser = value.user;

      await _saveUserData(userData);
    });

    isLoading.value = false;
    update();
  }

  void signOut() async {
    await FirebaseAuth.instance.signOut();
  }

  TextEditingController emailControllerLogin = TextEditingController();
  TextEditingController passwordControllerLogin = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();

  void signInFireBase({
    required String email,
    required String pass,
  }) async {
    isLoading.value = true;
    update();
    await FirebaseAuth.instance
        .signInWithEmailAndPassword(
      email: email.trim(),
      password: pass.trim(),
    )
        .then((value) async {
      firebaseUser = value.user;
      await firestore
          .collection("users")
          .doc(firebaseUser!.uid)
          .get()
          .then((userSnapshot) {
        if (userSnapshot.exists) {
          userController.userData.value = userSnapshot.data()!;
        }
      });
      update();
    });
    isLoading.value = false;
    update();
  }

  String? selectedType = 'Selecione';

  void setSelectedType(String value) {
    selectedType = value;
    update();
  }

  List<String> listTypeOptions = [
    'Selecione',
    'Aluguel/Moradia',
    'Financiamento de Casa',
    'Educação',
    'Alimentação',
    'Transporte',
    'Saúde',
    'Seguro',
    'Entretenimento',
    'Telefone/Internet',
    'Água',
    'Luz',
    'Gás',
    'Supermercado',
    'Restaurantes/Cafés',
    'Roupas',
    'Cuidados Pessoais',
    'Assinaturas (ex: streaming)',
    'Viagens/Férias',
    'Impostos',
    'Economias/Investimentos',
    'Outros',
  ];

  TextEditingController nomeDespesa = TextEditingController();
  TextEditingController valorDespesa = TextEditingController();
  TextEditingController dataDespesa = TextEditingController();

  void resetControllers() {
    nomeDespesa.clear();
    valorDespesa.clear();
    dataDespesa.clear();
    selectedType = null;
  }

  Future<void> saveExpense() async {
    try {
      // Obtém o usuário atualmente autenticado
      User? user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        String userId = user.uid;

        final expense = Expense(
          nomeDespesa: nomeDespesa.text,
          valorDespesa: double.parse(valorDespesa.text),
          dataDespesa: dataDespesa.text,
          tipoDespesa: selectedType,
        );

        await FirebaseFirestore.instance
            .collection('users')
            .doc(userId)
            .collection('expenses')
            .add({
          'nomeDespesa': expense.nomeDespesa,
          'valorDespesa': expense.valorDespesa,
          'dataDespesa': expense.dataDespesa,
          'tipoDespesa': expense.tipoDespesa,
        });
        update();

        resetControllers();
        update();
        getExpenses();

        Get.back();
        update();
      } else {
        print('Usuário não autenticado.');
      }
    } catch (e) {
      print('Erro ao salvar despesa: $e');
    }
  }

  RxList<Expense> expensesList = <Expense>[].obs;
  final _expensesController = StreamController<List<Expense>>.broadcast();
  Stream<List<Expense>> get expensesStream => _expensesController.stream;

  void startExpenseStream() {
    _expensesController.add(expensesList);
  }

  Future<void> getExpenses() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        String userId = user.uid;

        CollectionReference expensesCollection = FirebaseFirestore.instance
            .collection('users')
            .doc(userId)
            .collection('expenses');
        update();

        QuerySnapshot querySnapshot = await expensesCollection.get();

        List<Expense> expenses = querySnapshot.docs.map((doc) {
          Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
          doc.id;
          data['id'] = doc.id;
          return Expense.fromMap(data);
        }).toList();
        update();

        expensesList.assignAll(expenses);
        startExpenseStream();
        update();
      }
    } catch (e) {
      print('Erro ao obter despesas: $e');
    }
  }

  Future<void> deleteExpense(String id) async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      String userId = user!.uid;

      await FirebaseFirestore.instance
          .collection("users")
          .doc(userId)
          .collection("expenses")
          .doc(id)
          .delete();

      expensesList.removeWhere(
        (element) => element.id == id,
      );
      update();
      getExpenses();
    } catch (e) {
      print('Erro ao deletar $e');
    }
  }

  @override
  void onInit() async {
    getExpenses();
    super.onInit();
  }
}
