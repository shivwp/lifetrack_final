import 'dart:io';

// ApiResponse:-----------------------------------------------------------
class ApiResponse<T> {
  ApiCallState? apiCallState;
  T? data;
  String? message;

  ApiResponse.loading() : apiCallState = ApiCallState.loading;

  ApiResponse.success(this.data) : apiCallState = ApiCallState.success;

  ApiResponse.error(this.message) : apiCallState = ApiCallState.error;

  @override
  String toString() {
    return "ApiCallState : $apiCallState \n Message : $message \n Data : $data";
  }
}

// ApiCallState:-----------------------------------------------------------
enum ApiCallState { loading, success, error }

// ApiType:-----------------------------------------------------------
enum ApiType { get, getWithQuery, post, put, delete, multipart }

// ApiCallRequest:-----------------------------------------------------------
Map<String, dynamic> apiCallRequest(
    {required String url,
    required ApiType apiType,
    Map<String, String>? queryParams,
    Map<String, dynamic>? request,
    File? file}) {
  return {
    'apiType': apiType,
    'url': url,
    'request': request,
    'queryParams': queryParams,
    'file': file,
  };
}
