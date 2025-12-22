import 'dart:developer';

import 'package:get/get.dart';
import 'package:get/get_connect/http/src/exceptions/exceptions.dart';
import '../constants/storage_key.dart';
import '../http_interface.dart';
import '../storage_interace.dart';

class GetHttpService extends GetxService implements IHttpClient {
  late final IStorage _storage;
  late final GetConnect _http;
  late final String _baseUrl;

  Future<GetHttpService> init(IStorage storage,String baseUrl) async {
    _storage = storage;
    _baseUrl = baseUrl;
    _http = GetConnect(timeout: Duration(seconds: 60));
    return this;
  }
  @override
  Future<dynamic> request(
    ApiMethod method,
    String url, {
    Map<String, String>? headers,
    Map<String, dynamic>? query,
    dynamic body,
    String? contentType,
    Function(double percent)? uploadProgress,
  }) async {
    final token = await _storage.get<String>(StorageKey.token);
    final requestHeaders = {
      if (token != null && token.isNotEmpty) 'Authorization': 'Bearer $token',
      if (headers != null) ...headers,
    };

    final requestContentType = contentType ?? 'application/json';

    if (headers != null) {
      requestHeaders.addAll(headers);
    }
    query ??= {};
    var uri = Uri.parse(url);
    if (uri.host.isEmpty) {
      uri = Uri.parse(_baseUrl + url);
    }

    try {
      // Ghi log request chi tiết trước khi call API
      // log('========> REQUEST: ${method.toString().split('.').last} ${uri.toString()}');
      // log('========> Content-Type: $requestContentType');
      if (headers != null && headers.isNotEmpty) {
        // log('========> Headers: $headers');
      }
      if (query.isNotEmpty) {
        log('========> Query: $query');
      }
      if (body != null) {
        log('========> Body: $body');
      }

      final response = await _http
          .request(
            uri.toString(),
            method.toString().split('.').last,
            body: body,
            headers: requestHeaders,
            query: query,
            contentType: requestContentType,
            uploadProgress: uploadProgress,
          )
          .timeout(const Duration(seconds: 60));

      // log('========> ${method.toString().split('.').last}: ${uri.toString()}');
      // log('Header: $requestHeaders');
      if (body != null) {
        // log('Body: $body');
      }
      log('Query: $query');
      log('========> RESPONSE BODY: ${response.body}');
      log(
          '========> RESPONSE STATUS: ${response.statusCode} ${response.statusText ?? ''}');

      if (response.statusCode != null && response.statusCode! < 400) {
        return response.body;
      } else {
        log(
            '========> CALL API ERROR: ${response.statusCode} | ${response.statusText}');
        log('========> ERROR RESPONSE BODY: ${response.body}');

        // Lấy message từ response body nếu có
        String? errorMessage;
        if (response.body is Map) {
          errorMessage = response.body['message']?.toString();
        }
        
        // Nếu không có message, dùng message mặc định dựa trên status code
        if (errorMessage == null || errorMessage.isEmpty) {
          if (response.statusCode == 401) {
            errorMessage = 'Email hoặc mật khẩu không đúng';
          } else if (response.statusCode == 400) {
            errorMessage = 'Yêu cầu không hợp lệ';
          } else if (response.statusCode == 404) {
            errorMessage = 'Không tìm thấy tài nguyên';
          } else if (response.statusCode == 500) {
            errorMessage = 'Lỗi máy chủ. Vui lòng thử lại sau';
          } else {
            errorMessage = 'Đã xảy ra lỗi. Vui lòng thử lại';
          }
        }
        
        // Throw exception với message
        throw Exception(errorMessage);
      }
    } on GetHttpException catch (e, s) {
      log('========> GetHttpException: ${e.message}');
      log('========> GetHttpException runtimeType: ${e.runtimeType}');
      log('========> GetHttpException stackTrace: $s');
      // Throw với message từ GetHttpException
      final errorMsg = e.message.isNotEmpty ? e.message : 'Đã xảy ra lỗi kết nối';
      throw Exception(errorMsg);
    } catch (e, s) {
      // Ghi log fallback cho mọi loại Exception còn lại (ví dụ: XMLHttpRequest error, lỗi CORS, timeout...)
      log('========> UNEXPECTED HTTP ERROR: $e');
      log('========> UNEXPECTED HTTP ERROR TYPE: ${e.runtimeType}');
      log('========> UNEXPECTED HTTP ERROR STACKTRACE: $s');
      // Nếu exception đã có message, giữ nguyên; nếu không có thì dùng message mặc định
      final errorMsg = e.toString().replaceFirst('Exception: ', '');
      throw Exception(errorMsg.isNotEmpty && errorMsg != 'Exception' 
          ? errorMsg 
          : 'Đã xảy ra lỗi kết nối. Vui lòng kiểm tra internet và thử lại');
    }
  }
}
