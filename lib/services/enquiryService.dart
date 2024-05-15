import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:loginuicolors/models/pastEnquiry.dart';
import 'package:loginuicolors/services/firebase_messaging.dart';
import 'package:loginuicolors/utils/Globals.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';
import 'package:http_parser/http_parser.dart';

class EnquiryService {
  static const String _baseUrl = '${Globals.restApiUrl}/enquires/api';
  static final _firebaseMessaging = FirebaseMessaging.instance;

  static Future<List<PastEnquiry>> pastEnquiryList(int garageId) async {
    List<PastEnquiry> dedcodedEnq = [];

    try {
      final token = await _firebaseMessaging.getToken();
      log("$token", name: "Garage Device Token");
      Globals.garageFcmtoken = token!;
      Uri responseUri = Uri.parse("$_baseUrl/list/$garageId");
      http.Response response = await http.get(responseUri);
      final decoded = jsonDecode(response.body);
      log(decoded.toString(), name: "api response");
      var enquiries = decoded["data"];
      dedcodedEnq = [];
      for (var enq in enquiries) {
        PastEnquiry newenq = PastEnquiry.fromMap(enq);
        dedcodedEnq.add(newenq);
      }
      return dedcodedEnq;
    } catch (e) {
      log(e.toString());
      return [];
    }
  }

  static void createEnquiry(
      List<File> _image,
      String address,
      String lat,
      String lng,
      String company,
      String carName,
      String axel,
      String offeredPrice,
      BuildContext context) async {
    PushNotifications pushNotification = PushNotifications();

    var uri = Uri.parse('$_baseUrl/create');
    http.MultipartRequest request = http.MultipartRequest('POST', uri);

    // request.headers['Content-Type'] = "multipart/form-data";

    request.fields['garage_id'] = Globals.garageId.toString();
    request.fields['address'] = address;
    request.fields['lat'] = lat;
    request.fields['lng'] = lng;
    // request.fields['state'] = "Rajasthan";
    request.fields['company'] = company;
    request.fields['car_name'] = carName;
    request.fields['axel'] = axel;
    request.fields['offered_price'] = offeredPrice;
    // request.fields['fcmToken'] = Globals.garageFcmtoken;

    log(request.fields.toString(), name: "enquiry request data:");
    // print('enquiry request data: ${request.fields.toString()}');

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
    log(request.files.toString(), name: "enquiry request files:");
    // print('enquiry request files: ${request.files.toString()}');

    try {
      var response = await request.send();
      response.stream.transform(utf8.decoder).listen((value) async {
        log(value);
        var decoded = jsonDecode(value);
        print(decoded);
        if (response.statusCode == 200) {
          pushNotification.getDeviceToken().then((value) async {
            var data = {
              'to': value,
              'priority': 'high',
              'notification': {
                'title': 'New Enquiry',
                'body': '${Globals.garageName}',
              },
            };
            await http.post(Uri.parse('https://fcm.googleapis.com/fcm/send'),
                body: jsonEncode(data),
                headers: {
                  'Content-Type': 'application/json; charset=UTF-8',
                  'Authorization':
                      'key=AAAAp4Lx0M8:APA91bEfrvJmS8721wom0MdZd6H6tw9zHnZwISQAMhY_Kd6VhDq20nCS5DX9Q8ONMcKx1IdEdHyAer5eg5taSnUqBIFHZC_2lwqer0VltONmpyHjpnyA3z2TvBepgIXEdkSuBinu-E95'
                });
          });
          showDialog(
            context: context,
            builder: (context) => toastMsg(context, "Enquiry Created"),
          );
        }
      });
    } catch (e) {
      print('Error sending enquiry request: $e');
      showDialog(
        context: context,
        builder: (context) {
          return toastMsg(context, "$e");
        },
      );
    }
  }

  // create enquiry when user not select any Image
  static void createEnquiryWithoutImage(
      String address,
      String lat,
      String lng,
      String company,
      String carName,
      String axel,
      String offeredPrice,
      BuildContext context) async {
    PushNotifications pushNotification = PushNotifications();
    try {
      final response = await http.post(Uri.parse('$_baseUrl/create'), body: {
        "garage_id": Globals.garageId.toString(),
        "address": address,
        "lat": lat,
        "lng": lng,
        "company": company,
        "car_name": carName,
        "axel": axel,
        "offered_price": offeredPrice,
      });

      var decoded = jsonDecode(response.body);
      print(decoded);
      if (response.statusCode == 200) {
        pushNotification.getDeviceToken().then((value) async {
          var data = {
            'to': value,
            'priority': 'high',
            'notification': {
              'title': 'New Enquiry',
              'body': '${Globals.garageName}',
            },
          };
          await http.post(Uri.parse('https://fcm.googleapis.com/fcm/send'),
              body: jsonEncode(data),
              headers: {
                'Content-Type': 'application/json; charset=UTF-8',
                'Authorization':
                    'key=AAAAp4Lx0M8:APA91bEfrvJmS8721wom0MdZd6H6tw9zHnZwISQAMhY_Kd6VhDq20nCS5DX9Q8ONMcKx1IdEdHyAer5eg5taSnUqBIFHZC_2lwqer0VltONmpyHjpnyA3z2TvBepgIXEdkSuBinu-E95'
              });
        });
        showDialog(
          context: context,
          builder: (context) => toastMsg(context, "Enquiry Created"),
        );
      }
    } catch (e) {
      print('Error sending enquiry request: $e');
      showDialog(
        context: context,
        builder: (context) {
          return toastMsg(context, "$e");
        },
      );
    }
  }
}

Widget toastMsg(context, String text) {
  return Center(
    child: Container(
      height: MediaQuery.of(context).size.height * 0.14,
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.symmetric(horizontal: 50),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Colors.white,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            text,
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.w500),
          ),
          TextButton(
              onPressed: () {
                // Navigator.pushReplacementNamed(context, 'Home');
                Navigator.pop(context);
              },
              child: Text(
                "Ok",
                // textAlign: TextAlign.center,
                style: TextStyle(color: Colors.blue[700]),
              ))
        ],
      ),
    ),
  );
}
