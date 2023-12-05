import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class LocationModel extends ChangeNotifier {
  String? currency;

  Future<void> getLocalCurrency() async {
    print("Start");
    var httpUri = Uri(
        scheme: "http",
        host: "ip-api.com",
        path: "/json/",
        queryParameters: {"fields": "currency"}
    );
    try {
      http.get(httpUri).then((value) {
        currency = jsonDecode(value.body)["currency"];
        print("cyurrency: $currency");
        notifyListeners();
      });
    } catch (err) {
      print(err);
      currency = null;
      notifyListeners();
    }
  }
}