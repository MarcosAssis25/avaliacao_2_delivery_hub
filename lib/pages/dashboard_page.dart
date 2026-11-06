import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import 'pedidos_page.dart';
import 'widgets/summary_card.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Delivery Hub',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),

        actions: [
          IconButton(
            icon: const Icon(Icons.receipt_long),
            tooltip: 'Ver pedidos',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const PedidosPage()),
              );
            },
          ),
        ],
      ),

      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Painel Principal',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),

              const SizedBox(height: 8),

              const Text(
                'Acompanhe seus pedidos em um só lugar.',
                style: TextStyle(fontSize: 14, color: AppColors.textSecondary),
              ),

              const SizedBox(height: 24),

              GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 1.5,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),

                children: const [
                  SummaryCard(
                    title: 'Total de pedidos',
                    value: '4',
                    icon: Icons.receipt_long,
                    color: AppColors.primary,
                  ),

                  SummaryCard(
                    title: 'Pendentes',
                    value: '1',
                    icon: Icons.schedule,
                    color: AppColors.secondary,
                  ),

                  SummaryCard(
                    title: 'Em andamento',
                    value: '2',
                    icon: Icons.delivery_dining,
                    color: AppColors.primary,
                  ),

                  SummaryCard(
                    title: 'Entregues',
                    value: '1',
                    icon: Icons.check_circle,
                    color: AppColors.success,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
