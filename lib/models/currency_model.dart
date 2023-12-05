import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

  List<Currency> tempCurrencies = [
    Currency(name: "Chinese Yuan", ratio: 7.08, country: "china", code: "CNY"),
    Currency(name: "Euro", ratio: 0.91, country: "europe", code: "EUR"),
    Currency(name: "Pound Sterling", ratio: 0.79, country: "united-kingdom", code: "GBP"),
    Currency(name: "Japanese Yen", ratio: 147.47, country: "japan", code: "JPY"),
    Currency(name: "South Korean Won", ratio: 1288.12, country: "south-korea", code: "KRW"),
    Currency(name: "Swedish Krona", ratio: 10.32, country: "sweden", code: "SEK"),
    Currency(name: "United States Dollar", ratio: 1.0, country: "united-states-of-america", code: "USD")
  ];

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
        print(currencies[i].code);
      }
    }
  }

  //Get currency exchange rates from storage
  void readCurrencies() async {
    if (preferences == null) {
      await setSharedPreferences();
    }

    for (var i = 0; i < currencyTemplates.length; i++) {
      double? ratio = preferences!.getDouble(currencyTemplates[i].code);

      print(ratio);

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
  }

  void getCurrencies() {
    currencies = tempCurrencies;
    notifyListeners();
  }
}
