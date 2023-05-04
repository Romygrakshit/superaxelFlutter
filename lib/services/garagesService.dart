import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:path/path.dart';
import 'package:async/async.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:loginuicolors/models/statesDecode.dart';
import 'package:loginuicolors/utils/Globals.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GaragesService {
  static const String _baseUrl = '${Globals.restApiUrl}/garages/api';

  static Future<void> signUp(
      File imageFile,
      String garage_name,
      String state,
      String city,
      String address,
      String mobile_number,
      String lat,
      String lng,
      String password,
      BuildContext context) async {
    Uri responseUri = Uri.parse('$_baseUrl/create');
    // http.Response response = await http.post(responseUri, body: {
    //   garage_name,
    //   state,
    //   city,
    //   address,
    //   mobile_number,
    //   lat,
    //   lng,
    //   password
    // });
    // Map decoded = jsonDecode(response.body);
    // log(decoded.toString());
    var stream =
        new http.ByteStream(DelegatingStream.typed(imageFile.openRead()));
    var length = await imageFile.length();
    var request = new http.MultipartRequest("POST", responseUri);
    var multipartFile = new http.MultipartFile('profileImages', stream, length,
        filename: basename(imageFile.path));
    final data = {
      "garage_name": garage_name,
      "state": state,
      "city": city,
      "address": address,
      "mobile_number": mobile_number,
      "lat": lat,
      "lng": lng,
      "password": password
    };
    request.fields.addAll(data);
    request.files.add(multipartFile);

    // send
    var response = await request.send();

    // listen for response
    response.stream.transform(utf8.decoder).listen((value) {
      log(value);
      Navigator.pushReplacementNamed(context, 'Home'); 
    });
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

  static void getAllStates() async {
    Uri responseUri = Uri.parse("$_baseUrl/states");
    http.Response response = await http.get(responseUri);
    var decoded = jsonDecode(response.body);
    log(decoded.toString());
    List<StateDecode> allStates = [];
    if (decoded["success"]) {
      var states = decoded['data'];
      for (var state in states) {
        StateDecode newState = StateDecode.fromMap(state);
        allStates.add(newState);
      }
      Globals.allStates = allStates;
    }
  }
}
