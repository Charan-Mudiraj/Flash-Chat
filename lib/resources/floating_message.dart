import 'package:flutter/material.dart';

class FloatingMessage extends StatelessWidget {

  final int docID;
  final String groupName;
  final String name;
  final String text;
  final bool isCurrentUser;
  const FloatingMessage({required this.docID, required this.groupName, required this.name, required this.text, required this.isCurrentUser});


  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(9.0),
      alignment: isCurrentUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        padding: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          boxShadow: const [
            BoxShadow(
              color: Colors.grey,
              spreadRadius: 2.0,
              blurRadius: 5.0,
            )
          ],
          color: isCurrentUser ? Colors.lightBlueAccent : Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: isCurrentUser ? const Radius.circular(20.0) : const Radius.circular(0.0),
            topRight: isCurrentUser ? const Radius.circular(0.0) : const Radius.circular(20.0),
            bottomLeft: const Radius.circular(20.0),
            bottomRight: const Radius.circular(20.0),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            !isCurrentUser ? Text(
                name,
                textAlign: TextAlign.left,
                style: const TextStyle(
                  color: Colors.purple,
                  fontSize: 12.0,
                )
            ) : const SizedBox(height: 0.0),
            !isCurrentUser ? const SizedBox(height: 5.0) : const SizedBox(height: 0.0),
            Text(
                text,
                textAlign: TextAlign.left,
                style: TextStyle(
                  color: isCurrentUser ? Colors.white : Colors.black,
                  fontSize: 17.0,
                )
            ),
          ],
        ),
      ),
    );
  }
}