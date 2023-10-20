import 'package:flutter/material.dart';
class AuthenticationButton extends StatelessWidget {

  final String text;
  final Color color;
  final VoidCallback onTap;
  const AuthenticationButton(this.text, {required this.color,required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Material(
        elevation: 5.0,
        color: color,
        borderRadius: BorderRadius.circular(30.0),
        child: MaterialButton(
          onPressed: onTap,
          minWidth: 200.0,
          height: 42.0,
          child: Text(
            text,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16.0
            ),
          ),
        ),
      ),
    );
  }
}