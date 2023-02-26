import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:webook/api/request/download.dart';
import 'package:webook/api/response/download.dart';
import 'package:webook/api/response/error.dart';
import 'response/create.dart';
import 'response/status.dart';
import 'request/create.dart';
import 'request/status.dart';

const headers = <String, String>{
'Content-Type': 'application/json; charset=UTF-8',
};

class ApiClient {

  final String host;

  ApiClient(this.host);

  Future<CreateResponse> create(CreateRequest request) async {
    var jsonObject = request.toJson();
    http.Response response = await http.post(
        Uri.parse('$host/api/v1/books'),
        headers: headers,
        body: jsonEncode(jsonObject)
    );
    var responseBody = jsonDecode(response.body);
    if (response.statusCode == 202) {
      return CreateResponse.fromJson(responseBody);
    }

    throw ErrorResponse.fromJson(responseBody);
  }

  Future<StatusResponse> status(StatusRequest request) async {
    http.Response response = await http.get(Uri.parse('$host/api/v1/books/${request.bookId}/status'), headers: headers);
    if (response.statusCode == 200) {
      return StatusResponse.fromJson(jsonDecode(response.body));
    }

    throw Exception('Failed to receive book status');
  }

  Future<DownloadResponse> download(DownloadRequest request) async {
    var url = Uri.parse('$host/api/v1/books/${request.bookId}/download?filetype=${request.filetype.value}');
    http.Response response = await http.get(url, headers: headers);
    if (response.statusCode == 200) {
      return DownloadResponse(bookContent: response.bodyBytes);
    }

    throw Exception('Failed to download book');
  }}