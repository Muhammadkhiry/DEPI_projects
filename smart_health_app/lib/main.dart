import 'package:flutter/material.dart';
import 'package:smart_health_app/core/routing/app_router.dart';
import 'package:smart_health_app/core/theme/app_colors.dart';
import 'core/services/service_locator.dart';
import 'firebase_options.dart';  
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  setupServiceLocator();
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
