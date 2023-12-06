import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:teacherapp/model/user_model.dart';

class UserController extends GetxController {
  final GetStorage box = GetStorage();

  RxBool isLoading = false.obs;
  Rx<Map<String, dynamic>> userData =
      Rx<Map<String, dynamic>>(<String, dynamic>{});
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  UserModel? userModel;

  User? firebaseUser;

  //login email
  String? emailLogin;
  Future<void> setEmailLogin(String setemail) async {
    emailLogin = setemail;
    await box.write('email', emailLogin);
    update();
  }

  Future<void> removeEmail() async {
    await box.remove('email');
  }

  Future<void> getEmail() async {
    final String savedemail = box.read('email') ?? '';
    emailLogin = savedemail;
    update();
  }

  //login senha
  late String passLogin;
  void setPassLogin(String setpass) {
    passLogin = setpass;
    update();
  }

  //name
  RxString name = ''.obs;
  void setName(String setName) {
    name.value = setName;
    update();
  }

  //last name
  RxString lastName = ''.obs;
  void setLastName(String setLastName) {
    lastName.value = setLastName;
    update();
  }

  //phone
  RxString phone = ''.obs;
  void setPhone(String setPhone) {
    phone.value = setPhone;
    update();
  }

  //email
  RxString email = ''.obs;

  void setEmail(String setEmail) {
    email.value = setEmail;
    update();
  }

  //pass
  RxString pass = ''.obs;
  void setPass(String setPass) {
    pass.value = setPass;
    update();
  }

  //pass confirm
  RxString passConfirm = ''.obs;
  void setPassConfirm(String setPassConfirm) {
    passConfirm.value = setPassConfirm;
    update();
  }

  @override
  void onInit() async {
    await getEmail();
    super.onInit();
  }

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

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

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
      await _loadUserData();
      update();
    });
    isLoading.value = false;
    update();
  }

  Future<void> _loadUserData() async {
    try {
      DocumentSnapshot doc =
          await firestore.collection("users").doc(firebaseUser!.uid).get();

      if (doc.exists) {
        userData.value = doc.data() as Map<String, dynamic>;
      } else {
        // O documento não existe ou está vazio.
        // Você pode decidir o que fazer aqui, por exemplo, definir userData como um Map vazio.
        userData.value = <String, dynamic>{};
      }
    } catch (e) {
      print("Erro ao carregar dados do usuário: $e");
      // Trate o erro conforme necessário.
    }
  }
}
