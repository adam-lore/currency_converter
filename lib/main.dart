import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'routes/currency_converter.dart';
import 'models/currency_model.dart';
import 'models/location_model.dart';

void main() async {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<CurrencyModel>(create: (context) => CurrencyModel()),
        ChangeNotifierProvider<LocationModel>(create: (context) => LocationModel()),
      ],
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
            headlineSmall: TextStyle(),
            labelLarge: TextStyle(),
          ).apply(
            bodyColor: Colors.white,
            displayColor: Colors.white,
          ),
          useMaterial3: true,
        ),
        home: const CurrencyConversionRoute(),
      ),
    );
  }
}