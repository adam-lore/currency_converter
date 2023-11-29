import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_svg/flutter_svg.dart';

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

class CurrencyModel extends ChangeNotifier {
  double dollarValue = 0;

  void updateDollarValue(value) {
    if (value != dollarValue) {
      dollarValue = value;
      notifyListeners();
    }
  }
}

class CurrencyConversionPage extends StatelessWidget {

  const CurrencyConversionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.surface,
        elevation: 2,
        title: const Text("Currency Converter"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            CurrencyField(Theme.of(context).colorScheme.surface),
            CurrencyField(Theme.of(context).colorScheme.primary),
          ],
        ),
      ),
    );
  }
}

class CurrencyField extends StatefulWidget {
  Color color;

  CurrencyField(this.color, {super.key});

  @override
  State<CurrencyField> createState() => _CurrencyFieldState();
}

class _CurrencyFieldState extends State<CurrencyField> {

  final currencyController = TextEditingController();
  final valueController = TextEditingController();
  CurrencyLabel selectedCurrency = CurrencyLabel.eur;

  late FocusNode currencyFieldFocusNode;

  @override
  void initState() {
    super.initState();

    currencyFieldFocusNode = FocusNode();
    valueController.addListener(_updateDollarValue);
  }

  @override
  void dispose() {
    currencyFieldFocusNode.dispose();
    valueController.dispose();
    super.dispose();
  }

  void _updateDollarValue() {
    if (!currencyFieldFocusNode.hasFocus) return;
    final text = valueController.text;
    final value = double.tryParse(text);
    if (text == "") {
      var model = context.read<CurrencyModel>();
      model.updateDollarValue(0.0);
    } else if (value != null) {
      var model = context.read<CurrencyModel>();
      //Convert to dollars and update CurrencyModel
      model.updateDollarValue(value / selectedCurrency.ratio);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 5, 10, 0),
      child: Card(
        color: widget.color,
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: <Widget>[
              FractionallySizedBox(
                widthFactor: 1,
                child: DropdownMenu<CurrencyLabel>(
                  initialSelection: CurrencyLabel.eur,
                  controller: currencyController,
                  leadingIcon: SvgPicture.asset(
                    'assets/images/flags/${selectedCurrency.country}-flag.svg', //assetName
                    semanticsLabel: 'Europe Flag',
                    width: 50,
                  ),
                  onSelected: (CurrencyLabel? currency) {
                    setState(() {
                      if (currency != null) {
                        selectedCurrency = currency;
                      }
                    });
                  },
                  dropdownMenuEntries: CurrencyLabel.values
                      .map<DropdownMenuEntry<CurrencyLabel>>((CurrencyLabel currency) {
                    return DropdownMenuEntry<CurrencyLabel>(
                      value: currency,
                      leadingIcon: SvgPicture.asset(
                        'assets/images/flags/${currency.country}-flag.svg', //assetName
                        semanticsLabel: 'Europe Flag',
                        width: 50,
                      ),
                      label: currency.label,
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  Expanded(
                      child: Consumer<CurrencyModel> (
                          builder: (context, model, child) {
                            //Do not update field if in focus
                            if (!currencyFieldFocusNode.hasFocus) {
                              valueController.text = (model.dollarValue * selectedCurrency!.ratio).toStringAsFixed(2);
                            }
                            return TextField(
                              controller: valueController,
                              keyboardType: TextInputType.number,
                              focusNode: currencyFieldFocusNode,
                              decoration: InputDecoration(
                                border: const OutlineInputBorder(),
                                focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Theme.of(context).colorScheme.primary)
                                ),
                                fillColor: Theme.of(context).colorScheme.surface,
                                filled: false,
                              ),
                              style: Theme.of(context).textTheme.headlineSmall,
                            );
                          }
                      )
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Text(
                      "EUR",
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}