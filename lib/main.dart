import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import'package:agenda_de_contatos/pages/PaginaLogin.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
      primarySwatch: Colors.amber,
      brightness: Brightness.light,
      scaffoldBackgroundColor: Colors.grey[200],
    ),
    home: PaginaLogin(),
  ));
}

