import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';
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
  static final _firebaseMessaging = FirebaseMessaging.instance;

  Future<void> signUp(
      File imageFile,
      String garageName,
      String state,
      String city,
      String address,
      String mobileNumber,
      String lat,
      String lng,
      String password,
      BuildContext context) async {
    try {
      Uri responseUri = Uri.parse('$_baseUrl/create');
      var stream =
          http.ByteStream(DelegatingStream.typed(imageFile.openRead()));
      var length = await imageFile.length();
      var request = new http.MultipartRequest("POST", responseUri);
      var multipartFile = new http.MultipartFile(
          'profileImages', stream, length,
          filename: basename(imageFile.path));
      request.fields.addAll({
        "garage_name": garageName,
        "state": state,
        "city": city,
        "address": address,
        "mobile_number": mobileNumber,
        "lat": lat,
        "lng": lng,
        "password": password
      });
      request.files.add(multipartFile);
      // send
      var response = await request.send();
      // check the response
      if (response.statusCode == 200) {
        // Parse the response
        var responseData = await response.stream.bytesToString();
        var decodedData = jsonDecode(responseData);

        // Handle successful response
        Globals.garageId = decodedData["data"]['garage']['id'];
        Globals.garageName = decodedData["data"]['garage']['garage_name'];
        var add = decodedData["data"]['garage']['address'];
        var state = decodedData["data"]['garage']['state'];
        var city = decodedData['data']['garage']['city'];
        Globals.garageAddress = '$add,$city,$state';
        // Save data in SharedPreferences
        final prefs = await SharedPreferences.getInstance();
        String imageUrl = decodedData["data"]["garage"]["url"];
        String modifiedUrl = imageUrl.replaceAll(RegExp(r'.*?/img'), '/img');
        await prefs.setString('url', modifiedUrl);
        await prefs.setString('authToken', decodedData['data']['token']);
        await prefs.setString('number', mobileNumber);

        // Get fcm token and call api
        final token = await _firebaseMessaging.getToken();
        log("$token", name: "Garage Device Token");
        String id = "${Globals.garageId}";
        garageFCMToken(context, id, token!);

        // Navigate to Home screen
        Navigator.pushReplacementNamed(context, 'Home');
      } else {
        // Handle error response
        throw ('Error: ${response.statusCode}');
      }
    } catch (e) {
      // Handle exceptions
      log('Error during sign up: $e');
      throw e;
    }
  }

  Future<void> signIn(
      BuildContext context, String mobileNumber, String password) async {
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
      if (decoded["success"] == true) {
        log(decoded.toString(), name: "Garage login response: ");
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        //save data in variables
        Globals.garageId = decoded["data"]['garage']['id'];
        Globals.garageName = decoded["data"]['garage']['garage_name'];
        var add = decoded["data"]['garage']['address'];
        var state = decoded["data"]['garage']['state'];
        var city = decoded['data']['garage']['city'];
        Globals.garageAddress = '$add,$city,$state';
        final prefs = await SharedPreferences.getInstance();
        String originalUrl = decoded["data"]["garage"]["url"];
        String modifiedUrl = originalUrl.replaceAll(RegExp(r'.*?/img'), '/img');
        await prefs.setString('authToken', decoded['data']['token']);
        await prefs.setString('number', mobileNumber);
        await prefs.setString('url', modifiedUrl); // Use the modified URL here
        await prefs.setBool('garage', true);

        // save device fcm Token of garage and call api
        final token = await _firebaseMessaging.getToken();
        log("$token", name: "Garage Device Token");
        String id = "${Globals.garageId}";
        garageFCMToken(context, id, token!);

        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(decoded["message"])));
        Navigator.pushReplacementNamed(context, 'Home');
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(decoded["message"])));
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

  // all cities api code
