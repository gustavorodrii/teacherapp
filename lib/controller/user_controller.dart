import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:teacherapp/model/user_model.dart';
import 'package:teacherapp/screens/login/login_page.dart';
import 'package:teacherapp/screens/pages/expenses_page.dart';

import '../model/expense_model.dart';

class UserController extends GetxController {
  RxBool isLoading = false.obs;
  Rx<Map<String, dynamic>> userData = Rx<Map<String, dynamic>>(<String, dynamic>{});
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  UserModel? userModel;
  String? kindOfDoc = 'Selecione';
  String? expenseStatusItem = 'Selecione';

  final List<String> kindOfDocData = [
    'Selecione',
    'Comprovante',
    'Nota Fiscal',
    'Boleto',
    'Outros',
  ];
  final List<String> expenseStatus = [
    'Selecione',
    'Pago',
    'Em aberto',
  ];

  User? firebaseUser;

  Future<void> _saveUserData(UserModel userData) async {
    userModel = userData;

    await firestore.collection("users").doc(firebaseUser!.uid).set(userModel!.toMap());
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
      await firestore.collection("users").doc(firebaseUser!.uid).get().then((userSnapshot) {
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
  TextEditingController expensesDescriptionAttach = TextEditingController();

  void resetControllers() {
    nomeDespesa.clear();
    valorDespesa.clear();
    dataDespesa.clear();
    expensesDescriptionAttach.clear();
    kindOfDoc = 'Selecione';
    expenseStatusItem = 'Selecione';
    selectedType = 'Selecione';
  }

  Future<void> updateLatestExpenseTimestamp(String userId) async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('expenses')
          .orderBy('timestamp', descending: true)
          .limit(1)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        Timestamp latestTimestamp = querySnapshot.docs.first['timestamp'] as Timestamp;

        await FirebaseFirestore.instance
            .collection('users')
            .doc(userId)
            .update({'latestExpenseTimestamp': latestTimestamp});
      }
    } catch (e) {
      print('Erro ao atualizar latestExpenseTimestamp: $e');
    }
  }

