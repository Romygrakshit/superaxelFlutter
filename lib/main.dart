import 'package:flutter/material.dart';
import 'package:loginuicolors/HomePage.dart';
import 'package:loginuicolors/pages/login.dart';
import 'package:loginuicolors/pages/register.dart';



void main() {


  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: MyLogin(),
    routes: {
      'register': (context) => MyRegister(),
      'login': (context) => MyLogin(),
      'Home': (context) => HomePage(),
    },
  ));
}
