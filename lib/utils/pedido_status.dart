import 'package:flutter/material.dart';

class PedidoStatus {
  static Color obterCor(String status) {
    switch (status) {
      case 'pendente':
        return Colors.orange;

      case 'em_preparo':
        return Colors.blue;

      case 'a_caminho':
        return Colors.purple;

      case 'entregue':
        return Colors.green;

      case 'cancelado':
        return Colors.red;

      default:
        return Colors.grey;
    }
  }

  static IconData obterIcone(String status) {
    switch (status) {
      case 'pendente':
        return Icons.schedule;

      case 'em_preparo':
        return Icons.soup_kitchen;

      case 'a_caminho':
        return Icons.delivery_dining;

      case 'entregue':
        return Icons.check_circle;

      case 'cancelado':
        return Icons.cancel;

      default:
        return Icons.help_outline;
    }
  }

  static String obterNome(String status) {
    switch (status) {
      case 'pendente':
        return 'Pendente';

      case 'em_preparo':
        return 'Em preparo';

      case 'a_caminho':
        return 'A caminho';

      case 'entregue':
        return 'Entregue';

      case 'cancelado':
        return 'Cancelado';

      default:
        return 'Desconhecido';
    }
  }
}
