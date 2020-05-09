import 'package:flutter/widgets.dart';

class TextEditingValueHelper {
  static TextEditingValue buildForText(String text) {
    return TextEditingValue(
      text: text ?? "",
      selection: TextSelection.fromPosition(
        TextPosition(offset: text == null ? 0 : text.length),
      ),
    );
  }
}
