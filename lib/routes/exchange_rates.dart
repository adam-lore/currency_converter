import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../models/currency_model.dart';
import '../models/location_model.dart';

import '../components/currency_dropdown.dart';

class ExchangeRateRoute extends StatefulWidget {
  const ExchangeRateRoute({super.key});

  @override
  State<ExchangeRateRoute> createState() => _ExchangeRateState();
}
class _ExchangeRateState extends State<ExchangeRateRoute> {
  Currency? selectedCurrency;
  String date = "";

  bool changedCurrency = false;

  @override
  void initState() {
    super.initState();
    if (Provider.of<CurrencyModel>(context, listen: false).currencies.isNotEmpty) {
      selectedCurrency = Provider.of<CurrencyModel>(context, listen: false).currencies[0];
    }

  }

  void _setCurrency(Currency currency) {
    setState(() {
      selectedCurrency = currency;
      changedCurrency = true;
    });
  }


  @override
  Widget build(BuildContext context) {
    return OrientationBuilder(
      builder: (context, orientation) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Theme.of(context).colorScheme.surface,
            elevation: 10,
            title: const Text("Exchange Rates"),
          ),
          body: Center(
            child: Consumer2<CurrencyModel, LocationModel>(
                builder: (context, currencyModel, locationModel, child) {
                  if (currencyModel.currencies.isEmpty) {
                    return Text(
                      "No currencies loaded",
                      style: Theme.of(context).textTheme.headlineSmall,
                    );
                  }
                  if (!changedCurrency) {
                    selectedCurrency = currencyModel.currencies.firstWhere(
                            (currency) => currency.code == locationModel.currency,
                        orElse: () => selectedCurrency!
                    );
                  }
                  if (currencyModel.timestamp != null) {
                    DateTime timestamp = DateTime.fromMillisecondsSinceEpoch(currencyModel.timestamp * 1000);
                    date = "Rates updated: ${timestamp.year}-${timestamp.month}-${timestamp.day}";
                  }
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      CurrencyDropdown(
                        selectedCurrency: selectedCurrency,
                        currencyModel: currencyModel,
                        setCurrency: _setCurrency,
                      ),
                      Expanded(
                        child: ListView.builder(
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          itemCount: currencyModel.currencies.length,
                          itemBuilder: (context, index) {
                            Currency currency = currencyModel.currencies[index];
                            if (currency.code == selectedCurrency!.code) return Container();
                            return Padding(
                              padding: const EdgeInsets.only(top: 20),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: <Widget>[
                                  SvgPicture.asset(
                                    'assets/images/flags/${currency.country}-flag.svg', //assetName
                                    semanticsLabel: '${currency.country} Flag',
                                    width: 70,
                                  ),
                                  Text(
                                    currency.name, //CurrencyCode
                                    style: Theme.of(context).textTheme.headlineSmall,
                                  ),
                                  const Spacer(),
                                  Text(
                              (currency.ratio / selectedCurrency!.ratio).toStringAsFixed(3), //CurrencyCode
                                    style: Theme.of(context).textTheme.headlineSmall,
                                  ),
                                ],
                              ),
                            );
                          }
                        ),
                      ),
                      Text(date)
                    ],
                  ),
                );
              }
            ),
          ),
        );
      }
    );
  }
}