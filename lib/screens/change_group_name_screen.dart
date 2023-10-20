import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:number_system/number_system.dart';

class ChangeGroupNameScreen extends StatefulWidget {
  static String id = 'change_group_name_screen';
  static late int groupID;
  static late String groupName;
  @override
  State<ChangeGroupNameScreen> createState() => _ChangeGroupNameScreenState();
}

class _ChangeGroupNameScreenState extends State<ChangeGroupNameScreen> {
  final _firestore = FirebaseFirestore.instance;
  TextEditingController _controller = TextEditingController();
  late String newGroupName;
  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xff757575),
      child: Container(
          decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(topLeft: Radius.circular(30.0), topRight: Radius.circular(30.0))
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 50.0, vertical: 25.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  'Change Group Name',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 30.0,
                    color: Colors.lightBlueAccent,
                  ),
                ),
                TextField(
                  autofocus: true,
                  cursorColor: Colors.lightBlueAccent,
                  textAlign: TextAlign.center,
                  onChanged: (value){
                    setState(() {
                      newGroupName = value;
                    });
                  },
                  decoration: InputDecoration(
                    hintText: 'Old name: "${ChangeGroupNameScreen.groupName}"',
                    hintStyle: const TextStyle(
                      color: Colors.grey,
                    ),
                    enabledBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                    focusedBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.lightBlueAccent, width: 2.3)
                    ),
                  ),
                ),
                const SizedBox(height: 15.0),
                TextButton(
                  style: TextButton.styleFrom(
                    elevation: 2.0,
                    shadowColor: Colors.grey,
                    backgroundColor: Colors.lightBlueAccent,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 20.0),
                  ),
                  onPressed: () {
                    //update groups list
                    _firestore.collection('groups').doc(ChangeGroupNameScreen.groupID.decToHex(20).toString()).update({
                      'name' : newGroupName,
                    });
                    //fetch all the messages from old group to new group
                    _firestore.collection(ChangeGroupNameScreen.groupName).get().then(
                        (snapshot) {
                          for(QueryDocumentSnapshot doc in snapshot.docs){
                            _firestore.collection(newGroupName).doc(doc.id).set({
                              'docID': doc.get('docID'),
                              'sender': doc.get('sender'),
                              'name': doc.get('name'),
                              'text': doc.get('text'),
                            });
                            //delete the messages of old group (i.e., delete collection)
                            _firestore.collection(ChangeGroupNameScreen.groupName).doc(doc.id).delete();
                          }
                        }
                    );
                    _controller.clear();
                    Navigator.pop(context);
                  },
                  child: const Text(
                    'Change',
                    style: TextStyle(
                        color: Colors.white
                    ),
                  ),
                )
              ],
            ),
          )
      ),
    );
  }
}
