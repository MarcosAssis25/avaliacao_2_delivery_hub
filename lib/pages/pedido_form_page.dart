import 'package:flutter/material.dart';
import '../models/cliente_model.dart';
import '../services/clientes_service.dart';
import '../services/pedidos_service.dart';

class PedidoFormPage extends StatefulWidget {
  const PedidoFormPage({super.key});

  @override
  State<PedidoFormPage> createState() => _PedidoFormPageState();
}

class _PedidoFormPageState extends State<PedidoFormPage> {
  Future<List<ClienteModel>> carregarClientes() {
    return ClientesService().listarClientes();
  }

  int? clienteSelecionado;
  String statusSelecionado = 'pendente';
  bool pago = false;

  final _formKey = GlobalKey<FormState>();

  final TextEditingController descricaoController = TextEditingController();
  final TextEditingController valorController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Novo Pedido')),

      body: Padding(
        padding: const EdgeInsets.all(16),
        child: FutureBuilder<List<ClienteModel>>(
          future: carregarClientes(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return const Center(child: Text('Erro ao carregar os clientes.'));
            }

            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text('Nenhum cliente encontrado.'));
            }

            final clientes = snapshot.data!;

            return Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  DropdownButtonFormField<int>(
                    value: clienteSelecionado,
                    decoration: const InputDecoration(
                      labelText: 'Selecione o cliente',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.person),
                    ),
                    hint: const Text('Escolha um cliente'),
                    items: clientes.map((cliente) {
                      return DropdownMenuItem<int>(
                        value: cliente.id,
                        child: Text(cliente.nome),
                      );
                    }).toList(),
                    onChanged: (valor) {
                      setState(() {
                        clienteSelecionado = valor;
                      });
                    },
                  ),

                  const SizedBox(height: 16),

                  TextFormField(
                    controller: descricaoController,
                    validator: (valor) {
                      if (valor == null || valor.trim().isEmpty) {
                        return 'Informe a descrição do pedido';
                      }
                      return null;
                    },
                    decoration: const InputDecoration(
                      labelText: 'Descrição do pedido',
                      hintText: 'Ex.: 1x Pizza Grande, 1x Refrigerante',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.description),
                    ),
                    maxLines: 3,
                  ),
                  const SizedBox(height: 16),

                  TextFormField(
                    controller: valorController,
                    validator: (valor) {
                      final numero = double.tryParse(
                        (valor ?? '').replaceAll(',', '.'),
                      );

                      if (numero == null || numero <= 0) {
                        return 'Informe um valor maior que zero';
                      }

                      return null;
                    },
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    decoration: const InputDecoration(
                      labelText: 'Valor total',
                      hintText: 'Ex.: 78.50',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.attach_money),
                    ),
                  ),
                  const SizedBox(height: 16),
                  SwitchListTile(
                    title: const Text('Pedido pago?'),
                    subtitle: Text(pago ? 'Sim, já foi pago' : 'Não foi pago'),
                    secondary: const Icon(Icons.payment),
                    value: pago,
                    onChanged: (valor) {
                      setState(() {
                        pago = valor;
                      });
                    },
                  ),
                  const SizedBox(height: 16),

                  ElevatedButton.icon(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        final dados = {
                          'clienteId': clienteSelecionado,
                          'descricao': descricaoController.text.trim(),
                          'valorTotal': double.parse(
                            valorController.text.replaceAll(',', '.'),
                          ),
                          'status': statusSelecionado,
                          'pago': pago,
                          'criadoEm': DateTime.now().toIso8601String(),
                        };

                        try {
                          await PedidosService().cadastrarPedido(dados);

                          if (!mounted) return;

                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Pedido cadastrado com sucesso!'),
                            ),
                          );

                          Navigator.pop(context, true);
                        } catch (e) {
                          if (!mounted) return;

                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Erro ao cadastrar pedido.'),
                            ),
                          );
                        }
                      }
                    },
                    icon: const Icon(Icons.save),
                    label: const Text('Salvar Pedido'),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
