import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:number_system/number_system.dart';

class AddGroupScreen extends StatefulWidget {
  static String id = 'add_group_screen';
  @override
  State<AddGroupScreen> createState() => _AddGroupScreenState();
}

class _AddGroupScreenState extends State<AddGroupScreen> {


  final _firestore = FirebaseFirestore.instance;
  TextEditingController _controller = TextEditingController();
  late String newGroupName;

  late int groupCounter;
  @override
  void initState() {
    super.initState();
    updateGroupCounter();
  }

  void updateGroupCounter() async {
    await _firestore.collection('groups').count().get().then(
        (res) => groupCounter = res.count,
      onError: (e) => print(e),
    );
  }
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
                  'Add Group',
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
                  decoration: const InputDecoration(
                    hintText: 'New Group Name',
                    hintStyle: TextStyle(
                      color: Colors.grey,
                    ),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                    focusedBorder: UnderlineInputBorder(
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
                    _firestore.collection('groups').doc((++groupCounter).decToHex(20).toString()).set({
                      'groupID' : groupCounter,
                      'name' : newGroupName,
                      'canAccess' : true,   //initially
                      'msgCounter' : 0,     //initially
                    });
                    _controller.clear();
                    Navigator.pop(context);
                  },
                  child: const Text(
                    'Add',
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
