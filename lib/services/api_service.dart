import 'dart:convert';
import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:klpro_user/config.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../screens/app_pages_screens/server_error_screen/server_error.dart';
import 'environment.dart';
import 'error/exceptions.dart';

class ApiServices {
  static var client = http.Client();
  final dio = Dio();
  static List<Map<String, String>> conversationHistory = [];

  // ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
  //  LOGGER HELPERS
  // ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓

  static const String _thick  = '▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓';
  static const String _dark   = '░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░';
  static const String _mid    = '━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━';
  static const String _dotted = '┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄';

  /// Pretty-print an API request
  static void _logRequest(String method, String url,
      {dynamic body, Map<String, String>? headers, bool hasToken = false}) {
    final sb = StringBuffer();
    sb.writeln('\n');
    sb.writeln(_thick);
    sb.writeln('██  📤  $method  REQUEST');
    sb.writeln(_thick);
    sb.writeln('██  🌐 URL    ➜  $url');
    sb.writeln('██  🔑 Auth   ➜  ${hasToken ? "✅ Token attached" : "❌ No token"}');
    sb.writeln(_dotted);
    if (body != null) {
      try {
        // If body is already a JSON-encoded string, decode it first
        dynamic decoded = body;
        if (body is String) {
          try {
            decoded = json.decode(body);
          } catch (_) {
            decoded = body;
          }
        }
        final prettyBody = const JsonEncoder.withIndent('  ').convert(decoded);
        sb.writeln('██  📦 Body   ➜');
        for (final line in prettyBody.split('\n')) {
          sb.writeln('██    $line');
        }
      } catch (_) {
        sb.writeln('██  📦 Body   ➜  $body');
      }
    } else {
      sb.writeln('██  📦 Body   ➜  (empty)');
    }
    sb.writeln(_dark);
    sb.writeln('');
    log(sb.toString(), name: "API_REQUEST");
  }

  /// Pretty-print an API response
  static void _logResponse(String method, String url, int? statusCode,
      dynamic data, int elapsedMs) {
    final sb = StringBuffer();
    final isOk = statusCode == 200 || statusCode == 201;
    final emoji = isOk ? '✅' : '⚠️';
    final tag   = isOk ? '✅ SUCCESS' : '⚠️  WARNING';
    sb.writeln('\n');
    sb.writeln(_mid);
    sb.writeln('██  📥  $method  RESPONSE  ─  $tag');
    sb.writeln(_mid);
    sb.writeln('██  🌐 URL    ➜  $url');
    sb.writeln('██  🔢 Status ➜  $statusCode $emoji');
    sb.writeln('██  ⏱️  Time   ➜  ${elapsedMs}ms');
    sb.writeln(_dotted);
    if (data != null) {
      try {
        dynamic decoded = data;
        if (data is String) {
          try { decoded = json.decode(data); } catch (_) { decoded = data; }
        }
        final prettyData = const JsonEncoder.withIndent('  ').convert(decoded);
        final truncated = prettyData.length > 2000
            ? '${prettyData.substring(0, 2000)}...(truncated)'
            : prettyData;
        sb.writeln('██  📄 Data   ➜');
        for (final line in truncated.split('\n')) {
          sb.writeln('██    $line');
        }
      } catch (_) {
        final dataStr = data.toString();
        final truncated = dataStr.length > 2000
            ? '${dataStr.substring(0, 2000)}...(truncated)'
            : dataStr;
        sb.writeln('██  📄 Data   ➜  $truncated');
      }
    }
    sb.writeln(_thick);
    sb.writeln('\n');
    log(sb.toString(), name: "API_RESPONSE");
  }

