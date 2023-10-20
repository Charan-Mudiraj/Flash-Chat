import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flashchat/resources/alert_box.dart';
import 'package:flutter/material.dart';
import 'package:number_system/number_system.dart';
import '../screens/change_group_name_screen.dart';

enum MoreOptions{ changeGroupName, deleteGroup }
class MoreOptionsButton extends StatelessWidget {

  final Color color;
  final int groupID;
  final String groupName;
  MoreOptionsButton({required this.color, required this.groupID, required this.groupName});

  final _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      itemBuilder: (context) => [
        const PopupMenuItem(
          value: MoreOptions.changeGroupName,
          child: Row(
            children: [
              Icon(Icons.drive_file_rename_outline, color: Colors.black54,),
              Text('  Change group name'),
            ],
          ),
        ),
        const PopupMenuItem(
          value: MoreOptions.deleteGroup,
          child: Row(
            children: [
              Icon(Icons.delete, color: Colors.red,),
              Text('  Delete group'),
            ],
          ),
        ),
      ],
      onSelected: (option){
        if(option == MoreOptions.changeGroupName){
          ChangeGroupNameScreen.groupID = groupID;
          ChangeGroupNameScreen.groupName = groupName;
          showModalBottomSheet(
            context: context,
            builder: (context) => ChangeGroupNameScreen(),
          );
        }else if(option == MoreOptions.deleteGroup){
          showDialog(
            context: context,
            builder: (context) => AlertBox(
              icon: const Icon(
                Icons.delete,
                size: 60.0,
                color: Colors.red,
              ),
              title: 'Confirm deletion',
              description: 'Are you sure you want to delete the group named "$groupName"?',
              onYes: () {
                //delete the doc of corresponding group in groups list
                _firestore.collection('groups').doc(groupID.decToHex(20).toString()).delete();
                //delete the messages of the group(i.e., delete the collection)
                _firestore.collection(groupName).get().then(
                    (snapshot){
                      for(QueryDocumentSnapshot doc in snapshot.docs){
                        _firestore.collection(groupName).doc(doc.id).delete();
                      }
                    }
                );
                Navigator.pop(context);
              },
            ),
          );
        }
      },
      padding: const EdgeInsets.all(0.0),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 6.0, vertical: 11.0),
        child: Icon(
          Icons.more_vert,
          color: color,
          size: 35.0,
        ),
      ),
    );
  }
}