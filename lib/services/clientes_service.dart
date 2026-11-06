
import 'package:dio/dio.dart';

import '../api/api_config.dart';
import '../models/cliente_model.dart';

class ClientesService {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: ApiConfig.baseUrl,
    ),
  );

  Future<List<ClienteModel>> listarClientes() async {
    final resposta = await _dio.get('/clientes');

    final List dados = resposta.data;

    return dados.map((cliente) {
      return ClienteModel.fromMap(cliente);
    }).toList();
  }
}
