import 'package:flutter/material.dart';

import '../screens/chat_screen.dart';
import 'more_options_button.dart';


class GroupBox extends StatelessWidget {

  final int groupID;
  final String groupName;

  const GroupBox({required this.groupID, required this.groupName});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Container(
        decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(
              color: Colors.grey,
              width: 2.0,
            ),
            borderRadius: BorderRadius.circular(12.0),
            boxShadow: const [
              BoxShadow(
                color: Colors.grey,
                blurRadius: 2.0,
              ),
            ]
        ),
        child: MaterialButton(
          padding: const EdgeInsets.only(left: 15.0),
          onPressed: (){
            ChatScreen.groupID = groupID;
            ChatScreen.groupName = groupName;
            Navigator.pushNamed(context, ChatScreen.id);
          },
          height: 60.0,
          child: Row(
            children: [
              const Icon(
                Icons.group,
                color: Colors.grey,
                size: 35.0,
              ),
              const SizedBox(width: 15.0),
              Text(
                groupName,
                style: const TextStyle(
                    color: Colors.black54,
                    fontSize: 20.0
                ),
              ),
              const Expanded(child: SizedBox()),
              Container(
                height: 60.0,
                width: 2.5,
                decoration: const BoxDecoration(
                    color: Colors.grey
                ),
              ),
              MoreOptionsButton(color: Colors.black54, groupID: groupID, groupName: groupName),
            ],
          ),
        ),
      ),
    );
  }
}

