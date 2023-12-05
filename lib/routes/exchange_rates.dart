import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../models/currency_model.dart';
import '../components/currency_dropdown.dart';

class ExchangeRateRoute extends StatefulWidget {
  const ExchangeRateRoute({super.key});

  @override
  State<ExchangeRateRoute> createState() => _ExchangeRateState();
}
class _ExchangeRateState extends State<ExchangeRateRoute> {
  late Currency selectedCurrency;

  @override
  void initState() {
    super.initState();

    selectedCurrency = Provider.of<CurrencyModel>(context, listen: false).currencies[1];
  }

  void _setCurrency(Currency currency) {
    setState(() {
      selectedCurrency = currency;
    });
  }


  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Theme.of(context).colorScheme.surface,
            elevation: 10,
            title: const Text("Exchange Rates"),
          ),
          body: Center(
            child: Consumer<CurrencyModel>(
              builder: (context, currencyModel, child) {
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
                            if (currency.code == selectedCurrency.code) return Container();
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
                              (currency.ratio / selectedCurrency.ratio).toStringAsFixed(3), //CurrencyCode
                                    style: Theme.of(context).textTheme.headlineSmall,
                                  ),
                                ],
                              ),
                            );
                          }
                        ),
                      ),
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