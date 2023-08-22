import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:loginuicolors/pages/EditEnquiryBySubAdmin.dart';
import 'package:loginuicolors/pages/HomePage.dart';
import 'package:loginuicolors/pages/login.dart';
import 'package:loginuicolors/pages/loginSubadmin.dart';
import 'package:loginuicolors/pages/register.dart';
import 'package:loginuicolors/pages/subAdminHome.dart';
import 'package:loginuicolors/services/garagesService.dart';

getAllStates() async {
  GaragesService.getAllStates();
}

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  getAllStates();

  Future<Widget> verifyToken() async {
    var decoded = await GaragesService.verifyAuthToken();

    if (decoded == false) {
      log('creating login page');
      return MyLogin();
    }

    if (decoded['success']) {
      if (decoded['garage']) {
        log("creating home page");
        return const HomePage();
      } else {
        log('creating admin home');
        return SubAdminHome();
      }
    }

    return MyLogin();
  }

  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: FutureBuilder<Widget>(
      future: verifyToken(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Material(
            child: Center(
              child: CircularProgressIndicator(),
            ),
          );
        } else {
          return snapshot.data ?? MyLogin();
        }
      },
    ),
    routes: {
      'register': (context) => MyRegister(),
      'login': (context) => MyLogin(),
      'Home': (context) => HomePage(),
      'loginSubAdmin': (context) => LoginSubAdmin(),
      'HomeSubAdmin': (context) => SubAdminHome(),
      'EditEnqSubAdmin': (context) => EditEnqSubAdmin(),
      // 'location':(context) => Location(),
    },
  ));
}
