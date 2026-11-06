import 'package:flutter/material.dart';

import '../models/pedido_model.dart';
import '../services/pedidos_service.dart';
import '../utils/pedido_status.dart';
import 'pedido_form_page.dart';

class PedidosPage extends StatefulWidget {
  const PedidosPage({super.key});

  @override
  State<PedidosPage> createState() => _PedidosPageState();
}

class _PedidosPageState extends State<PedidosPage> {
  String? statusSelecionado;

  final List<Map<String, String?>> filtros = [
    {'nome': 'Todos', 'status': null},
    {'nome': 'Pendente', 'status': 'pendente'},
    {'nome': 'Em preparo', 'status': 'em_preparo'},
    {'nome': 'A caminho', 'status': 'a_caminho'},
    {'nome': 'Entregue', 'status': 'entregue'},
    {'nome': 'Cancelado', 'status': 'cancelado'},
  ];

  Future<List<PedidoModel>> carregarPedidos() {
    return PedidosService().listarPedidos(status: statusSelecionado);
  }

  Future<void> alterarStatus(PedidoModel pedido, String novoStatus) async {
    final dados = {
      'id': pedido.id,
      'clienteId': pedido.clienteId,
      'descricao': pedido.descricao,
      'valorTotal': pedido.valorTotal,
      'status': novoStatus,
      'pago': pedido.pago,
      'criadoEm': pedido.criadoEm,
    };

    await PedidosService().editarPedido(pedido.id, dados);

    setState(() {});
  }

  Future<void> excluirPedido(int id) async {
    await PedidosService().excluirPedido(id);

    setState(() {});
  }

  void confirmarExclusao(int id) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Excluir pedido'),
          content: const Text('Tem certeza que deseja excluir este pedido?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () async {
                Navigator.pop(context);
                await excluirPedido(id);
              },
              child: const Text('Excluir'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Pedidos')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const PedidoFormPage()),
          );
        },
        icon: const Icon(Icons.add),
        label: const Text('Novo Pedido'),
      ),

      body: Column(
        children: [
          // Filtros de pedidos
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.all(12),
            child: Row(
              children: filtros.map((filtro) {
                final selecionado = statusSelecionado == filtro['status'];

                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: FilterChip(
                    label: Text(filtro['nome']!),
                    selected: selecionado,
                    onSelected: (valor) {
                      setState(() {
                        statusSelecionado = filtro['status'];
                      });
                    },
                  ),
                );
              }).toList(),
            ),
          ),

          // Lista de pedidos
          Expanded(
            child: FutureBuilder<List<PedidoModel>>(
              future: carregarPedidos(),

              builder: (context, snapshot) {
                // Estado 1: Carregando
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                // Estado 2: Erro
                if (snapshot.hasError) {
                  return const Center(
                    child: Text(
                      'Erro ao carregar os pedidos.',
                      style: TextStyle(fontSize: 16),
                    ),
                  );
                }

                // Estado 3: Lista vazia
                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(
                    child: Text(
                      'Nenhum pedido encontrado.',
                      style: TextStyle(fontSize: 16),
                    ),
                  );
                }

                // Estado 4: Exibir pedidos
                final pedidos = snapshot.data!;

                return ListView.builder(
                  padding: const EdgeInsets.all(12),
                  itemCount: pedidos.length,
                  itemBuilder: (context, index) {
                    final pedido = pedidos[index];

                    return Card(
                      margin: const EdgeInsets.only(bottom: 12),
                      child: ListTile(
                        // Círculo colorido e ícone do status
                        leading: CircleAvatar(
                          backgroundColor: PedidoStatus.obterCor(pedido.status),
                          child: Icon(
                            PedidoStatus.obterIcone(pedido.status),
                            color: Colors.white,
                          ),
                        ),
                        trailing: PopupMenuButton<String>(
                          icon: const Icon(Icons.more_vert),
                          tooltip: 'Opções do pedido',
                          onSelected: (novoStatus) {
                            if (novoStatus == 'excluir') {
                              confirmarExclusao(pedido.id);
                            } else {
                              alterarStatus(pedido, novoStatus);
                            }
                          },
                          itemBuilder: (context) => [
                            const PopupMenuItem(
                              value: 'pendente',
                              child: Text('Pendente'),
                            ),
                            const PopupMenuItem(
                              value: 'em_preparo',
                              child: Text('Em preparo'),
                            ),
                            const PopupMenuItem(
                              value: 'a_caminho',
                              child: Text('A caminho'),
                            ),
                            const PopupMenuItem(
                              value: 'entregue',
                              child: Text('Entregue'),
                            ),
                            const PopupMenuItem(
                              value: 'cancelado',
                              child: Text('Cancelado'),
                            ),
                            const PopupMenuItem(
                              value: 'excluir',
                              child: Text(
                                'Excluir pedido',
                                style: TextStyle(color: Colors.red),
                              ),
                            ),
                          ],
                        ),

                        title: Text(
                          'Pedido #${pedido.id} - R\$ ${pedido.valorTotal.toStringAsFixed(2)}',
                        ),

                        subtitle: Text(
                          '${pedido.descricao}\n'
                          'Cliente ID: ${pedido.clienteId}\n'
                          'Status: ${PedidoStatus.obterNome(pedido.status)}\n'
                          '${pedido.pago ? 'Pago: Sim' : 'Pago: Não'}',
                        ),

                        isThreeLine: true,
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
