import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:split_money/app/core/network/network_constents.dart';
import 'package:split_money/app/core/state/app_state.dart';

/// Standardized API Response wrapper
class ApiResult<T> {
  final bool success;
  final int status;
  final String message;
  final T? data;
  final dynamic raw;

  ApiResult({
    required this.success,
    required this.status,
    required this.message,
    this.data,
    this.raw,
  });

  factory ApiResult.success(
    T data, {
    String message = 'Success',
    int status = 1,
    dynamic raw,
  }) {
    return ApiResult(
      success: true,
      status: status,
      message: message,
      data: data,
      raw: raw,
    );
  }

  factory ApiResult.error(String message, {int status = 0, dynamic raw}) {
    return ApiResult(
      success: false,
      status: status,
      message: message,
      raw: raw,
    );
  }
}

/// Content type for API requests
enum ContentType { json, formUrlEncoded, multipart }

/// Base API Service with CRUD operations and centralized error handling
class BaseApiService {
  static const String _logTag = '🌐 API';
  static const int _timeoutSeconds = 30;
  static const int _maxRetries = 3;

  final String baseUrl;
  final Future<String?> Function()? tokenProvider;

  /// [tokenProvider] is a callback that returns the current auth token (if any).
  /// Example: () async => await SecureStorage.getToken();
  BaseApiService({
    this.baseUrl = NetworkConstantsUtil.baseUrl,
    this.tokenProvider,
  });

  // ============================================================================
  // CRUD OPERATIONS
  // ============================================================================

  /// CREATE - POST Request
  Future<ApiResult<T>> create<T>(
    String endpoint, {
    Map<String, dynamic>? body,
    Map<String, File>? files,
    ContentType contentType = ContentType.json,
    T Function(dynamic)? parser,
  }) async {
    _logRequest('CREATE (POST)', endpoint, body: body);

    return _executeWithRetry(() async {
      final uri = Uri.parse('$baseUrl$endpoint');

      if (contentType == ContentType.multipart || files != null) {
        return _sendMultipartRequest(uri, body, files, parser);
      } else {
        return _sendRequest(
          'POST',
          uri,
          body: body,
          contentType: contentType,
          parser: parser,
        );
      }
    });
  }

  /// READ - GET Request
  Future<ApiResult<T>> read<T>(
    String endpoint, {
    Map<String, String>? queryParams,
    T Function(dynamic)? parser,
  }) async {
    var uri = Uri.parse('$baseUrl$endpoint');
    if (queryParams != null && queryParams.isNotEmpty) {
      uri = uri.replace(queryParameters: queryParams);
    }

    _logRequest('READ (GET)', uri.toString());

    return _executeWithRetry(() async {
      final headers = await _buildHeaders();
      final response = await http
          .get(uri, headers: headers)
          .timeout(const Duration(seconds: _timeoutSeconds));

      return _handleResponse(response, parser);
    });
  }

  /// UPDATE - PUT Request
  Future<ApiResult<T>> update<T>(
    String endpoint, {
    Map<String, dynamic>? body,
    Map<String, File>? files,
    ContentType contentType = ContentType.json,
    T Function(dynamic)? parser,
  }) async {
    _logRequest('UPDATE (PUT)', endpoint, body: body);

    return _executeWithRetry(() async {
      final uri = Uri.parse('$baseUrl$endpoint');

      if (contentType == ContentType.multipart || files != null) {
        return _sendMultipartRequest(uri, body, files, parser, method: 'PUT');
      } else {
        return _sendRequest(
          'PUT',
          uri,
          body: body,
          contentType: contentType,
          parser: parser,
        );
      }
    });
  }

  /// DELETE - DELETE Request
  Future<ApiResult<T>> delete<T>(
    String endpoint, {
    Map<String, dynamic>? body,
    T Function(dynamic)? parser,
  }) async {
    _logRequest('DELETE', endpoint, body: body);

    return _executeWithRetry(() async {
      final uri = Uri.parse('$baseUrl$endpoint');

      return _sendRequest(
        'DELETE',
        uri,
        body: body,
        contentType: ContentType.json,
        parser: parser,
      );
    });
  }

  // ============================================================================
  // HELPER METHODS
  // ============================================================================

