// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:webook/api/request/create.dart';
import 'package:webook/api/response/error.dart';

void main() {
  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    var request = CreateRequest(
        title: 'title',
        urls: ['url'],
        author: 'author',
        description: 'description');
    var json = jsonEncode(request.toJson());

    expect(json, equals(
        '{"title":"title","description":"description","author":"author","genre":"ebook","coverPath":"","urls":["url"]}'));


    var jsonObject = {
      'errors':[{'status':'500','detail':'Unknown error.'}]
    };

    var errResponse = ErrorResponse.fromJson(jsonObject);

    expect(errResponse.errors.length, equals(1));
    expect(errResponse.errors[0].detail, equals('Unknown error.'));
    expect(errResponse.errors[0].status, equals('500'));
  });
}
