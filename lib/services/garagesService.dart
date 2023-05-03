import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;
import 'package:loginuicolors/utils/Globals.dart';

class GaragesService{
  static const String _baseUrl = '${Globals.restApiUrl}/enquires/api/';

   static void pastEnquiryList() async {
    Uri responseUri = Uri.parse("http://localhost:3000/enquires/api/list");
    http.Response response = await http.get(responseUri);
    Map decoded = jsonDecode(response.body);
    log(decoded.toString());
  }
}