  /// Pretty-print an API error
  static void _logError(String method, String url, dynamic error,
      {int? statusCode, dynamic responseData}) {
    final sb = StringBuffer();
    sb.writeln('\n');
    sb.writeln('🔴🔴🔴🔴🔴🔴🔴🔴🔴🔴🔴🔴🔴🔴🔴🔴🔴🔴🔴🔴🔴🔴🔴🔴🔴🔴🔴🔴🔴🔴🔴');
    sb.writeln(_thick);
    sb.writeln('██  ❌  $method  ERROR');
    sb.writeln(_thick);
    sb.writeln('██  🌐 URL    ➜  $url');
    sb.writeln('██  🔢 Status ➜  ${statusCode ?? "N/A"}');
    sb.writeln(_dotted);
    if (error is DioException) {
      sb.writeln('██  ⚡ Type   ➜  ${error.type}');
      sb.writeln('██  💬 Msg    ➜  ${error.message}');
    } else {
      sb.writeln('██  💬 Error  ➜  $error');
    }
    sb.writeln(_dotted);
    if (responseData != null) {
      try {
        dynamic decoded = responseData;
        if (responseData is String) {
          try { decoded = json.decode(responseData); } catch (_) { decoded = responseData; }
        }
        final prettyData =
            const JsonEncoder.withIndent('  ').convert(decoded);
        final truncated = prettyData.length > 1000
            ? '${prettyData.substring(0, 1000)}...(truncated)'
            : prettyData;
        sb.writeln('██  📄 Body   ➜');
        for (final line in truncated.split('\n')) {
          sb.writeln('██    $line');
        }
      } catch (_) {
        sb.writeln('██  📄 Body   ➜  $responseData');
      }
    }
    sb.writeln(_thick);
    sb.writeln('🔴🔴🔴🔴🔴🔴🔴🔴🔴🔴🔴🔴🔴🔴🔴🔴🔴🔴🔴🔴🔴🔴🔴🔴🔴🔴🔴🔴🔴🔴🔴');
    sb.writeln('\n');
    log(sb.toString(), name: "API_ERROR");
  }

  // ═══════════════════════════════════════════════════════════════
  //  URL BUILDER
  // ═══════════════════════════════════════════════════════════════

  static Future<String> getFullUrl(String apiName, List params) async {
    String url0 = "";
    if (params.isNotEmpty) {
      url0 = "$apiName?";
      for (int i = 0; i < params.length; i++) {
        url0 = '$url0${params[i]["key"]}=${params[i]["value"]}';
        if (i + 1 != params.length) url0 = "$url0&";
      }
    } else {
      url0 = apiName;
    }

    String url = '$apiUrl$url0';
    return url;
  }

  // ═══════════════════════════════════════════════════════════════
  //  DIO EXCEPTION HANDLER
  // ═══════════════════════════════════════════════════════════════

  Future<APIDataClass> dioException(e, {String url = ''}) async {
    APIDataClass apiData =
        APIDataClass(message: 'No data', isSuccess: false, data: '0');

    if (e is DioException) {
      final response = e.response;
      _logError('', url, e,
          statusCode: response?.statusCode, responseData: response?.data);

      if (e.type == DioExceptionType.badResponse && response != null) {
        if (response.statusCode == 403) {
          apiData.message = response.data.toString();
          apiData.isSuccess = false;
          apiData.data = response.statusCode ?? 0;
          return apiData;
        } else {
          if (response.data != null) {
            if (response.data is Map && response.data['message'] != null) {
              apiData.message = response.data['message'].toString();
            } else {
              apiData.message = response.data.toString();
            }
            apiData.isSuccess = false;
            apiData.data = response.statusCode ?? 0;
            return apiData;
          }
        }
      } else {
        if (response != null && response.data != null) {
          try {
            if (response.data is String) {
              final Map responseData = json.decode(response.data) as Map;
              apiData.message =
                  responseData['message']?.toString() ?? "Unknown error";
            } else if (response.data is Map) {
              apiData.message =
                  response.data['message']?.toString() ?? "Unknown error";
            } else {
              apiData.message = response.data.toString();
            }
          } catch (err) {
            apiData.message = "Parsing error: $err";
          }
          apiData.isSuccess = false;
          apiData.data = response.statusCode ?? 0;
          return apiData;
        } else {
          apiData.message = "Unknown network error";
          apiData.isSuccess = false;
          apiData.data = 0;
          return apiData;
        }
      }
    }

    // Non-DioException case
    _logError('', url, e);
    apiData.message = e.toString();
    apiData.isSuccess = false;
    apiData.data = 0;
    return apiData;
  }

