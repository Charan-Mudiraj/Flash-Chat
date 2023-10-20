import 'package:flutter/material.dart';

class AlertBox extends StatelessWidget {
  final Icon icon;
  final String title;
  final String description;
  final VoidCallback onYes;

  const AlertBox({required this.icon, required this.title, required this.description, required this.onYes});
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      icon: icon,
      title: Text(title),
      content: Text(description),
      actions: [
        MaterialButton(
          onPressed: (){
            Navigator.pop(context);
          },
          child: const Text('No', style: TextStyle(color: Colors.lightBlueAccent, fontSize: 18.0)),
        ),
        MaterialButton(
          onPressed: onYes,
          color: Colors.lightBlueAccent,
          child: const Text('Yes', style: TextStyle(color: Colors.white, fontSize: 18.0),),
        ),
      ],
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30.0),
      ),
      actionsAlignment: MainAxisAlignment.center,
      actionsPadding: const EdgeInsets.only(bottom: 12.0),
      buttonPadding: const EdgeInsets.symmetric(horizontal: 50.0),
    );
  }
}
