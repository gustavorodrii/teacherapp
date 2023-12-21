import 'package:cloud_firestore/cloud_firestore.dart';

class Expense {
  final String? id;
  final String? nomeDespesa;
  final double? valorDespesa;
  final String? dataDespesa;
  final String? tipoDespesa;
  final String? image;
  final String? descriptionAttach;
  final String? kindOfDoc;
  final Timestamp? timestamp;

  Expense({
    this.id,
    this.nomeDespesa,
    this.valorDespesa,
    this.dataDespesa,
    this.tipoDespesa,
    this.image,
    this.descriptionAttach,
    this.kindOfDoc,
    this.timestamp,
  });

  factory Expense.fromMap(Map<String, dynamic> map) {
    return Expense(
      nomeDespesa: map['nomeDespesa'],
      valorDespesa: map['valorDespesa'],
      dataDespesa: map['dataDespesa'],
      tipoDespesa: map['tipoDespesa'],
      id: map['id'],
      image: map['image'],
      descriptionAttach: map['descriptionAttach'],
      kindOfDoc: map['kindOfDoc'],
      timestamp: map['timestamp'],
    );
  }
}