  // ═══════════════════════════════════════════════════════════════
  //  GET API
  // ═══════════════════════════════════════════════════════════════

  Future<APIDataClass> getApi(
    String apiName,
    dynamic params, {
    isToken = false,
    isData = false,
    isMessage = true,
  }) async {
    APIDataClass apiData = APIDataClass(
      message: 'No data',
      isSuccess: false,
      data: '0',
    );

    bool isInternet = await isNetworkConnection();
    if (!isInternet) {
      log('│ 🌐 No Internet Connection');
      apiData.message = "No Internet Access";
      apiData.isSuccess = false;
      apiData.data = 0;
      return apiData;
    }

    SharedPreferences pref = await SharedPreferences.getInstance();
    String? token = pref.getString(session.accessToken);

    _logRequest('GET', apiName, body: params, hasToken: isToken && token != null);

    final stopwatch = Stopwatch()..start();

    try {
      Response? response = await dio.get(
        apiName,
        data: params,
        options: Options(headers: isToken ? headersToken(token) : headers),
      );

      stopwatch.stop();
      _logResponse('GET', apiName, response.statusCode, response.data,
          stopwatch.elapsedMilliseconds);

      if (response.statusCode == 500) {
        navigatorKey.currentState?.pushReplacement(
          MaterialPageRoute(builder: (_) => const ServerErrorScreen()),
        );
        return apiData;
      }

      if (response.statusCode == 200 || response.statusCode == 201) {
        var responseData = response.data;
        if (isData) {
          apiData.message = isMessage
              ? apiName.contains("highest-ratings")
                  ? ""
                  : responseData["message"] ?? ""
              : "";
          apiData.isSuccess = true;
          apiData.data = responseData;
          return apiData;
        } else {
          apiData.message = responseData["message"] ?? "";
          apiData.isSuccess = true;
          apiData.data = apiName.contains("self")
              ? responseData['user']
              : responseData["data"];
          return apiData;
        }
      } else {
        apiData.message = "Unexpected status: ${response.statusCode}";
        apiData.isSuccess = false;
        apiData.data = 0;
        return apiData;
      }
    } catch (e) {
      stopwatch.stop();
      apiData = await dioException(e, url: apiName);
      return apiData;
    }
  }

  // ═══════════════════════════════════════════════════════════════
  //  POST API
  // ═══════════════════════════════════════════════════════════════

  Future<APIDataClass> postApi(String apiName, body,
      {isToken = false, isData = false}) async {
    APIDataClass apiData = APIDataClass(
      message: 'No data',
      isSuccess: false,
      data: '0',
    );

    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      log('│ 🌐 No Internet Connection');
      apiData.message = "No Internet Access";
      apiData.isSuccess = false;
      apiData.data = 0;
      return apiData;
    }

    SharedPreferences pref = await SharedPreferences.getInstance();
    String? token = pref.getString(session.accessToken);

    _logRequest('POST', apiName, body: body, hasToken: isToken && token != null);

    final stopwatch = Stopwatch()..start();

