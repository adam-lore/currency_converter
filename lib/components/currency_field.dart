import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/currency_model.dart';
import '../models/value_model.dart';
import '../models/location_model.dart';

import '../components/currency_dropdown.dart';

class CurrencyField extends StatefulWidget {
  final Color color;

  const CurrencyField(this.color, {super.key});

  @override
  State<CurrencyField> createState() => _CurrencyFieldState();
}

class _CurrencyFieldState extends State<CurrencyField> {
  final currencyController = TextEditingController();
  final valueController = TextEditingController();

  Currency? selectedCurrency;
  late FocusNode currencyFieldFocusNode;

  bool changedCurrency = false;

  @override
  void initState() {
    super.initState();

    if (Provider.of<CurrencyModel>(context, listen: false).currencies.isNotEmpty) {
      selectedCurrency = Provider.of<CurrencyModel>(context, listen: false).currencies[1];
    }

    currencyFieldFocusNode = FocusNode();
    valueController.addListener(_updateDollarValue);
  }

  @override
  void dispose() {
    currencyFieldFocusNode.dispose();
    valueController.dispose();
    super.dispose();
  }

  void _setCurrency(Currency currency) {
    setState(() {
      selectedCurrency = currency;
      changedCurrency = true;
      var model = context.read<ValueModel>();
      model.notify();
    });
  }

  void _updateDollarValue() {
    if (!currencyFieldFocusNode.hasFocus || selectedCurrency == null) return;
    final text = valueController.text;
    final value = double.tryParse(text);
    if (text == "") {
      var model = context.read<ValueModel>();
      model.updateDollarValue(0.0);
    } else if (value != null) {
      var model = context.read<ValueModel>();
      //Convert to dollars and update ValueModel
      model.updateDollarValue(value / selectedCurrency!.ratio);
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
          child: Consumer2<CurrencyModel, LocationModel>(
            builder: (context, currencyModel, locationModel, child) {
              if (!changedCurrency && currencyModel.currencies.isNotEmpty) {
                selectedCurrency = currencyModel.currencies.firstWhere(
                      (currency) => currency.code == locationModel.currency,
                  orElse: () => currencyModel.currencies[0]
                );
              }
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
                            if (!currencyFieldFocusNode.hasFocus && selectedCurrency != null) {
                              valueController.text =
                                  (model.dollarValue * selectedCurrency!.ratio)
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
                          selectedCurrency?.code.toUpperCase() ?? "NONE", //CurrencyCode
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