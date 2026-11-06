
import 'package:dio/dio.dart';

import '../api/api_config.dart';
import '../models/pedido_model.dart';

class PedidosService {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: ApiConfig.baseUrl,
    ),
  );

  Future<List<PedidoModel>> listarPedidos({
    String? status,
  }) async {
    final resposta = await _dio.get(
      '/pedidos',
      queryParameters: status == null
          ? null
          : {'status': status},
    );

    final List dados = resposta.data;

    return dados.map((pedido) {
      return PedidoModel.fromMap(pedido);
    }).toList();
  }

  Future<void> cadastrarPedido(
    Map<String, dynamic> dados,
  ) async {
    await _dio.post(
      '/pedidos',
      data: dados,
    );
  }

  Future<void> editarPedido(
    int id,
    Map<String, dynamic> dados,
  ) async {
    await _dio.put(
      '/pedidos/$id',
      data: dados,
    );
  }

  Future<void> excluirPedido(int id) async {
    await _dio.delete('/pedidos/$id');
  }
}