  /// Send HTTP request with specified method and content type
  Future<ApiResult<T>> _sendRequest<T>(
    String method,
    Uri uri, {
    Map<String, dynamic>? body,
    ContentType contentType = ContentType.json,
    T Function(dynamic)? parser,
  }) async {
    final headers = await _buildHeaders(contentType: contentType);
    dynamic requestBody;

    // Prepare request body based on content type
    if (body != null) {
      switch (contentType) {
        case ContentType.json:
          requestBody = jsonEncode(body);
          break;
        case ContentType.formUrlEncoded:
          requestBody = body.map(
            (key, value) => MapEntry(key, value.toString()),
          );
          break;
        case ContentType.multipart:
          // Handled separately in _sendMultipartRequest
          break;
      }
    }

    http.Response response;

    switch (method.toUpperCase()) {
      case 'GET':
        response = await http
            .get(uri, headers: headers)
            .timeout(const Duration(seconds: _timeoutSeconds));
        break;
      case 'POST':
        response = await http
            .post(uri, headers: headers, body: requestBody)
            .timeout(const Duration(seconds: _timeoutSeconds));
        break;
      case 'PUT':
        response = await http
            .put(uri, headers: headers, body: requestBody)
            .timeout(const Duration(seconds: _timeoutSeconds));
        break;
      case 'DELETE':
        response = await http
            .delete(uri, headers: headers, body: requestBody)
            .timeout(const Duration(seconds: _timeoutSeconds));
        break;
      default:
        throw UnsupportedError('HTTP method $method not supported');
    }

    return _handleResponse(response, parser);
  }

  /// Send multipart request (for file uploads)
  Future<ApiResult<T>> _sendMultipartRequest<T>(
    Uri uri,
    Map<String, dynamic>? fields,
    Map<String, File>? files,
    T Function(dynamic)? parser, {
    String method = 'POST',
  }) async {
    final request = http.MultipartRequest(method, uri);

    // Add headers (without Content-Type, MultipartRequest sets it automatically)
    final headers = await _buildHeaders();
    headers.remove('Content-Type');
    request.headers.addAll(headers);

    // Add fields
    if (fields != null) {
      request.fields.addAll(
        fields.map((key, value) => MapEntry(key, value.toString())),
      );
    }

    // Add files
    if (files != null) {
      for (var entry in files.entries) {
        final file = entry.value;
        if (await file.exists()) {
          request.files.add(
            await http.MultipartFile.fromPath(entry.key, file.path),
          );
          _log('📎 File attached: ${entry.key} -> ${file.path}');
        } else {
          _log('⚠️ File not found: ${file.path}', isError: true);
        }
      }
    }

    final streamedResponse = await request.send().timeout(
      const Duration(seconds: _timeoutSeconds),
    );
    final response = await http.Response.fromStream(streamedResponse);

    return _handleResponse(response, parser);
  }

  /// Build headers for API requests
  Future<Map<String, String>> _buildHeaders({
    ContentType? contentType,
    Map<String, String>? additionalHeaders,
  }) async {
    final headers = <String, String>{};

    // Add Authorization token if available
    String? token;
    if (tokenProvider != null) {
      try {
        token = await tokenProvider!();
      } catch (e) {
        _log('⚠️ Token provider error: $e', isError: true);
      }
    }
    if (token != null && token.isNotEmpty) {
      headers['Authorization'] = 'Bearer $token';
    }

    // Add Content-Type based on request type
    if (contentType != null) {
      switch (contentType) {
        case ContentType.json:
          headers['Content-Type'] = 'application/json';
          break;
        case ContentType.formUrlEncoded:
          headers['Content-Type'] = 'application/x-www-form-urlencoded';
          break;
        case ContentType.multipart:
          // Don't set Content-Type for multipart, http package handles it
          break;
      }
    }

    // Add any additional headers
    if (additionalHeaders != null) {
      headers.addAll(additionalHeaders);
    }

    return headers;
  }

  /// Handle API response and parse it
  ApiResult<T> _handleResponse<T>(
    http.Response response,
    T Function(dynamic)? parser,
  ) {
    final statusCode = response.statusCode;
    _logResponse(statusCode, response.body);

    try {
      // Handle empty response
      if (response.body.isEmpty) {
        return ApiResult.error(
          'Empty response from server',
          status: statusCode,
        );
      }

      final dynamic decoded = jsonDecode(response.body);

      // Check if response has status field
      final bool hasStatus =
          decoded is Map<String, dynamic> && decoded.containsKey('status');

      final int apiStatus = hasStatus ? (decoded['status'] ?? 0) : 1;
      final String message = hasStatus
          ? (decoded['message'] ?? decoded['msg'] ?? 'No message')
          : '';

      // Success case (status == 1)
      if (apiStatus == 1) {
        final dynamic rawData = hasStatus
            ? (decoded.containsKey('data') ? decoded['data'] : decoded)
            : decoded;

        final parsedData = parser != null ? parser(rawData) : rawData as T;

        _log('✅ Success: $message');
        return ApiResult.success(
          parsedData,
          message: message,
          status: apiStatus,
          raw: decoded,
        );
      } else {
        // Error case (status != 1)
        final errorMsg = message.isNotEmpty ? message : 'Request failed';
        _log('❌ API Error: $errorMsg (status: $apiStatus)', isError: true);
        return ApiResult.error(errorMsg, status: apiStatus, raw: decoded);
      }
    } catch (e, stackTrace) {
      _log('❌ JSON parsing error: $e', isError: true);
      _log('Stack trace: $stackTrace', isError: true);
      return ApiResult.error('Failed to parse response: ${e.toString()}');
    }
  }

