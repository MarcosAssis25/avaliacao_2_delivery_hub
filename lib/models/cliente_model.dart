
class ClienteModel {
  final int id;
  final String nome;
  final String telefone;
  final String endereco;

  ClienteModel({
    required this.id,
    required this.nome,
    required this.telefone,
    required this.endereco,
  });

  factory ClienteModel.fromMap(Map<String, dynamic> map) {
    return ClienteModel(
      id: map['id'],
      nome: map['nome'],
      telefone: map['telefone'],
      endereco: map['endereco'],
    );
  }
}
