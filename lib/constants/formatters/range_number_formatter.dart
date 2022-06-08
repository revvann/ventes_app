import 'package:flutter/services.dart';

class RangeInputFormatter extends TextInputFormatter {
  double? minNumber;
  double? maxNumber;
  double? defaultNumber;

  RangeInputFormatter({
    this.minNumber,
    this.maxNumber,
    this.defaultNumber,
  });

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (newValue.selection.baseOffset == 0) {
      return newValue;
    }
    String value = newValue.text.replaceAll(',', '.');

    if (value.split('').last != '.') {
      double number = double.tryParse(value) ?? 0;

      if (number < (minNumber ?? number - 1) || number > (maxNumber ?? number + 1)) {
        number = defaultNumber ?? 0;
      }
      value = number % 1 == 0 ? number.toStringAsFixed(0) : number.toString();
    }

    return newValue.copyWith(
      text: value.replaceAll('.', ','),
      selection: TextSelection.collapsed(
        offset: value.length,
      ),
    );
  }
}
