import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart';

import 'package:http_interceptor/http_methods.dart';
import 'package:http_interceptor/utils.dart';

class RequestData {
  Method method;
  String baseUrl;
  Map<String, String> headers;
  Map<String, String> params;
  dynamic body;
  dynamic requestBody;
  Uint8List get requestBodyByte => requestBody!=null ? utf8.encode("$requestBody") : null;
  Encoding encoding;

  RequestData({
    @required this.method,
    @required this.baseUrl,
    this.headers,
    this.params,
    this.body,
    this.requestBody,
    this.encoding,
  })  : assert(method != null),
        assert(baseUrl != null);

  String get url => addParametersToStringUrl(baseUrl, params);

  factory RequestData.fromHttpRequest(Request request , {requestBody}) {
    var params = Map<String, String>();
    request.url.queryParameters.forEach((key, value) {
      params[key] = value;
    });
    String baseUrl = request.url.origin + request.url.path;
    return RequestData(
      method: methodFromString(request.method),
      encoding: request.encoding,
      body: request.body,
      baseUrl: baseUrl,
      requestBody: requestBody,
      headers: request.headers ?? <String, String>{},
      params: params ?? <String, String>{},
    );

  }

  Request toHttpRequest() {
    var reqUrl = Uri.parse(addParametersToStringUrl(baseUrl, params));

    Request request = new Request(methodToString(method), reqUrl);

    if (headers != null) request.headers.addAll(headers);
    if (encoding != null) request.encoding = encoding;
    if (body != null) {
      if (body is String) {
        request.body = body;
      } else if (body is List) {
        request.bodyBytes = body.cast<int>();
      } else if (body is Map) {
        request.bodyFields = body.cast<String, String>();
      } else {
        throw new ArgumentError('Invalid request body "$body".');
      }
    }

    return request;
  }

  @override
  String toString() {
    return 'Request Data { $method, $baseUrl, $headers, $params, $body }';
  }
}
