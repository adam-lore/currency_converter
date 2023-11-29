import 'package:flutter/material.dart';

class CurrencyModel extends ChangeNotifier {
  var currencies = [
  {"name" : "Chinese Yuan", "ratio" : 7.08, "country" : "china", "code" : "CNY"},
  {"name" : "Euro", "ratio" : 0.91, "country" : "europe", "code" : "EUR"},
  {"name" : "Pound Sterling", "ratio" : 0.79, "country" : "united-kingdom", "code" : "GBP"},
  {"name" : "Japanese Yen", "ratio" : 147.47, "country" : "japan", "code" : "JPY"},
  {"name" : "South Korean Won", "ratio" : 1288.12, "country" : "south-korea", "code" : "KRW"},
  {"name" : "Swedish Krona", "ratio" : 10.32, "country" : "sweden", "code" : "SEK"},
  {"name" : "United States Dollar", "ratio" : 1.0, "country" : "united-states-of-america", "code" : "USD"},
  ];
}
