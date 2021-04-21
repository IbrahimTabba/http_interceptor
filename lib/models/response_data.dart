import 'dart:convert';
import 'dart:typed_data';
import 'package:http/http.dart';
import 'package:http_interceptor/http_methods.dart';

class ResponseData {
  String url;
  int statusCode;
  Method method;
  Map<String, String> headers;
  String body;
  dynamic requestBody;
  Uint8List get requestBodyByte => requestBody!=null ? utf8.encode("$requestBody") : null;
  int contentLength;
  bool isRedirect;
  bool persistentConnection;

  ResponseData({
    this.method,
    this.url,
    this.statusCode,
    this.headers,
    this.body,
    this.contentLength,
    this.isRedirect,
    this.requestBody,
    this.persistentConnection,
  });

  factory ResponseData.fromHttpResponse(Response response , {requestBody}) {
    return ResponseData(
      statusCode: response.statusCode,
      headers: response.headers,
      body: response.body,
      contentLength: response.contentLength,
      isRedirect: response.isRedirect,
      url: response.request.url.toString(),
      method: methodFromString(response.request.method),
      persistentConnection: response.persistentConnection,
      requestBody:requestBody
    );
  }

  Response toHttpResponse() {
    return Response(
      body,
      statusCode,
      headers: headers,
      persistentConnection: persistentConnection,
      isRedirect: isRedirect,
      request: Request(
        methodToString(method),
        Uri.parse(url),
      ),
    );
  }

  @override
  String toString() {
    return 'ResponseData { $method, $url, $headers, $statusCode, $body }';
  }
}
