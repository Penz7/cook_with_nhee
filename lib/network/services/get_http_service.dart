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
    Map<String, String>? query,
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
        // log('========> Query: $query');
      }
      if (body != null) {
        // log('========> Body: $body');
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
      // log('Query: $query');
      // log('========> RESPONSE BODY: ${response.body}');
      // log(
      //     '========> RESPONSE STATUS: ${response.statusCode} ${response.statusText ?? ''}');

      if (response.statusCode != null && response.statusCode! < 400) {
        return response.body;
      } else {
        log(
            '========> CALL API ERROR: ${response.statusCode} | ${response.statusText}');
        log('========> ERROR RESPONSE BODY: ${response.body}');

        if (response.statusCode == 401) {
          throw Exception();
        }
        if (response.body is Map && response.body['message'] != null) {
          throw response.body['message'];
        }
        if (response.statusCode == null ||
            (response.statusText != null &&
                response.statusText!
                    .contains('SocketException: Failed host lookup:'))) {
          throw Exception();
        }
        throw Exception();
      }
    } on GetHttpException catch (e, s) {
      log('========> GetHttpException: ${e.message}');
      log('========> GetHttpException runtimeType: ${e.runtimeType}');
      log('========> GetHttpException stackTrace: $s');
      throw e.message;
    } catch (e, s) {
      // Ghi log fallback cho mọi loại Exception còn lại (ví dụ: XMLHttpRequest error, lỗi CORS, timeout...)
      log('========> UNEXPECTED HTTP ERROR: $e');
      log('========> UNEXPECTED HTTP ERROR TYPE: ${e.runtimeType}');
      log('========> UNEXPECTED HTTP ERROR STACKTRACE: $s');
      throw Exception();
    }
  }
}