  Future<void> saveExpense() async {
    try {
      // Obtém o usuário atualmente autenticado
      User? user = FirebaseAuth.instance.currentUser;

      final data = Timestamp.now();

      if (user != null) {
        String userId = user.uid;

        final expense = Expense(
          nomeDespesa: nomeDespesa.text,
          valorDespesa: double.parse(valorDespesa.text),
          dataDespesa: dataDespesa.text,
          tipoDespesa: selectedType,
          image: imageUrl,
          kindOfDoc: kindOfDoc,
          descriptionAttach: expensesDescriptionAttach.text,
          timestamp: data,
          expenseStatus: expenseStatusItem,
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
          'image': expense.image,
          'kindOfDoc': expense.kindOfDoc,
          'descriptionAttach': expense.descriptionAttach,
          'timestamp': expense.timestamp,
          'expenseStatus': expense.expenseStatus,
        });
        await updateLatestExpenseTimestamp(userId);
        resetControllers();
        expensesList.add(expense);
        update();
        getExpenses();
        update();
        Get.back();
        Get.to(
          () => ExpensesPage(),
        );
        update();
      } else {
        print('Usuário não autenticado.');
      }
    } catch (e) {
      print('Erro ao salvar despesa: $e');
    }
  }

  String selectedStatus = 'Todas';
  List<Expense> filteredExpenses = [];

  void filterExpenses(String status) {
    if (status == 'Todas') {
      filteredExpenses = expensesList;
    } else if (status == 'Pago') {
      filteredExpenses = expensesList.where((expense) => expense.expenseStatus == status).toList();
    } else if (status == 'Em aberto') {
      filteredExpenses = expensesList.where((expense) => expense.expenseStatus == status).toList();
    }
    selectedStatus = status;
    getExpenses();
  }

  RxList<Expense> expensesList = <Expense>[].obs;

  Future<void> getExpenses() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        String userId = user.uid;

        CollectionReference expensesCollection =
            FirebaseFirestore.instance.collection('users').doc(userId).collection('expenses');
        update();

        QuerySnapshot querySnapshot = await expensesCollection.get();

        List<Expense> expenses = querySnapshot.docs.map((doc) {
          Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
          doc.id;
          data['id'] = doc.id;
          return Expense.fromMap(data);
        }).toList();
        update();
        expensesList.clear();
        expensesList.addAll(expenses);
        filteredExpenses.clear();
        filteredExpenses.addAll(expenses);
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
      update();
    } catch (e) {
      print('Erro ao deletar $e');
    }
  }

  TextEditingController nomeDespesaEdit = TextEditingController();
  TextEditingController valorDespesaEdit = TextEditingController();
  TextEditingController dataDespesaEdit = TextEditingController();
  TextEditingController expensesDescriptionAttachEdit = TextEditingController();
  String? kindOfDocEdit = 'Selecione';
  String? selectedTypeEdit = 'Selecione';
  String? expenseStatusItemEdit = 'Selecione';

  Future<void> updateExpenses(
    String expenseId,
    Expense expense,
  ) async {
    // try {
    User? user = FirebaseAuth.instance.currentUser;
    String userId = user!.uid;
    await FirebaseFirestore.instance
        .collection("users")
        .doc(userId)
        .collection("expenses")
        .doc(expenseId)
        .update({
      'nomeDespesa': expense.nomeDespesa,
      'dataDespesa': expense.dataDespesa,
      'tipoDespesa': expense.tipoDespesa,
      'valorDespesa': expense.valorDespesa,
      'image': expense.image,
      'descriptionAttach': expense.descriptionAttach,
      'kindOfDoc': expense.kindOfDoc,
      'timestamp': expense.timestamp,
      'expenseStatus': expense.expenseStatus,
    });
    update();
    getExpenses();

    final index = userController.expensesList.indexWhere((element) => expense.id == expenseId);

    if (index != -1) {
      userController.expensesList[index] = expense;
    }
    // } catch (e) {
    //   print('Erro $e');
    // }
  }

  void onClickUpdateExpense(String expenseId) {
    Expense expense = Expense(
      nomeDespesa: nomeDespesaEdit.text.trim(),
      valorDespesa: valorDespesaEdit.text.isEmpty ? null : double.parse(valorDespesaEdit.text),
      dataDespesa: dataDespesaEdit.text.trim(),
      tipoDespesa: selectedTypeEdit,
      image: imageUrl,
      descriptionAttach: expensesDescriptionAttachEdit.text.trim(),
      kindOfDoc: kindOfDocEdit,
      timestamp: Timestamp.now(),
      expenseStatus: expenseStatusItemEdit,
    );

    update();
    Get.back();
    getExpenses();

    updateExpenses(expenseId, expense);
    update();
  }

  void deleteimage() {
    imageUrl = null;
    selectedImage = null;
    update();
  }

  String? imageUrl;

  XFile? selectedImage;
  Future<void> getFile() async {
    update();

    ImagePicker imagePicker = ImagePicker();
    XFile? file = await imagePicker.pickImage(
      source: ImageSource.gallery,
    );
    update();

    if (file == null) return;

    String uniqueFileName = DateTime.now().millisecondsSinceEpoch.toString();
    update();

    Reference referenceRoot = FirebaseStorage.instance.ref();
    update();

    Reference referenceDirImages = referenceRoot.child('expenses');
    update();

    Reference referenceImageToUpload = referenceDirImages.child(uniqueFileName);
    update();

    try {
      update();

      await referenceImageToUpload.putFile(File(file!.path));
      update();

      imageUrl = await referenceImageToUpload.getDownloadURL();
      update();

      selectedImage = file;
      update();
    } catch (e) {}
  }

  @override
  void onInit() async {
    getExpenses();
    super.onInit();
  }
}
