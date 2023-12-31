import 'package:cloud_firestore/cloud_firestore.dart';

import 'expense_model.dart';

class UserModel {
  UserModel({
    required email,
    required name,
    required lastName,
    required phone,
    required registrationDate,
    this.latestExpenseTimestamp,
  });
  String? email;
  String? name;
  String? lastName;
  String? phone;
  Timestamp? registrationDate;
  Timestamp? latestExpenseTimestamp;

  UserModel.fromJson(Map<String, dynamic>? data) {
    email = data?['email'] as String?;
    name = data?['name'] as String?;
    lastName = data?['lastName'] as String?;
    phone = data?['phone'] as String?;
    registrationDate = data?['registrationDate'] as Timestamp?;
  }

  Map<String, dynamic> toMap() {
    return {
      "email": email,
      "name": name,
      "lastName": lastName,
      "phone": phone,
      "registrationDate": registrationDate,
      "latestExpenseTimestamp": latestExpenseTimestamp,
    };
  }

  @override
  String toString() {
    return 'UserModel{email: $email, name: $name, lastName: $lastName, phone: $phone, registrationDate: $registrationDate}';
  }

  // factory UserModel.fromSnapshot(
  //     DocumentSnapshot<Map<String, dynamic>> document) {
  //   final dataUser = document.data()!;
  //   return UserModel(
  //     email: dataUser['email'],
  //     name: dataUser['name'],
  //     lastName: dataUser['lastName'],
  //     phone: dataUser['phone'],
  //     registrationDate: dataUser['registrationDate'],
  //   );
  // }
}