Future<List<String>>getAllCities(int stateIndex) async {
    Uri responseUri =
        Uri.parse("${Globals.restApiUrl}/garages/get-cities/$stateIndex");
    http.Response response = await http.get(responseUri);
    var decoded = jsonDecode(response.body);
    log(decoded.toString());
    List<String> allCities = [];
    if (decoded["cities"].toString().isNotEmpty) {
      for (var state in decoded["cities"]) {
        allCities.add(state["city"]);
      }
      print(allCities);
      // Globals.allCity = allCities;
    }
    return allCities;
  }

  static verifyAuthToken() async {
    var result;
    try {
      final prefs = await SharedPreferences.getInstance();

      String? number = prefs.getString('number');
      log(number.toString());
      if (number == null) return false;
      Uri responseUri = Uri.parse('$_baseUrl/verify');
      http.Response response = await http.post(responseUri, body: {
        'number': number,
        'garage': prefs.getBool('garage').toString()
      });
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

  Future<void> loginSubAdmin(
      BuildContext context, String mobileNumber, String password) async {
    try {
      Uri responseUri = Uri.parse("$_baseUrl/loginSubAdmin");
      http.Response response = await http.post(responseUri,
          body: {"mobile_number": mobileNumber, "password": password});
      var decoded = jsonDecode(response.body);
      if (decoded["success"] == true) {
        log(decoded.toString());
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        //save data in varables
        Globals.subAdminId = decoded["data"]['SubAdmin']['id'];
        Globals.subAdminMobileNumber =
            decoded["data"]['SubAdmin']['mobile_number'];
        Globals.subAdminName = decoded["data"]['SubAdmin']['name'];
        Globals.subAdminState = decoded["data"]['SubAdmin']['state'];
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('authToken', decoded['data']['token']);
        await prefs.setString('number', mobileNumber);
        await prefs.setBool('garage', false);
        // Get the user fcm Token and call the api
        final adtoken = await _firebaseMessaging.getToken();
        String id = "${Globals.subAdminId}";
        subAdminFCMToken(context, id, adtoken!);
        log("${adtoken}", name: "Sub Admin Device Token"); //print fcm token
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(decoded["message"])));
        Navigator.pushReplacementNamed(context, 'HomeSubAdmin');
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(decoded["message"])));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("$e")));
    }
  }

  Future<void> subAdminFCMToken(context, String id, String fcmToken) async {
    try {
      final response = await http.post(
          Uri.parse("http://139.59.77.55:3000/subadmins/api/updateFCMToken"),
          body: {
            'id': id,
            'fcmToken': fcmToken,
          });
      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        log("SubAdmin FCM api: $jsonResponse");
        if (jsonResponse["success"] == true) {
          // ScaffoldMessenger.of(context)
          //     .showSnackBar(SnackBar(content: Text("FCM Token Update")));
        } else {
          log("fjlksdjfksdjfl", name: 'fcm false');
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("$e")));
    }
  }

  Future<void> garageFCMToken(context, String id, String fcmToken) async {
    try {
      final response = await http.post(
          Uri.parse("http://139.59.77.55:3000/garages/api/updateFCMToken"),
          body: {
            'id': id,
            'fcmToken': fcmToken,
          });
      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        log("Garage FCM api: $jsonResponse");
        if (jsonResponse["success"] == true) {
          // ScaffoldMessenger.of(context)
          //     .showSnackBar(SnackBar(content: Text("FCM Token Update")));
        } else {
          log("fjlksdjfksdjfl", name: 'fcm false');
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("$e")));
    }
  }

  static Future<List<Cars>> getAllCars(String company) async {
    try {
      Uri responseUri = Uri.parse('$_baseUrl/cars');
      http.Response response =
          await http.post(responseUri, body: {'company': company});
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

      final Map<String, dynamic> body = {
        "car": carId,
        "category": categoryId,
        "gID": garageId
      };

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
    required String lat,
    required String long,
    required String address,
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
        "price": price,
        "lat": lat,
        "long": long,
        "address": address,
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

      http.Response response = await http.post(responseUri,
          body: {'car': carID.toString(), 'gID': garageID.toString()});
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
