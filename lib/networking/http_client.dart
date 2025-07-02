import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:ipg_flutter/ipg_config.dart';

import '../resources/strings.dart';
import '../util/custom_exception.dart';

class AuthHttpClient {
  static final AuthHttpClient _authHttpClient = AuthHttpClient.internal();
  final String _baseUrl = IpgConfig.baseUrl;
  final http.Client _client = http.Client();

  factory AuthHttpClient() => _authHttpClient;

  AuthHttpClient.internal();

  Future<dynamic> get(
    String url,
    String appToken, {
    Map<String, String>? headers,
  }) async {
    return _sendRequest(
      () => _client.get(
        Uri.parse(_baseUrl + url),
        headers: _addAuthHeaders(headers, appToken),
      ),
    );
  }

  Future<dynamic> post(
    String url,
    String appToken, {
    Map<String, String>? headers,
    Object? body,
  }) async {
    return _sendRequest(
      () => _client.post(
        Uri.parse(_baseUrl + url),
        headers: _addAuthHeaders(headers, appToken),
        body: jsonEncode(body),
      ),
    );
  }

  Map<String, String> _addAuthHeaders(
    Map<String, String>? headers,
    String appToken,
  ) {
    final Map<String, String> newHeaders = {...?headers};
    newHeaders['Content-type'] = 'application/json';
    newHeaders['Accept'] = 'application/json';
    newHeaders['Authorization'] = appToken;
    return newHeaders;
  }

  Future<dynamic> _sendRequest(Future<http.Response> Function() request) async {
    dynamic responseJson;
    bool isFromRefreshed = false;
    try {
      responseJson = await request();
    } on SocketException {
      throw FetchDataException(IPGErrorMessages.noInternetConnection);
    }
    return _response(responseJson, isFromRefreshed: isFromRefreshed);
  }

  dynamic _response(http.Response response, {bool isFromRefreshed = false}) {
    switch (response.statusCode) {
      case 200:
        var utfDecoded = utf8.decode(response.bodyBytes);
        var responseJson = json.decode(utfDecoded);
        if (kDebugMode) {
          print(responseJson);
        }
        return responseJson;
      case 400:
        final Map<String, dynamic>? jsonResponse = json.decode(response.body);
        dynamic errorMessage = jsonResponse?['message'];
        if (errorMessage != null) {
          throw BadRequestException(errorMessage);
        }
        throw BadRequestException(response.body.toString());
      case 401:
        if (isFromRefreshed) {
          throw RefreshedUnauthorisedException();
        }
        throw UnauthorisedException();
      case 403:
        var responseJson = json.decode(response.body.toString());
        throw UnauthorisedException(responseJson['message']);
      case 500:
        break;
      default:
        throw FetchDataException(
          'Error occurred while Communication with Server with StatusCode : ${response.statusCode}',
        );
    }
  }
}
