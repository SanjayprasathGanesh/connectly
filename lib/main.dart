import 'package:connectly/auto_routes/app_routes.dart';
import 'package:connectly/controller/get_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'auto_routes/auth_provider.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  GetController().setControllers();
  await Firebase.initializeApp(
      options: const FirebaseOptions(
          apiKey: "AIzaSyDwgXhJzsoCysGkfeSwBEthBLH52LY1fQ0",
          projectId: "connectly-4a402",
          storageBucket: "connectly-4a402.firebasestorage.app",
          messagingSenderId: "119710615742",
          appId: "1:119710615742:android:43bdfb38f3c3a6a3f536ef",
      ));
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  final AuthProvider authProvider = Get.find<AuthProvider>();
  final AppRouter appRouter = AppRouter();
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: appRouter.config(
        reevaluateListenable: authProvider,
      ),
      themeMode: ThemeMode.dark,
      builder: (context, child) => ResponsiveBreakpoints(
        breakpoints: const [
          Breakpoint(start: 0, end: 450, name: MOBILE),
          Breakpoint(start: 451, end: 800, name: TABLET),
          Breakpoint(start: 801, end: 1920, name: DESKTOP),
          Breakpoint(start: 1921, end: double.infinity, name: '4k')
        ],
        child: child!,
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}
