import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:loginuicolors/utils/Globals.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GaragesService {
  static const String _baseUrl = '${Globals.restApiUrl}/garages/api';

  static void signUp(
      String garage_name,
      String state,
      String city,
      String address,
      String mobile_number,
      String lat,
      String lng,
      String password) async {
    Uri responseUri = Uri.parse('$_baseUrl/create');
    http.Response response = await http.post(responseUri, body: {
      garage_name,
      state,
      city,
      address,
      mobile_number,
      lat,
      lng,
      password
    });
    Map decoded = jsonDecode(response.body);
    log(decoded.toString());
  }

  static void signIn(
      BuildContext context, String mobile_number, String password) async {
    Uri responseUri = Uri.parse("$_baseUrl/signIn");
    http.Response response = await http.post(responseUri,
        body: {"mobile_number": mobile_number, "password": password});
    var decoded = jsonDecode(response.body);
    log(decoded.toString());
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(decoded["message"])));
    if (decoded["success"]) {
      Navigator.pushReplacementNamed(context, 'Home');
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('authToken', decoded['data']['token']);
    } 
  }
}
 