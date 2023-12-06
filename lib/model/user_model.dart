import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  UserModel();
  String? email;
  String? name;
  String? lastName;
  String? phone;
  Timestamp? registrationDate;

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
    };
  }

  @override
  String toString() {
    return 'UserModel{email: $email, name: $name, lastName: $lastName, phone: $phone, registrationDate: $registrationDate}';
  }
}
