import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:loginuicolors/models/cars.dart';
import 'package:loginuicolors/models/companies.dart';
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
    var stream =
        // ignore: deprecated_member_use
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
    response.stream.transform(utf8.decoder).listen((value) async {
      log(value);
      var decoded = jsonDecode(value);
      Globals.garageId = decoded["data"]['garage']['id'];
      Globals.garageName = decoded["data"]['garage']['garage_name'];
      var add = decoded["data"]['garage']['address'];
      var state = decoded["data"]['garage']['state'];
      var city = decoded['data']['garage']['city'];
      Globals.garageAddress = '$add,$city,$state';
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('authToken', decoded['data']['token']);
      await prefs.setString('number', mobile_number);
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
      Globals.garageId = decoded["data"]['garage']['id'];
      Globals.garageName = decoded["data"]['garage']['garage_name'];
      var add = decoded["data"]['garage']['address'];
      var state = decoded["data"]['garage']['state'];
      var city = decoded['data']['garage']['city'];
      Globals.garageAddress = '$add,$city,$state';
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('authToken', decoded['data']['token']);
      await prefs.setString('number', mobile_number);
      Navigator.pushReplacementNamed(context, 'Home');
    }
  }

  static void getAllStates() async {
    Uri responseUri = Uri.parse("$_baseUrl/states");
    http.Response response = await http.get(responseUri);
    var decoded = jsonDecode(response.body);
    log(decoded.toString());
    List<StateDecode> allStates = [];
    if (decoded["success"]) {
      var states = decoded['data']['states'];
      for (var state in states) {
        StateDecode newState = StateDecode.fromMap(state);
        allStates.add(newState);
      }
      var cars = decoded['data']['cars'];
      List<Cars> allCars = [];
      List<Companies> allCompanies = [];
      var companies = decoded['data']['companies'];
      for (var car in cars) {
        Cars newCar = Cars.fromMap(car);
        allCars.add(newCar);
      }
      for (var company in companies) {
        Companies newCompany = Companies.fromMap(company);
        allCompanies.add(newCompany);
      }
      Globals.allCars = allCars;
      Globals.allCompanies = allCompanies;
      Globals.allStates = allStates;
    }
  }

  static Future<bool> verifyAuthToken() async {
    var result = null;
    try {
      log('called verify auth');
      final prefs = await SharedPreferences.getInstance();
      log('getting number');
      String? number = await prefs.getString('number');
      log(number.toString());
      if (number == null) return false;
      Uri responseUri = Uri.parse('$_baseUrl/verify');
      http.Response response =
          await http.post(responseUri, body: {'number': number});
      var decoded = jsonDecode(response.body);
      log(decoded.toString());
      Globals.garageId = decoded["data"]['id'];
      Globals.garageName = decoded["data"]['garage_name'];
      var add = decoded["data"]['address'];
      var state = decoded["data"]['state'];
      var city = decoded['data']['city'];
      Globals.garageAddress = '$add,$city,$state';
      result = decoded['success'];
    } catch (err) {
      log(err.toString());
    }

    return result;
  }
}
