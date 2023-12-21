import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:teacherapp/model/user_model.dart';
import 'package:teacherapp/screens/login/login_page.dart';

import '../model/expense_model.dart';

class UserController extends GetxController {
  RxBool isLoading = false.obs;
  Rx<Map<String, dynamic>> userData =
      Rx<Map<String, dynamic>>(<String, dynamic>{});
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  UserModel? userModel;
  String? kindOfDoc = 'Selecione';

  final List<String> kindOfDocData = [
    'Selecione',
    'Comprovante',
    'Nota Fiscal',
    'Boleto',
    'Outros',
  ];

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
  TextEditingController expensesDescriptionAttach = TextEditingController();

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
    expensesDescriptionAttach.clear();
    kindOfDoc = 'Selecione';

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
        Timestamp latestTimestamp =
            querySnapshot.docs.first['timestamp'] as Timestamp;

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
        });
        await updateLatestExpenseTimestamp(userId);

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
