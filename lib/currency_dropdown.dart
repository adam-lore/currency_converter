import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'currency_model.dart';

class CurrencyDropdown extends StatelessWidget {
  const CurrencyDropdown({
    super.key,
    required this.selectedCurrency,
    required this.currencyModel,
    required this.setCurrency,
  });

  final Map selectedCurrency;
  final CurrencyModel currencyModel;
  final Function setCurrency;

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      widthFactor: 1,
      child: DropdownMenu<Map>(
        initialSelection: currencyModel.currencies[1],
        leadingIcon: SvgPicture.asset(
          'assets/images/flags/${selectedCurrency["country"]}-flag.svg', //assetName
          semanticsLabel: 'Europe Flag',
          width: 50,
        ),
        textStyle: Theme.of(context).textTheme.headlineSmall,
        onSelected: (Map? currency) => setCurrency(currency),
        dropdownMenuEntries: currencyModel.currencies
            .map<DropdownMenuEntry<Map>>((Map currency) {
          return DropdownMenuEntry<Map>(
            value: currency,
            leadingIcon: SvgPicture.asset(
              'assets/images/flags/${currency["country"]}-flag.svg', //assetName
              semanticsLabel: '${currency["country"]} Flag',
              width: 50,
            ),
            label: currency["name"],
            labelWidget: Text(
                currency["name"],
            )
          );
        }).toList(),
      ),
    );
  }
}