  /// Check internet connectivity
  Future<bool> _isConnected() async {
    try {
      final connectivityResult = await Connectivity().checkConnectivity();
      return connectivityResult != ConnectivityResult.none;
    } catch (e) {
      _log('⚠️ Connectivity check failed: $e', isError: true);
      return false;
    }
  }

  /// Execute request with retry logic
  Future<ApiResult<T>> _executeWithRetry<T>(
    Future<ApiResult<T>> Function() request,
  ) async {
    // Check if app is in critical error state
    if (AppState.instance.hasCriticalError) {
      _log('⛔ Critical error state - blocking API call', isError: true);
      return ApiResult.error(
        'App is in error state. Please retry.',
        status: -1,
      );
    }

    // Check connectivity
    final isConnected = await _isConnected();
    if (!isConnected) {
      const errorMsg = 'No internet connection';
      _handleCriticalError(errorMsg, errorType: 'offline');
      return ApiResult.error(errorMsg, status: -1);
    }

    int attempts = 0;

    while (attempts < _maxRetries) {
      try {
        attempts++;
        _log('🔄 Attempt $attempts of $_maxRetries');

        final result = await request();

        // If failed and max retries reached, handle critical error
        if (!result.success && attempts >= _maxRetries) {
          _handleCriticalError(
            result.message.isNotEmpty ? result.message : 'Request failed',
            errorType: 'server',
          );
        }

        return result;
      } on SocketException catch (e) {
        _log('❌ SocketException: $e', isError: true);
        if (attempts >= _maxRetries) {
          const errorMsg = 'No internet connection';
          _handleCriticalError(errorMsg, errorType: 'offline');
          return ApiResult.error(errorMsg, status: -1);
        }
        await Future.delayed(Duration(seconds: attempts * 2));
      } on TimeoutException catch (e) {
        _log('❌ TimeoutException: $e', isError: true);
        if (attempts >= _maxRetries) {
          const errorMsg = 'Request timed out';
          _handleCriticalError(errorMsg, errorType: 'timeout');
          return ApiResult.error(errorMsg, status: -1);
        }
        await Future.delayed(Duration(seconds: attempts * 2));
      } on FormatException catch (e, stackTrace) {
        _log('❌ FormatException: $e', isError: true);
        _log('Stack trace: $stackTrace', isError: true);
        const errorMsg = 'Invalid server response';
        _handleCriticalError(errorMsg, errorType: 'server');
        return ApiResult.error(errorMsg, status: -1);
      } catch (e, stackTrace) {
        _log('❌ Unexpected error: $e', isError: true);
        _log('Stack trace: $stackTrace', isError: true);
        if (attempts >= _maxRetries) {
          const errorMsg = 'Something went wrong';
          _handleCriticalError(errorMsg, errorType: 'error');
          return ApiResult.error(errorMsg, status: -1);
        }
        await Future.delayed(Duration(seconds: attempts * 2));
      }
    }

    const errorMsg = 'Max retry attempts exceeded';
    _handleCriticalError(errorMsg, errorType: 'error');
    return ApiResult.error(errorMsg, status: -1);
  }

  /// Handle critical errors
  static void _handleCriticalError(
    String message, {
    String errorType = 'error',
  }) {
    final isFirstError = AppState.instance.setCriticalError();

    if (!isFirstError) {
      _log('⚠️ Critical error already handled, skipping duplicate');
      return;
    }

    _log('🚨 CRITICAL ERROR [$errorType]: $message', isError: true);

    // Navigate to error screen if needed
    // Get.to(() => ApiFailureScreen(
    //   message: message,
    //   errorType: errorType,
    // ), preventDuplicates: true);
  }

  // ============================================================================
  // LOGGING
  // ============================================================================

  /// Log request details
  static void _logRequest(
    String method,
    String endpoint, {
    Map<String, dynamic>? body,
  }) {
    _log('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
    _log('📤 REQUEST: $method');
    _log('🔗 Endpoint: $endpoint');
    if (body != null && body.isNotEmpty) {
      _log('📦 Body: ${jsonEncode(body)}');
    }
  }

  /// Log response details
  static void _logResponse(int statusCode, String body) {
    final emoji = statusCode >= 200 && statusCode < 300 ? '✅' : '❌';
    _log('📥 RESPONSE: $emoji [$statusCode]');
    _log('📄 Body: $body');
    _log('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
  }

  /// General purpose log function
  static void _log(String message, {bool isError = false}) {
    final timestamp = DateTime.now().toIso8601String();
    final logMessage = '$_logTag [$timestamp] $message';

    if (isError) {
      log(logMessage, name: 'API_ERROR');
    } else {
      log(logMessage, name: 'API_INFO');
    }
  }
}
