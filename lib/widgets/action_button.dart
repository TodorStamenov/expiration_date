import 'package:flutter/material.dart';

class PrimaryActionButton extends StatelessWidget {
  final IconData _icon;
  final Function _action;

  const PrimaryActionButton({
    required IconData icon,
    required Function action,
  })  : _icon = icon,
        _action = action;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: TextButton.styleFrom(
        backgroundColor: Colors.orange,
        shape: const CircleBorder(),
      ),
      child: Icon(
        _icon,
        color: Colors.white,
      ),
      onPressed: () => _action(),
    );
  }
}
