import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:loginuicolors/models/cars.dart';
import 'package:loginuicolors/models/category.dart';
import 'package:loginuicolors/models/companies.dart';
import 'package:loginuicolors/models/price.dart';
import 'package:loginuicolors/services/api_services.dart';
import 'package:path/path.dart';
import 'package:async/async.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:loginuicolors/models/statesDecode.dart';
import 'package:loginuicolors/utils/Globals.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GaragesService {
  static const String _baseUrl = '${Globals.restApiUrl}/garages/api';

  static Future<void> signUp(File imageFile, String garageName, String state, String city, String address,
      String mobileNumber, String lat, String lng, String password, BuildContext context) async {
    Uri responseUri = Uri.parse('$_baseUrl/create');
    var stream =
        // ignore: deprecated_member_use
        new http.ByteStream(DelegatingStream.typed(imageFile.openRead()));
    var length = await imageFile.length();
    var request = new http.MultipartRequest("POST", responseUri);
    var multipartFile = new http.MultipartFile('profileImages', stream, length, filename: basename(imageFile.path));
    final data = {
      "garage_name": garageName,
      "state": state,
      "city": city,
      "address": address,
      "mobile_number": mobileNumber,
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
      await prefs.setString('number', mobileNumber);
      Navigator.pushReplacementNamed(context, 'Home');
    });
  }

  static Future<void> signIn(BuildContext context, String mobileNumber, String password) async {
    try {
      ApiServices apiServices = ApiServices(http.Client());

      final result = await apiServices.postMethod(
        body: {"mobile_number": mobileNumber, "password": password},
        endPoint: '/garages/api/signIn',
        parser: (json) {
          // convert it to a list
          return json;
        },
      );

      var decoded = result;
      log(decoded.toString());
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(decoded["message"])));
      if (decoded["success"]) {
        Globals.garageId = decoded["data"]['garage']['id'];
        Globals.garageName = decoded["data"]['garage']['garage_name'];
        var add = decoded["data"]['garage']['address'];
        var state = decoded["data"]['garage']['state'];
        var city = decoded['data']['garage']['city'];
        Globals.garageAddress = '$add,$city,$state';
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('authToken', decoded['data']['token']);
        await prefs.setString('number', mobileNumber);
        await prefs.setBool('garage', true);
        Navigator.pushReplacementNamed(context, 'Home');
      }
    } catch (e) {
      debugPrint("error: ${e.toString()}");
      throw e;
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

  static verifyAuthToken() async {
    var result;
    try {
      final prefs = await SharedPreferences.getInstance();

      String? number = prefs.getString('number');
      log(number.toString());
      if (number == null) return false;
      Uri responseUri = Uri.parse('$_baseUrl/verify');
      http.Response response =
          await http.post(responseUri, body: {'number': number, 'garage': prefs.getBool('garage').toString()});
      var decoded = jsonDecode(response.body);
      log(decoded.toString());
      if (decoded['garage']) {
        Globals.garageId = decoded["data"]['id'];
        Globals.garageName = decoded["data"]['garage_name'];
        var add = decoded["data"]['address'];
        var state = decoded["data"]['state'];
        var city = decoded['data']['city'];
        Globals.garageAddress = '$add,$city,$state';
      } else {
        Globals.subAdminId = decoded["data"]['id'];
        Globals.subAdminMobileNumber = decoded["data"]['mobile_number'];
        Globals.subAdminName = decoded["data"]['name'];
        Globals.subAdminState = decoded["data"]['state'];
      }
      result = decoded;
    } catch (err) {
      log(err.toString());
    }

    return result;
  }

  static void loginSubAdmin(BuildContext context, String mobileNumber, String password) async {
    Uri responseUri = Uri.parse("$_baseUrl/loginSubAdmin");
    http.Response response = await http.post(responseUri, body: {"mobile_number": mobileNumber, "password": password});
    var decoded = jsonDecode(response.body);
    log(decoded.toString());
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(decoded["message"])));
    if (decoded["success"]) {
      Globals.subAdminId = decoded["data"]['SubAdmin']['id'];
      Globals.subAdminMobileNumber = decoded["data"]['SubAdmin']['mobile_number'];
      Globals.subAdminName = decoded["data"]['SubAdmin']['name'];
      Globals.subAdminState = decoded["data"]['SubAdmin']['state'];
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('authToken', decoded['data']['token']);
      await prefs.setString('number', mobileNumber);
      await prefs.setBool('garage', false);
      Navigator.pushReplacementNamed(context, 'HomeSubAdmin');
    }
  }

  static Future<List<Cars>> getAllCars(String company) async {
    try {
      Uri responseUri = Uri.parse('$_baseUrl/cars');
      http.Response response = await http.post(responseUri, body: {'company': company});
      var decoded = jsonDecode(response.body);
      log(decoded.toString());
      List<Cars> cars = [];
      var data = decoded['data'];
      for (var temp in data) {
        Cars newCar = Cars.fromMap(temp);
        cars.add(newCar);
      }
      return cars;
    } catch (e) {
      debugPrint("error: ${e.toString()}");
      return [];
    }
  }

  static Future<List<CategoryItems>> getAllCategory() async {
    try {
      ApiServices apiServices = ApiServices(http.Client());

      final result = await apiServices.getMethod(
        queryParams: "/enquires/api/getCategory",
        parser: (json) {
          // convert it to a list
          return (json['data'] as List)
              // and map each entry to a CategoryItems object
              .map((itemJson) => CategoryItems.fromMap(itemJson))
              .toList();
        },
      );

      return result;
    } catch (e) {
      debugPrint("error: ${e.toString()}");
      return [];
    }
  }

  static Future<List<Price>> getProductPrice({
    required int carId,
    required int categoryId,
    required int garageId,
  }) async {
    try {
      ApiServices apiServices = ApiServices(http.Client());

      final Map<String, dynamic> body = {"car": carId, "category": categoryId, "gID": garageId};

      final result = await apiServices.postMethod(
        body: body,
        endPoint: "/garages/api/productprice",
        parser: (json) {
          // convert it to a list
          return (json['data'] as List)
              // and map each entry to a CategoryItems object
              .map((itemJson) => Price.fromMap(itemJson))
              .toList();
        },
      );

      return result;
    } catch (e) {
      debugPrint("error: ${e.toString()}");
      return [];
    }
  }

  static Future<Map<String, dynamic>> submitProduct({
    required int carId,
    required int categoryId,
    required int garageId,
    required int companyId,
    required int price,
  }) async {
//     {
//   "car_id":326,
//   "category_id":8,
//   "garage_id":86,
//   "company_id":2,
//   "price":3200
// }
    try {
      ApiServices apiServices = ApiServices(http.Client());

      final Map<String, dynamic> body = {
        "car_id": carId,
        "category_id": categoryId,
        "garage_id": garageId,
        "company_id": companyId,
        "price": price
      };

      final result = await apiServices.postMethod(
        body: body,
        endPoint: "/enquires/api/createProductEnquiry",
        parser: (json) {
          // convert it to a list
          return json;
        },
      );

      return result;
    } catch (e) {
      debugPrint("error: ${e.toString()}");
      return {};
    }
  }

  static Future<List<String>> getPrices(int carID, int garageID) async {
    print('Garage ID: $garageID');
    print('Car: $carID');

    try {
      Uri responseUri = Uri.parse('$_baseUrl/price');

      http.Response response =
          await http.post(responseUri, body: {'car': carID.toString(), 'gID': garageID.toString()});
      var decoded = jsonDecode(response.body);
      log(decoded.toString());
      print('Prices list: ${decoded.toString()}');

      if (decoded['data'].length == 0) return [];
      String left = decoded['data'][0]['left_axel_price'].toString();
      String right = decoded['data'][0]['right_axel_price'].toString();
      List<String> prices = [];
      prices.add(left);
      prices.add(right);
      log(prices.toString());
      return prices;
    } catch (e) {
      debugPrint("error: ${e.toString()}");
      return [];
    }
  }
}