    try {
      final response = await dio.post(
        apiName,
        data: body,
        options: Options(headers: isToken ? headersToken(token) : headers),
      );

      stopwatch.stop();
      _logResponse('POST', apiName, response.statusCode, response.data,
          stopwatch.elapsedMilliseconds);

      var responseData = response.data;

      if (response.statusCode == 200 || response.statusCode == 201) {
        if ((apiName.contains("login") ||
                apiName.contains("register") ||
                apiName.contains("social/login") ||
                apiName.contains("social/verifyOtp") ||
                apiName.contains("social/verifySendOtp")) &&
            responseData['access_token'] != null) {
          await pref.setString(
              session.accessToken, responseData['access_token']);
          apiData.message =
              apiName.contains("login") || apiName.contains("social/login")
                  ? ""
                  : "Register Successfully";
          apiData.isSuccess = true;
          apiData.data = "";
          return apiData;
        } else {
          if (isData) {
            apiData.message = responseData["message"] ?? "";
            apiData.isSuccess = true;
            apiData.data = responseData;
            return apiData;
          } else {
            apiData.message = responseData["message"] ?? "";
            apiData.isSuccess = true;
            apiData.data = responseData["data"];
            return apiData;
          }
        }
      } else {
        apiData.message = responseData["message"];
        apiData.isSuccess = false;
        apiData.data = 0;
        return apiData;
      }
    } catch (e) {
      stopwatch.stop();
      if (e is DioException) {
        final response = e.response;
        _logError('POST', apiName, e,
            statusCode: response?.statusCode, responseData: response?.data);

        if (e.type == DioExceptionType.badResponse) {
          if (response!.data != null) {
            apiData.message = response.data['message'];
            apiData.isSuccess = false;
            apiData.data = 0;
            return apiData;
          } else {
            apiData.message = response.data.toString();
            apiData.isSuccess = false;
            apiData.data = 0;
            return apiData;
          }
        } else {
          if (response != null && response.data != null) {
            final Map responseData =
                json.decode(response.data as String) as Map;
            apiData.message =
                responseData['message'] as String? ?? 'Unknown error';
            apiData.isSuccess = false;
            apiData.data = 0;
            return apiData;
          } else if (response != null) {
            apiData.message = response.statusCode.toString();
            apiData.isSuccess = false;
            apiData.data = 0;
            return apiData;
          } else {
            apiData.message = 'No response from server';
            apiData.isSuccess = false;
            apiData.data = 0;
            return apiData;
          }
        }
      } else {
        _logError('POST', apiName, e);
        apiData.message = "";
        apiData.isSuccess = false;
        apiData.data = 0;
        return apiData;
      }
    }
  }

  // ═══════════════════════════════════════════════════════════════
  //  DELETE API
  // ═══════════════════════════════════════════════════════════════

  Future<APIDataClass> deleteApi(String apiName, body,
      {isToken = false}) async {
    APIDataClass apiData = APIDataClass(
      message: 'No data',
      isSuccess: false,
      data: '0',
    );

    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      log('│ 🌐 No Internet Connection');
      apiData.message = "No Internet Access";
      apiData.isSuccess = false;
      apiData.data = 0;
      return apiData;
    }

    SharedPreferences pref = await SharedPreferences.getInstance();
    String? token = pref.getString(session.accessToken);

    _logRequest('DELETE', apiName, body: body, hasToken: isToken && token != null);

    final stopwatch = Stopwatch()..start();

    try {
      final response = await dio.delete(
        apiName,
        data: body,
        options: Options(headers: isToken ? headersToken(token) : headers),
      );

      stopwatch.stop();
      _logResponse('DELETE', apiName, response.statusCode, response.data,
          stopwatch.elapsedMilliseconds);

      var responseData = response.data;

      if (response.statusCode == 200 || response.statusCode == 201) {
        apiData.message = responseData["message"] ?? "";
        apiData.isSuccess = true;
        apiData.data = responseData["data"];
        return apiData;
      } else {
        apiData.message = responseData["message"];
        apiData.isSuccess = false;
        apiData.data = 0;
        return apiData;
      }
    } catch (e) {
      stopwatch.stop();
      if (e is DioException) {
        final response = e.response;
        _logError('DELETE', apiName, e,
            statusCode: response?.statusCode, responseData: response?.data);

        if (e.type == DioExceptionType.badResponse) {
          if (response!.data != null) {
            apiData.message = response.data['message'];
            apiData.isSuccess = false;
            apiData.data = 0;
            return apiData;
          } else {
            apiData.message = response.data.toString();
            apiData.isSuccess = false;
            apiData.data = 0;
            return apiData;
          }
        } else {
          final resp = e.response;
          if (resp != null && resp.data != null) {
            final Map responseData = json.decode(resp.data as String) as Map;
            apiData.message = responseData['message'] as String;
            apiData.isSuccess = false;
            apiData.data = 0;
            return apiData;
          } else {
            apiData.message = resp!.statusCode.toString();
            apiData.isSuccess = false;
            apiData.data = 0;
            return apiData;
          }
        }
      } else {
        _logError('DELETE', apiName, e);
        apiData.message = "";
        apiData.isSuccess = false;
        apiData.data = 0;
        return apiData;
      }
    }
  }

  // ═══════════════════════════════════════════════════════════════
  //  PUT API
  // ═══════════════════════════════════════════════════════════════

  Future<APIDataClass> putApi(String apiName, body,
      {isToken = false, isData = false}) async {
    APIDataClass apiData = APIDataClass(
      message: 'No data',
      isSuccess: false,
      data: '0',
    );

    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      log('│ 🌐 No Internet Connection');
      apiData.message = "No Internet Access";
      apiData.isSuccess = false;
      apiData.data = 0;
      return apiData;
    }

    SharedPreferences pref = await SharedPreferences.getInstance();
    String? token = pref.getString(session.accessToken);

    _logRequest('PUT', apiName, body: body, hasToken: isToken && token != null);

    final stopwatch = Stopwatch()..start();

    try {
      final response = await dio.put(
        apiName,
        data: jsonEncode(body),
        options: Options(headers: isToken ? headersToken(token) : headers),
      );

      stopwatch.stop();
      _logResponse('PUT', apiName, response.statusCode, response.data,
          stopwatch.elapsedMilliseconds);

      var responseData = response.data;

      if (response.statusCode == 200 || response.statusCode == 201) {
        if (isData) {
          apiData.message = "";
          apiData.isSuccess = true;
          apiData.data = responseData;
          return apiData;
        } else {
          apiData.message = responseData["message"] ?? "";
          apiData.isSuccess = true;
          apiData.data = responseData["data"];
          return apiData;
        }
      } else {
        apiData.message = responseData["message"];
        apiData.isSuccess = false;
        apiData.data = 0;
        return apiData;
      }
    } catch (e) {
      stopwatch.stop();
      if (e is DioException) {
        final response = e.response;
        _logError('PUT', apiName, e,
            statusCode: response?.statusCode, responseData: response?.data);

        if (e.type == DioExceptionType.badResponse) {
          if (response != null && response.data != null) {
            apiData.message = response.data['message'];
            apiData.isSuccess = false;
            apiData.data = 0;
            return apiData;
          } else {
            apiData.message = response!.data.toString();
            apiData.isSuccess = false;
            apiData.data = 0;
            return apiData;
          }
        } else {
          final resp = e.response;
          if (resp != null && resp.data != null) {
            final Map responseData = json.decode(resp.data as String) as Map;
            apiData.message = responseData['message'] as String;
            apiData.isSuccess = false;
            apiData.data = 0;
            return apiData;
          } else {
            apiData.message = resp!.statusCode.toString();
            apiData.isSuccess = false;
            apiData.data = 0;
            return apiData;
          }
        }
      } else {
        _logError('PUT', apiName, e);
        apiData.message = "";
        apiData.isSuccess = false;
        apiData.data = 0;
        return apiData;
      }
    }
  }
}

Exception handleErrorResponse(http.Response response) {
  var data = jsonDecode(response.body);

  return RemoteException(
    statusCode: response.statusCode,
    message: data['message'] ?? response.statusCode == 422
        ? 'Validation failed'
        : 'Server exception',
  );
}
