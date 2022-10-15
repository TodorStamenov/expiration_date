import 'package:flutter/material.dart';

class PrimaryInputField extends StatelessWidget {
  final String _label;
  final TextInputType _textInputType;
  final TextInputAction _textInputAction;
  final TextEditingController _textEditor;
  final bool _isRequired;

  const PrimaryInputField({
    required String label,
    required TextInputType textInputType,
    required TextInputAction textInputAction,
    required TextEditingController textEditor,
    bool isRequired = false,
  })  : _label = label,
        _textInputType = textInputType,
        _textInputAction = textInputAction,
        _textEditor = textEditor,
        _isRequired = isRequired;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: _textEditor,
      keyboardType: _textInputType,
      textInputAction: _textInputAction,
      cursorColor: Colors.black,
      validator: (value) {
        if (_isRequired && (value == null || value.isEmpty)) {
          return '$_label is reqired';
        }

        return null;
      },
      decoration: InputDecoration(
        labelText: _label,
        labelStyle: const TextStyle(
          color: Colors.black,
        ),
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(
            color: Colors.black,
            width: 1,
          ),
        ),
      ),
    );
  }
}
