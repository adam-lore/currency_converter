import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../models/currency_model.dart';

class CurrencyDropdown extends StatelessWidget {
  const CurrencyDropdown({
    super.key,
    required this.selectedCurrency,
    required this.currencyModel,
    required this.setCurrency,
    this.localCurrency,
  });

  final Currency selectedCurrency;
  final CurrencyModel currencyModel;
  final Function setCurrency;
  final String? localCurrency;

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      widthFactor: 1,
      child: DropdownMenu<Currency>(
        initialSelection: selectedCurrency,
        leadingIcon: SvgPicture.asset(
          'assets/images/flags/${selectedCurrency.country}-flag.svg', //assetName
          semanticsLabel: 'Europe Flag',
          width: 50,
        ),
        textStyle: Theme.of(context).textTheme.headlineSmall,
        onSelected: (Currency? currency) => setCurrency(currency),
        menuStyle: MenuStyle(
          backgroundColor: MaterialStateProperty.all(Theme.of(context).colorScheme.surface.withOpacity(1))
        ),
        dropdownMenuEntries: currencyModel.currencies
            .map<DropdownMenuEntry<Currency>>((Currency currency) {
          return DropdownMenuEntry<Currency>(
            value: currency,
            leadingIcon: SvgPicture.asset(
              'assets/images/flags/${currency.country}-flag.svg', //assetName
              semanticsLabel: '${currency.country} Flag',
              width: 50,
            ),
            label: currency.name,
            labelWidget: Text(
                currency.name,
            ),
            style: MenuItemButton.styleFrom(
              textStyle: Theme.of(context).textTheme.labelLarge,
            ),
          );
        }).toList(),
      ),
    );
  }
}
