import 'package:flutter/material.dart';
import 'package:country_picker/country_picker.dart';

class CountryPickerWidget extends StatefulWidget {
  final Function(Country) onCountrySelected; 

  const CountryPickerWidget({super.key, required this.onCountrySelected});

  @override
  State<CountryPickerWidget> createState() => _CountryPickerWidgetState();
}

class _CountryPickerWidgetState extends State<CountryPickerWidget> {
  Country? _selectedCountry;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showCountryPicker(
          context: context,
          showPhoneCode: true,
          onSelect: (Country country) {
            setState(() {
              _selectedCountry = country;
            });

            widget.onCountrySelected(country);
          },
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade400),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              _selectedCountry != null
                  ? '${_selectedCountry!.flagEmoji} +${_selectedCountry!.phoneCode} ${_selectedCountry!.name}'
                  : 'Select your country',
              style: const TextStyle(fontSize: 16),
            ),
            const Icon(Icons.arrow_drop_down),
          ],
        ),
      ),
    );
  }
}
