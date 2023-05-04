import 'package:flutter/material.dart';
import 'package:loginuicolors/HomePage.dart';
import 'package:loginuicolors/pages/login.dart';
import 'package:loginuicolors/pages/register.dart';
import 'package:loginuicolors/services/garagesService.dart';

getAllStates() async {
  GaragesService.getAllStates();
}

void main() {
  getAllStates();

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
