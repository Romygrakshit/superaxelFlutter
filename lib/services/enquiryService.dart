import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:loginuicolors/models/pastEnquiry.dart';
import 'package:loginuicolors/utils/Globals.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';
import 'package:http_parser/http_parser.dart';

class EnquiryService {
  static const String _baseUrl = '${Globals.restApiUrl}/enquires/api';

  static Future<List<PastEnquiry>> pastEnquiryList(int garageId) async {
    List<PastEnquiry> dedcodedEnq = [];

    try {
      Uri responseUri = Uri.parse("$_baseUrl/list/${garageId}");
      http.Response response = await http.get(responseUri);
      Map decoded = jsonDecode(response.body);
      log(decoded.toString());
      var enquiries = decoded["data"];
      for (var enq in enquiries) {
        PastEnquiry newenq = PastEnquiry.fromMap(enq);
        dedcodedEnq.add(newenq);
      }
    } catch (e) {
      log(e.toString());
    }
    return dedcodedEnq;
  }

  static void createEnquiry(
      List<File> _image,
      String address,
      String lat,
      String lng,
      String company,
      String car_name,
      String axel,
      String offered_price,
      BuildContext context) async {
    var uri = Uri.parse('$_baseUrl/create');
    http.MultipartRequest request = new http.MultipartRequest('POST', uri);

    request.headers['Content-Type'] = "multipart/form-data";

    request.fields['garage_id'] = Globals.garageId.toString();
    request.fields['address'] = address;
    request.fields['lat'] = lat;
    request.fields['lng'] = lng;
    request.fields['state'] = "Rajasthan";
    request.fields['company'] = company;
    request.fields['car_name'] = car_name;
    request.fields['axel'] = axel;
    request.fields['offered_price'] = offered_price;

    log(request.fields.toString());
    print('enquiry request data: ${request.fields.toString()}');

    for (var i = 0; i < _image.length; i++) {
      String extension = _image[i].path.split('.').last.toLowerCase();
      if (extension == 'jpg' || extension == 'jpeg' || extension == 'png') {
        request.files.add(http.MultipartFile(
            'enquiryImages',
            File(_image[i].path).readAsBytes().asStream(),
            File(_image[i].path).lengthSync(),
            filename: basename(_image[i].path.split("/").last),
            contentType: MediaType('image', extension)));
      }
    }

    print('enquiry request files: ${request.files.toString()}');

    try {
      var response = await request.send();
      response.stream.transform(utf8.decoder).listen((value) async {
        log(value);
        var decoded = jsonDecode(value);
        log(decoded.toString());
        if (decoded['success']) {
          ScaffoldMessenger.of(context).hideCurrentSnackBar();
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text("Enquiry Created")));
          Navigator.pushReplacementNamed(context, 'Home');
        }
      });
    } catch (e) {
      print('Error sending enquiry request: $e');
    }
  }
}
