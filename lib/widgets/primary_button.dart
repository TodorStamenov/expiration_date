import 'package:flutter/material.dart';

class PrimaryButton extends StatelessWidget {
  final String _text;
  final Function _action;

  const PrimaryButton({
    required String text,
    required Function action,
  })  : _text = text,
        _action = action;

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      color: Colors.orange,
      padding: const EdgeInsets.symmetric(
        vertical: 10,
        horizontal: 30,
      ),
      onPressed: () => _action(),
      child: Text(
        _text,
        style: const TextStyle(
          fontSize: 18,
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
