import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

import 'package:loginuicolors/utils/Globals.dart';

class ApiServices {
  final Client client;

  ApiServices(this.client);

  final String url = Globals.restApiUrl;

  Future<T> _sendRequest<T>({
    required String endPoint,
    required String method,
    dynamic body,
    required T Function(dynamic) parser,
    Map<String, String>? headers,
  }) async {
    try {
      final dynamicUrl = url + endPoint;
      final request = Request(method, Uri.parse(dynamicUrl))
        ..headers.addAll(headers ?? {'Content-Type': 'application/json'});

      if (body != null) {
        request.body = jsonEncode(body);
      }

      final response = await client.send(request);

      final responseString = await response.stream.bytesToString();

      if (response.statusCode == 200) {
        return parser(jsonDecode(responseString));
      } else {
        debugPrint("Error: ${response.statusCode}");
        throw Exception("Failed to perform $method request");
      }
    } on SocketException {
      debugPrint("Error: No internet connection");
      throw Exception("No internet connection");
    } catch (e) {
      debugPrint("Error: $e");
      throw Exception("Failed to perform $method request");
    }
  }

  Future<T> getMethod<T>({
    String queryParams = '',
    required T Function(dynamic) parser,
    Map<String, String>? headers,
  }) async {
    return await _sendRequest(
      endPoint: queryParams,
      method: 'GET',
      parser: parser,
      headers: headers,
    );
  }

  Future<T> postMethod<T>({
    String endPoint = '',
    dynamic body,
    required T Function(dynamic) parser,
    Map<String, String>? headers,
  }) async {
    return await _sendRequest(
      endPoint: endPoint,
      method: 'POST',
      body: body,
      parser: parser,
      headers: headers,
    );
  }

  Future<T> putMethod<T>({
    String endPoint = '',
    dynamic body,
    required T Function(dynamic) parser,
    Map<String, String>? headers,
  }) async {
    return await _sendRequest(
      endPoint: endPoint,
      method: 'PUT',
      body: body,
      parser: parser,
      headers: headers,
    );
  }

  Future<T> deleteMethod<T>({
    String endPoint = '',
    required T Function(dynamic) parser,
    Map<String, String>? headers,
  }) async {
    return await _sendRequest(
      endPoint: endPoint,
      method: 'DELETE',
      parser: parser,
      headers: headers,
    );
  }

  Future<T> uploadFile<T>({
    required String endPoint,
    required File file,
    required T Function(dynamic) parser,
    Map<String, String>? headers,
  }) async {
    final multipartRequest = MultipartRequest(
      'POST',
      Uri.parse(url + endPoint),
    );

    if (headers != null) {
      multipartRequest.headers.addAll(headers);
    }

    multipartRequest.files.add(
      MultipartFile(
        'file',
        File(file.path).readAsBytes().asStream(),
        File(file.path).lengthSync(),
      ),
    );

    final response = await client.send(multipartRequest);

    final responseString = await response.stream.bytesToString();

    if (response.statusCode == 200) {
      return parser(jsonDecode(responseString));
    } else {
      debugPrint("Error: ${response.statusCode}");
      throw Exception("Failed to upload file");
    }
  }
}
