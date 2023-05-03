import 'dart:convert';
import 'dart:developer';
import 'package:loginuicolors/models/pastEnquiry.dart';
import 'package:loginuicolors/utils/Globals.dart';
import 'package:http/http.dart' as http;

class EnquiryService {
  static const String _baseUrl = '${Globals.restApiUrl}/enquires/api';

  static Future<List<PastEnquiry>> pastEnquiryList() async {
    Uri responseUri = Uri.parse("$_baseUrl/list");
    http.Response response = await http.get(responseUri);
    Map decoded = jsonDecode(response.body);
    log(decoded.toString());
    var enquiries = decoded["data"];
    List<PastEnquiry> dedcodedEnq = [];
    for (var enq in enquiries) {
      PastEnquiry newenq = PastEnquiry.fromMap(enq);
      dedcodedEnq.add(newenq);
    }
    return dedcodedEnq;
  }
}
