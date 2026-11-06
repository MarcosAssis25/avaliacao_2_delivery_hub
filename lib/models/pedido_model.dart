
class PedidoModel {
  final int id;
  final int clienteId;
  final String descricao;
  final double valorTotal;
  final String status;
  final bool pago;
  final String? criadoEm;

  PedidoModel({
    required this.id,
    required this.clienteId,
    required this.descricao,
    required this.valorTotal,
    required this.status,
    required this.pago,
    this.criadoEm,
  });

  factory PedidoModel.fromMap(Map<String, dynamic> map) {
    return PedidoModel(
      id: map['id'],
      clienteId: map['clienteId'],
      descricao: map['descricao'],
      valorTotal: (map['valorTotal'] as num).toDouble(),
      status: map['status'],
      pago: map['pago'],
      criadoEm: map['criadoEm'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'clienteId': clienteId,
      'descricao': descricao,
      'valorTotal': valorTotal,
      'status': status,
      'pago': pago,
      'criadoEm': criadoEm,
    };
  }
}
