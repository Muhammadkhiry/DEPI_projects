import 'package:flutter/material.dart';

import 'core/routing/app_router.dart';
import 'core/theme/app_colors.dart';

void main() {
  runApp(const SmartHealthApp());
}

class SmartHealthApp extends StatelessWidget {
  const SmartHealthApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Smart Health',
      debugShowCheckedModeBanner: false,
      routerConfig: appRouter,
      theme: ThemeData(
        scaffoldBackgroundColor: AppColors.neutralBg,
        primaryColor: AppColors.primary,
        fontFamily: 'Plus Jakarta Sans',
        useMaterial3: true,
      ),
    );
  }
}
