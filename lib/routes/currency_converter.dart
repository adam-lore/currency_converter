import 'package:currency_converter/models/currency_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'exchange_rates.dart';

import '../models/value_model.dart';
import '../models/location_model.dart';

import '../components/currency_field.dart';

class CurrencyConversionRoute extends StatefulWidget {
  const CurrencyConversionRoute({super.key});

  @override
  State<CurrencyConversionRoute> createState() => _CurrencyConversionRouteState();
}

class _CurrencyConversionRouteState extends State<CurrencyConversionRoute> {

  @override
  void initState() {
    super.initState();
    Provider.of<LocationModel>(context, listen: false).getLocalCurrency();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ValueModel(),
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            return Scaffold(
              resizeToAvoidBottomInset : false,
              appBar: constraints.maxWidth > 600 ? null : AppBar(
                backgroundColor: Theme.of(context).colorScheme.surface,
                elevation: 10,
                title: const Text("Currency Converter"),
              ),
              body: constraints.maxWidth > 600 ? _buildWideConverter(context) : _buildNormalConverter(context),
            );
          }
        ),
      ),
    );
  }
}

Widget _buildNormalConverter(context) {
  return Column(
    children: <Widget>[
      CurrencyField(Theme.of(context).colorScheme.surface),
      CurrencyField(Theme.of(context).colorScheme.primary),
      ElevatedButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const ExchangeRateRoute()),
          );
        },
        child: const Text("Exchange Rates"),
      ),
      ElevatedButton(
        onPressed: () {
          Provider.of<CurrencyModel>(context, listen: false).readCurrencies();
        },
        child: const Text("Get currencies"),
      ),
      ElevatedButton(
        onPressed: () {
          Provider.of<CurrencyModel>(context, listen: false).storeCurrencies();
        },
        child: const Text("Store currencies"),
      ),
      ElevatedButton(
        onPressed: () {
          Provider.of<CurrencyModel>(context, listen: false).getCurrencies();
        },
        child: const Text("Copy currencies"),
      ),
    ],
  );
}

Widget _buildWideConverter(context) {
  return Column(
    children: [
      Row(
        children: <Widget>[
          Expanded(
              child: CurrencyField(Theme.of(context).colorScheme.primary),
          ),
          Expanded(
              child: CurrencyField(Theme.of(context).colorScheme.surface),
          ),
        ],
      ),
      ElevatedButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const ExchangeRateRoute()),
          );
        },
        child: const Text("Exchange Rates"),
      )
    ],
  );
}


