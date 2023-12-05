import 'package:flutter/material.dart';

class Currency {
  String name;
  double ratio;
  String country;
  String code;

  Currency({required this.name, required this.ratio, required this.country, required this.code});
}

class CurrencyModel extends ChangeNotifier {
  List<Currency> currencies = [
    Currency(name: "Chinese Yuan", ratio: 7.08, country: "china", code: "CNY"),
    Currency(name: "Euro", ratio: 0.91, country: "europe", code: "EUR"),
    Currency(name: "Pound Sterling", ratio: 0.79, country: "united-kingdom", code: "GBP"),
    Currency(name: "Japanese Yen", ratio: 147.47, country: "japan", code: "JPY"),
    Currency(name: "South Korean Won", ratio: 1288.12, country: "south-korea", code: "KRW"),
    Currency(name: "Swedish Krona", ratio: 10.32, country: "sweden", code: "SEK"),
    Currency(name: "United States Dollar", ratio: 1.0, country: "united-states-of-america", code: "USD")
  ];
}
