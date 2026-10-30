import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:smart_health_app/core/config/app_config.dart';
import 'package:smart_health_app/core/routing/app_router.dart';
import 'package:smart_health_app/core/theme/app_colors.dart';
import 'package:smart_health_app/core/utils/cache_helper.dart';

import 'core/services/service_locator.dart';
import 'firebase_options.dart';

import 'package:firebase_core/firebase_core.dart';

/// Points Auth, Firestore and Storage at the local emulators (task 1.6).
/// Must run before anything uses those services.
Future<void> _connectToEmulators() async {
  const host = AppConfig.emulatorHost;
  await FirebaseAuth.instance.useAuthEmulator(host, 9099);
  FirebaseFirestore.instance.useFirestoreEmulator(host, 8080);
  await FirebaseStorage.instance.useStorageEmulator(host, 9199);
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  if (AppConfig.useEmulator) {
    await _connectToEmulators();
  }
  setupServiceLocator();
  await CacheHelper.init();
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