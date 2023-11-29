import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'currency_converter.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => CurrencyModel(),
      child: MaterialApp(
        title: 'Currency Converter',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.deepOrange,
            brightness: Brightness.dark,
            surface: const Color(0x12121212),
            surfaceTint: Colors.white,
            primary: Colors.deepOrange[900],
          ),
          textTheme: const TextTheme(
            headlineMedium: TextStyle(),
          ).apply(
            bodyColor: Colors.white,
            displayColor: Colors.white,
          ),
          useMaterial3: true,
        ),
        home: const CurrencyConversionPage(),
      ),
    );
  }
}

enum CurrencyLabel {
  cny("Chinese Yuan", 7.08, "china", "CNY"),
  eur("Euro", 0.91, "europe", "EUR"),
  gbp("Pound Sterling", 0.79, "united-kingdom", "GBP"),
  jpy("Japanese Yen", 147.47, "japan", "JPY"),
  krw("South Korean Won", 1288.12, "south-korea", "KRW"),
  sek("Swedish Krona", 10.32, "sweden", "SEK"),
  usd("United States Dollar", 1.0, "united-states-of-america", "USD");

  const CurrencyLabel(this.label, this.ratio, this.country, this.name);
  final String label;
  final double ratio;
  final String country;
  final String name;
}