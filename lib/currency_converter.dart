import 'package:currency_converter/currency_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'currency_model.dart';
import 'exchange_rates.dart';

class ValueModel extends ChangeNotifier {
  double dollarValue = 0;

  void updateDollarValue(value) {
    if (value != dollarValue) {
      dollarValue = value;
      notifyListeners();
    }
  }
  void notify() {
    notifyListeners();
  }
}

class CurrencyConversionRoute extends StatelessWidget {
  const CurrencyConversionRoute({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ValueModel(),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.surface,
          elevation: 10,
          title: const Text("Currency Converter"),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
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
              )
            ],
          ),
        ),
      ),
    );
  }
}

class CurrencyField extends StatefulWidget {
  final Color color;

  const CurrencyField(this.color, {super.key});

  @override
  State<CurrencyField> createState() => _CurrencyFieldState();
}

class _CurrencyFieldState extends State<CurrencyField> {
  final currencyController = TextEditingController();
  final valueController = TextEditingController();

  late Map selectedCurrency;
  late FocusNode currencyFieldFocusNode;

  @override
  void initState() {
    super.initState();

    selectedCurrency = Provider.of<CurrencyModel>(context, listen: false).currencies[1];

    currencyFieldFocusNode = FocusNode();
    valueController.addListener(_updateDollarValue);
  }

  @override
  void dispose() {
    currencyFieldFocusNode.dispose();
    valueController.dispose();
    super.dispose();
  }
  
  void _setCurrency(Map currency) {
    setState(() {
      selectedCurrency = currency;
      var model = context.read<ValueModel>();
      model.notify();
    });
  }

  void _updateDollarValue() {
    if (!currencyFieldFocusNode.hasFocus) return;
    final text = valueController.text;
    final value = double.tryParse(text);
    if (text == "") {
      var model = context.read<ValueModel>();
      model.updateDollarValue(0.0);
    } else if (value != null) {
      var model = context.read<ValueModel>();
      //Convert to dollars and update ValueModel
      model.updateDollarValue(value / selectedCurrency["ratio"]);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 5, 10, 0),
      child: Card(
        color: widget.color,
        elevation: 5,
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Consumer<CurrencyModel>(
            builder: (context, currencyModel, child) {
              return Column(
                children: <Widget>[
                  CurrencyDropdown(
                    selectedCurrency: selectedCurrency,
                    currencyModel: currencyModel,
                    setCurrency: _setCurrency,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      Expanded(child: Consumer<ValueModel>(
                          builder: (context, model, child) {
                        //Do not update field if in focus
                        if (!currencyFieldFocusNode.hasFocus) {
                          valueController.text =
                              (model.dollarValue * selectedCurrency["ratio"])
                                  .toStringAsFixed(2);
                        }
                        return TextField(
                          controller: valueController,
                          keyboardType: TextInputType.number,
                          focusNode: currencyFieldFocusNode,
                          decoration: InputDecoration(
                            border: const OutlineInputBorder(),
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color:
                                        Theme.of(context).colorScheme.primary)),
                            fillColor: Theme.of(context).colorScheme.surface,
                            filled: false,
                          ),
                          style: Theme.of(context).textTheme.headlineSmall,
                        );
                      })),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Text(
                          selectedCurrency["code"].toUpperCase(), //CurrencyCode
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                      ),
                    ],
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
