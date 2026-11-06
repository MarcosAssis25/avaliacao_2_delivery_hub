import 'package:flutter/material.dart';
import 'pages/dashboard_page.dart';
import 'theme/app_colors.dart';

void main() {
  runApp(const DeliveryHubApp());
}

class DeliveryHubApp extends StatelessWidget {
  const DeliveryHubApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Delivery Hub',
      debugShowCheckedModeBanner: false, //define o fundo padrão das telas.
      //define o tema geral do aplicativo.
      theme: ThemeData(
        useMaterial3: true,

        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.primary,
          primary: AppColors.primary,
          secondary: AppColors.secondary,
          error: AppColors.error,
        ),

        scaffoldBackgroundColor: AppColors.background,

        //define o padrão das barras superiores.
        appBarTheme: const AppBarTheme(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.white,
          centerTitle: false,
        ),
      ),

      home: const DashboardPage(),
    );
  }
}
