import 'dart:convert';
import 'dart:developer';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:loginuicolors/firebase_options.dart';
import 'package:loginuicolors/pages/EditEnquiryBySubAdmin.dart';
import 'package:loginuicolors/pages/HomePage.dart';
import 'package:loginuicolors/pages/login.dart';
import 'package:loginuicolors/pages/loginSubadmin.dart';
import 'package:loginuicolors/pages/register.dart';
import 'package:loginuicolors/pages/subAdminHome.dart';
import 'package:loginuicolors/services/firebase_messaging.dart';
import 'package:loginuicolors/services/garagesService.dart';
import 'package:loginuicolors/utils/Globals.dart';

getAllStates() async {
  GaragesService.getAllStates();
}

GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

Future _firebaseBackgroundMessage(RemoteMessage message) async {
  if (message.notification != null) {
    print("Some notification Recieved");
  }
}


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  PushNotifications.init();
  PushNotifications.localNotiInit();

  // Listern to background notifications
  FirebaseMessaging.onBackgroundMessage(_firebaseBackgroundMessage);
  // To handle foreground notifications
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    print("Got a message in foreground");
    if (message.notification != null) {
      String payLoadData = jsonEncode(message.data);
      PushNotifications.showSimpleNotification(
          id: Globals.subAdminId,
          title: message.notification!.title!,
          body: message.notification!.body!,
          payload: payLoadData,
          fcmToken: Globals.subAdminDeviceToken);
    }
  });

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
    navigatorKey: navigatorKey,
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
