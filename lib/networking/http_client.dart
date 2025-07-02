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

  Future<dynamic> get(String url, String appToken, {Map<String, String>? headers}) async {
    return _sendRequest(
      () => _client.get(
        Uri.parse(_baseUrl + url),
        headers: _addAuthHeaders(headers, appToken),
      ),
    );
  }

  Future<dynamic> post(
    String url, String appToken, {
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

  Future<dynamic> _sendRequest(
    Future<http.Response> Function() request, {
    bool isUnauth = false,
  }) async {
    dynamic responseJson;
    bool isFromRefreshed = false;
    try {
      responseJson = await request();
      // if (responseJson.statusCode == 401 && _refreshToken != null) {
      //   // Token expired, try to refresh
      //   if (await _refreshTokenIfNeeded()) {
      //     // Retry request with new token
      //     responseJson = await request();
      //   } else {
      //     // Logout if refresh fails
      //     await _logout();
      //     isFromRefreshed = true;
      //   }
      // }
    } on SocketException {
      throw FetchDataException(IPGErrorMessages.noInternetConnection);
    }
    return _response(
      responseJson,
      isUnauth: isUnauth,
      isFromRefreshed: isFromRefreshed,
    );
  }

  // Future<bool> _refreshTokenIfNeeded() async {
  //   if (_isRefreshing || _refreshToken == null) return false;
  //
  //   _isRefreshing = true;
  //   try {
  //     var url = '${_baseUrl}organization/portal/token/refresh/';
  //     final response = await http.post(
  //       Uri.parse(url),
  //       headers: {
  //         'Content-type': 'application/json',
  //         'Accept': 'application/json',
  //       },
  //       body: jsonEncode({'refresh_token': _refreshToken}),
  //     );
  //
  //     if (response.statusCode == 200) {
  //       final data = jsonDecode(response.body);
  //       var authData = data['data'];
  //       _accessToken = authData['access'];
  //       _refreshToken = authData['refresh'];
  //
  //       // Store updated tokens
  //       LocalStorage.getInstance().saveSensitiveDataToLocalStorage(
  //         'accessToken',
  //         _accessToken,
  //       );
  //       LocalStorage.getInstance().saveSensitiveDataToLocalStorage(
  //         'refreshToken',
  //         _refreshToken,
  //       );
  //
  //       _isRefreshing = false;
  //       return true;
  //     }
  //   } catch (e) {
  //     if (kDebugMode) {
  //       print('Token refresh failed: $e');
  //     }
  //   }
  //   _isRefreshing = false;
  //   return false;
  // }

  // _logout() {
  //   _accessToken = null;
  //   _refreshToken = null;
  //   LocalStorage.getInstance().deleteAllSensitiveDataFromLocalStorage();
  // }

  dynamic _response(
    http.Response response, {
    bool isEncrypted = false,
    bool isUnauth = false,
    bool isFromRefreshed = false,
  }) {
    switch (response.statusCode) {
      case 200:
        // if (isEncrypted) {
        //   var data = AESUtil.decrypt(response.body);
        //   var responseData = data;
        //   var responseJson = json.decode(responseData);
        //   if (kDebugMode) {
        //     print(responseJson);
        //   }
        //   return responseJson;
        // } else {
        var utfDecoded = utf8.decode(response.bodyBytes);
        var responseJson = json.decode(utfDecoded);
        if (kDebugMode) {
          print(responseJson);
        }
        return responseJson;
      // }
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
