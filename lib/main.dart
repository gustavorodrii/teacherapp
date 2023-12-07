import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:teacherapp/auth/auth_page.dart';
import 'package:teacherapp/firebase_options.dart';
import 'package:teacherapp/utils/custom_colors.dart';

import 'controller/user_controller.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(
    const MyApp(),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(UserController());
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        appBarTheme: const AppBarTheme(
          systemOverlayStyle: SystemUiOverlayStyle(
            statusBarBrightness: Brightness.dark,
          ),
        ),
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: lowBlue,
        ),
        primaryColor: lowBlue,
        hoverColor: lowBlue,
        colorScheme: ThemeData().colorScheme.copyWith(
              primary: lowBlue,
            ),
      ),
      home: AuthPage(),
    );
  }
}
