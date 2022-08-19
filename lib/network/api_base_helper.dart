import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:life_track/network/shared_pref/shared_preference_helper.dart';

import 'api_config.dart';
import 'api_msg_strings.dart';
import 'api_response.dart';
import 'app_exception.dart';
import 'connectivity.dart';

class ApiBaseHelper {
  static const String _baseUrl = ApiConfig.baseUrlDev;

  static ApiBaseHelper? _instance;

  ApiBaseHelper._internal();

  factory ApiBaseHelper.getInstance() {
    _instance ??= ApiBaseHelper._internal();
    return _instance!;
  }

  // ApiHeaders:--------------------------------get/set api headers---------------------------------------
  Map<String, String> getApiHeaders(String? authToken) {
    if (kDebugMode) log('Api authToken-> $authToken');
    return {
      'Content-Type': 'application/json; charset=UTF-8',
      'accept': 'text/plain',
      'Authorization': 'Bearer $authToken',
    };
  }

// Get:--------------------------------get api call with query params---------------------------------------
  Future<ApiResponse?> getApiCallWithQuery(
      String url, Map<String, String> queryParameters) async {
    var authToken = 'authToken';
    var uri = Uri.parse(_baseUrl + url);
    uri = uri.replace(queryParameters: queryParameters);
    if (kDebugMode) log('Api Get with params, url $uri');
    final response = await safeApiCall(http.get(
      uri,
      headers: getApiHeaders(authToken),
    ));
    return response;
  }

// Get:-----------------------------------------------------------------------
  Future<ApiResponse?> get(String url) async {
    if (kDebugMode) log('Api Get, url $url');
    var authToken = await SharedPreferenceHelper.getInstance().apiToken;
    final response = await safeApiCall(http.get(
      Uri.parse(_baseUrl + url),
      headers: getApiHeaders(authToken),
    ));
    return response;
  }

// Post:-----------------------------------------------------------------------
  Future<ApiResponse?> post(String url, Map<String, dynamic> jsonData) async {
    if (kDebugMode) log('Api Post, url $url');
    if (kDebugMode) log('Api request- ${jsonEncode(jsonData)}');
    var authToken = await SharedPreferenceHelper.getInstance().apiToken;
    final response = safeApiCall(http.post(Uri.parse(_baseUrl + url),
        headers: getApiHeaders(authToken), body: jsonEncode(jsonData)));
    return response;
  }

// Put:-----------------------------------------------------------------------
  Future<ApiResponse?> put(String url, Map<String, dynamic> jsonData) async {
    if (kDebugMode) log('Api Put, url $url');
    if (kDebugMode) log('Api request- ${jsonEncode(jsonData)}');
    var authToken = 'authToken';
    final response = safeApiCall(http.put(Uri.parse(_baseUrl + url),
        headers: getApiHeaders(authToken), body: jsonEncode(jsonData)));
    return response;
  }

// Delete:------------------------------------------------------
  Future<ApiResponse?> delete(String url) async {
    if (kDebugMode) log('Api delete, url $url');
    var authToken = 'authToken';
    final response = safeApiCall(http.delete(
      Uri.parse(_baseUrl + url),
      headers: getApiHeaders(authToken),
    ));
    return response;
  }

// Post multipart file to server with json data:----------------------
  Future<ApiResponse?> postApiCallMultipart(String url,
      Map<String, String> jsonData, String? fieldName, File file) async {
    var authToken = await SharedPreferenceHelper.getInstance().apiToken;
    var request = http.MultipartRequest('POST', Uri.parse(_baseUrl + url));
    request.headers.addAll(getApiHeaders(authToken));
    request.fields.addAll(jsonData);
    request.files.add(
      http.MultipartFile(
        fieldName ?? 'file',
        http.ByteStream(Stream.castFrom(file.openRead())),
        await file.length(),
        filename: file.path.split('/').last,
      ),
    );
    if (kDebugMode) log('Api Post, url $url');
    if (kDebugMode) log('Api request- ${jsonEncode(jsonData)}');
    if (kDebugMode) log('Api header- ${request.headers}');
    var response = safeApiCall(http.Response.fromStream(await request.send()));
    return response;
  }

// SafeApiCall:--------------------------------safe api call---------------------------------------
  Future<ApiResponse?> safeApiCall(Future<http.Response> apiResponse) async {
    if (await ConnectionStatus.getInstance().checkConnection()) {
      try {
        final response = await apiResponse.timeout(const Duration(seconds: 60));
        return ApiResponse.success(_returnResponse(response));
      } on BadRequestException {
        return ApiResponse.error(ApiMsgStrings.txtInvalidRequest);
      } on UnauthorisedException {
        return ApiResponse.error(ApiMsgStrings.txtUnauthorised);
      } on FetchDataException {
        return ApiResponse.error(ApiMsgStrings.txtUnauthorised);
      } on TimeoutException {
        return ApiResponse.error(ApiMsgStrings.txtConnectionTimeOut);
      } on SocketException {
        return ApiResponse.error(ApiMsgStrings.txtNoInternetConnection);
      } catch (e) {
        return ApiResponse.error(e.toString());
      }
    } else {
      return ApiResponse.error(ApiMsgStrings.txtNoInternetConnection);
    }
  }
}

dynamic _returnResponse(http.Response response) {
  switch (response.statusCode) {
    case 200:
      var responseJson = json.decode(utf8.decode(response.bodyBytes));
      if (kDebugMode) log(responseJson.toString());
      return responseJson;
    case 400:
      throw BadRequestException(response.body.toString());
    case 401:
    case 403:
      throw UnauthorisedException(response.body.toString());
    case 500:
    default:
      throw FetchDataException(
          '${ApiMsgStrings.txtServerError} ${response.statusCode}');
  }
}
