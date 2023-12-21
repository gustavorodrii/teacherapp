class Expense {
  final String? id;
  final String? nomeDespesa;
  final double? valorDespesa;
  final String? dataDespesa;
  final String? tipoDespesa;

  Expense({
    this.nomeDespesa,
    this.valorDespesa,
    this.dataDespesa,
    this.tipoDespesa,
    this.id,
  });

  factory Expense.fromMap(Map<String, dynamic> map) {
    return Expense(
      nomeDespesa: map['nomeDespesa'],
      valorDespesa: map['valorDespesa'],
      dataDespesa: map['dataDespesa'],
      tipoDespesa: map['tipoDespesa'],
      id: map['id'],
    );
  }
}
