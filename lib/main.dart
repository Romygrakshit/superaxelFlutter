import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:loginuicolors/HomePage.dart';
import 'package:loginuicolors/pages/location.dart';
import 'package:loginuicolors/pages/login.dart';
import 'package:loginuicolors/pages/register.dart';
import 'package:loginuicolors/services/garagesService.dart';

getAllStates() async {
  GaragesService.getAllStates();
}

void main() {
  WidgetsFlutterBinding.ensureInitialized(); 
  getAllStates();

  Future<Widget> verifyToken() async {
    log('verifying');
    bool isVerified = await GaragesService.verifyAuthToken();
    if (isVerified) {
      return const HomePage();
    } else {
      return const MyLogin();
    }
  }

  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: 
     FutureBuilder<Widget>(
      future: verifyToken(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Material(
            child: Center(
              child: CircularProgressIndicator(),
            ),
          );
        } else {
          return snapshot.data ?? const MyLogin();
        }
      },
    )
    ,
    routes: {
      'register': (context) => MyRegister(),
      'login': (context) => MyLogin(),
      'Home': (context) => HomePage(),
      // 'location':(context) => Location(),
    },
  ));
}
