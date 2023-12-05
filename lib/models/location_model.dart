import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class LocationModel extends ChangeNotifier {
  String? currency;

  Future<void> getLocalCurrency() async {
    //await Future.delayed(Duration(seconds: 5));
    var httpUri = Uri(
        scheme: "http",
        host: "ip-api.com",
        path: "/json",
        //American ip address /json/209.142.68.29
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