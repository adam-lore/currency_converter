import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class CurrencyTemplate {
  String name;
  String country;
  String code;

  CurrencyTemplate({required this.name, required this.country, required this.code});
}

class Currency {
  String name;
  double ratio;
  String country;
  String code;

  Currency({required this.name, required this.ratio, required this.country, required this.code});
}

class CurrencyModel extends ChangeNotifier {
  SharedPreferences? preferences;

  int timestamp = 0;

  List<CurrencyTemplate> currencyTemplates = [
    CurrencyTemplate(name: "Chinese Yuan", country: "china", code: "CNY"),
    CurrencyTemplate(name: "Euro", country: "europe", code: "EUR"),
    CurrencyTemplate(name: "Pound Sterling", country: "united-kingdom", code: "GBP"),
    CurrencyTemplate(name: "Japanese Yen", country: "japan", code: "JPY"),
    CurrencyTemplate(name: "South Korean Won", country: "south-korea", code: "KRW"),
    CurrencyTemplate(name: "Swedish Krona", country: "sweden", code: "SEK"),
    CurrencyTemplate(name: "United States Dollar", country: "united-states-of-america", code: "USD")
  ];

  List<Currency> currencies = [
  ];

  Future<void> setSharedPreferences() async {
    preferences = await SharedPreferences.getInstance();
  }

  //Store currency exchange rates
  void storeCurrencies() async {
    if (preferences == null) {
      await setSharedPreferences();
    }

    for (var i = 0; i < currencies.length; i++) {
      if (currencies[i].ratio != null) {
        await preferences!.setDouble(currencies[i].code, currencies[i].ratio!);
      }
    }
    await preferences!.setInt("time", timestamp);
  }

  //Get currency exchange rates from storage
  void readCurrencies() async {
    if (preferences == null) {
      await setSharedPreferences();
    }

    //REMOVE THIS
    //await preferences!.clear();
    //REMOVE THIS

    int? storedTime = preferences!.getInt("time");
    if (storedTime != null) {
      timestamp = storedTime;
    }

    if (daySinceFetch()) {
      getCurrencies();
      return;
    }

    currencies = [];

    for (var i = 0; i < currencyTemplates.length; i++) {
      double? ratio = preferences!.getDouble(currencyTemplates[i].code);

      if (ratio != null) {
        currencies.add(
            Currency(
                name: currencyTemplates[i].name,
                country: currencyTemplates[i].country,
                ratio: ratio,
                code: currencyTemplates[i].code
            )
        );
      }
    }

    notifyListeners();
    if (currencies.isEmpty) {
      getCurrencies();
    }
  }

  bool daySinceFetch() {
    var oldDate = DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
    print(DateTime.now().difference(oldDate).inDays);
    return DateTime.now().difference(oldDate).inDays > 0;
  }

  //Get currency exchange rates from api
  void getCurrencies() {
    List<String> codes = [];

    for (int i = 0; i < currencyTemplates.length; i++) {
      codes.add(currencyTemplates[i].code);
    }

    print(codes.join(","));

    var httpUri = Uri(
        scheme: "http",
        host: "data.fixer.io",
        path: "/api/latest",

        queryParameters: {
          "access_key": "83e19e5b678dedc897bce054059675e6",
          "base": "EUR",
          "symbols": codes.join(",")
        }
    );
    try {
      http.get(httpUri).then((response) {
        Map responseMap = jsonDecode(response.body);
        print(responseMap);
        if (responseMap["success"] == true) {
          currencies = [];
          timestamp = responseMap["timestamp"];
          Map rates = responseMap["rates"];
          for (var i = 0; i < currencyTemplates.length; i++) {
            if (rates[currencyTemplates[i].code] != null) {
              currencies.add(
                  Currency(
                      name: currencyTemplates[i].name,
                      country: currencyTemplates[i].country,
                      ratio: rates[currencyTemplates[i].code].toDouble(),
                      code: currencyTemplates[i].code
                  )
              );
            }
          }
          notifyListeners();
          storeCurrencies();
        }
      });

    } catch (err) {
      print(err);
    }
  }
}
