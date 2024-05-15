import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:loginuicolors/models/enquriyModel.dart';
import 'package:loginuicolors/models/product_subadmin.dart';
import 'package:loginuicolors/services/api_services.dart';
import 'package:loginuicolors/utils/Globals.dart';
import 'package:http/http.dart' as http;

class SubAdminService {
  static const String _baseUrl = '${Globals.restApiUrl}/subadmins/api';

  static createInventory(
      String carname,
      String subadminId,
      String leftAxelPrice,
      String leftAxelInventory,
      String rightAxelPrice,
      String rightAxelInventory,
      BuildContext context) async {
    Uri responseUri = Uri.parse('$_baseUrl/createInventory');
    http.Response response = await http.post(responseUri, body: {
      'car_name': carname,
      'subAdmin_id': subadminId,
      'left_axel_price': leftAxelPrice,
      'left_axel_inventory': leftAxelInventory,
      'right_axel_price': rightAxelPrice,
      'right_axel_inventory': rightAxelInventory
    });
    var decoded = jsonDecode(response.body);
    log(decoded.toString());
    if (decoded['success']) {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Created the new Inventory')));
    }
  }

  static Future<List<Enquiry>> getEnqbyState(String subAdminId) async {
    try {
      List<Enquiry> dedcodedEnq = [];
      Uri responseUri = Uri.parse('$_baseUrl/getEnqbyState');
      final response = await http.post(
        responseUri,
        body: {'sID': subAdminId},
      );
      var decoded = jsonDecode(response.body);
      log(response.body);
      var enquiries = decoded["data"];
      for (var enq in enquiries) {
        Enquiry newenq = Enquiry.fromMap(enq);
        dedcodedEnq.add(newenq);
      }
      // log("$dedcodedEnq");
      return dedcodedEnq;
    } catch (e) {
      debugPrint("error is $e");
      return [];
    }
  }

  static Future updateEnquiry({Object? body}) async {
    Uri responseUri = Uri.parse('$_baseUrl/updateEnq');
    http.Response response = await http.post(responseUri, body: body);
    var decoded = jsonDecode(response.body);
    log(decoded.toString());
    log(response.statusCode.toString());
    if (response.statusCode >= 200 || response.statusCode <= 300) {
      log(response.body);
      return true;
    } else {
      return false;
    }
  }

  static Future<List<ProductSUbadmin>> getProductEnquiryListSubAdmin(
      int subadminId) async {
    try {
      ApiServices apiServices = ApiServices(http.Client());

      final result = await apiServices.postMethod(
        body: {"sID": subadminId},
        endPoint: '/subadmins/api/getProductEnqbyState',
        parser: (json) {
          // convert it to a list
          return json;
        },
      );

      var decoded = result;

      debugPrint(decoded.toString());

      var productEnquiryList = decoded["data"];

      List<ProductSUbadmin> productEnquiryListSubAdmin = [];

      for (var productEnquiry in productEnquiryList) {
        ProductSUbadmin newProductEnquiry =
            ProductSUbadmin.fromMap(productEnquiry);
        productEnquiryListSubAdmin.add(newProductEnquiry);
      }

      return productEnquiryListSubAdmin;
    } catch (e) {
      debugPrint("error is $e");
      return [];
    }
  }

  static getInventry(int carId, context) async {
    try {
      final response = await http
          .post(Uri.parse("$_baseUrl/getInventoryDetails"), body: {
        "car_id": carId.toString(),
        "subadmin_id": Globals.subAdminId.toString()
      });
      var decoded = jsonDecode(response.body);
      if (response.statusCode == 200) {
        debugPrint(response.body);
        if (decoded["data"].isEmpty) {
          Globals.leftAxlePrice = "0";
          Globals.rightAxlePrice = "0";
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("No Inventry added by SubAdmin")));
        } else {
          Globals.leftAxlePrice = decoded["data"][0]["left_axel_price"];
          Globals.rightAxlePrice = decoded["data"][0]["right_axel_price"];
        }
      }
    } catch (e) {
      debugPrint("error in inventry api $e");
    }
  }
}
