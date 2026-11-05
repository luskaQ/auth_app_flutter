import 'package:apk_auth_firebase/theme/app_theme.dart';
import 'package:apk_auth_firebase/view/auth_page.dart';
import 'package:apk_auth_firebase/view/home_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'firebase_options.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(MaterialApp(home: const AuthPage(), debugShowCheckedModeBanner: false, theme: AppTheme.dark,));
}