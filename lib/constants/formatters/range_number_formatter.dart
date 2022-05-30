import 'package:flutter/services.dart';

class RangeInputFormatter extends TextInputFormatter {
  int? minNumber;
  int? maxNumber;
  int? defaultNumber;

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
    int number = int.tryParse(newValue.text) ?? 0;
    if (number < (minNumber ?? number - 1) || number > (maxNumber ?? number + 1)) {
      number = defaultNumber ?? 0;
    }
    return newValue.copyWith(
      text: "$number",
      selection: TextSelection.collapsed(
        offset: "$number".length,
      ),
    );
  }
}
