import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:teacherapp/model/user_model.dart';

class RegisterController extends GetxController {
  RxBool isLoading = false.obs;
  Rx<Map<String, dynamic>> userData =
      Rx<Map<String, dynamic>>(<String, dynamic>{});
  // TextEditingController emailController = TextEditingController();
  // TextEditingController passwordController = TextEditingController();
  // TextEditingController confirmPasswordController = TextEditingController();
  // TextEditingController nameController = TextEditingController();
  // TextEditingController lastNameController = TextEditingController();
  // TextEditingController phoneController = TextEditingController();
  // TextEditingController birthController = TextEditingController();
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  UserModel? userModel;

  User? firebaseUser;

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

  //birth
  RxString birth = ''.obs;

  void setBirth(String setBirth) {
    birth.value = setBirth;
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
  void onInit() {
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

  // void fetchUserData() async {
  //   await firestore
  //       .collection('users')
  //       .doc(firebaseUser!.uid)
  //       .get()
  //       .then((docUser) async {});
  // }

  void signOut() async {
    await FirebaseAuth.instance.signOut();
  }
}
