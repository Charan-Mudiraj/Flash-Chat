import 'package:flashchat/screens/add_group_screen.dart';
import 'package:flashchat/screens/welcome_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../resources/alert_box.dart';
import '../resources/group_box.dart';



class GroupScreen extends StatefulWidget {
  static String id = 'group_screen';
  @override
  _GroupScreenState createState() => _GroupScreenState();
}

class _GroupScreenState extends State<GroupScreen> {
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;
  Future _logoutAlert(){
    return showDialog(
      context: context,
      builder: (context) =>
          AlertBox(
            icon: const Icon(
              Icons.logout,
              size: 60.0,
              color: Colors.red,
            ),
            title: 'Confirm logout',
            description: 'Are you sure you want to logout?',
            onYes: () async {
              _auth.signOut();

              final SharedPreferences prefs = await SharedPreferences.getInstance();
              await prefs.setBool('isSignedIn', false);
              await prefs.remove('email');
              await prefs.remove('password');

              Navigator.popUntil(context, ModalRoute.withName(WelcomeScreen.id));
            },
          ),
    );
  }
  @override
  Widget build(BuildContext context){
    return WillPopScope(
      onWillPop: (){
        _logoutAlert();
        return Future.value(false);   //don't pop out the groups screen
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          leading: null,
          automaticallyImplyLeading: false,
          actions: <Widget>[
            IconButton(
                icon: const Icon(Icons.logout),
                onPressed: () {
                  _logoutAlert();
                },
            ),
          ],
          title: const Text('️Groups',),
          centerTitle: true,
          backgroundColor: Colors.lightBlueAccent,
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: (){
            showModalBottomSheet(
              context: context,
              builder: (context) => AddGroupScreen(),
            );
          },
          backgroundColor: Colors.lightBlueAccent,
          child: const Icon(Icons.add),
        ),
        body: SafeArea(
          child: Column(
            children: <Widget>[
              StreamBuilder<QuerySnapshot>(
                stream: _firestore.collection('groups').snapshots(),
                builder: (context, snapshot){
                  if(snapshot.hasData){
                    final groups = snapshot.data?.docs;
                    List<Widget> groupWidgets = [];
                    for(var group in groups!){
                      final int groupID = group['groupID'];
                      final String groupName = group['name'];
                      groupWidgets.add(GroupBox(groupID: groupID, groupName: groupName));
                    }
                    return Expanded(
                      child: ListView(
                        children: groupWidgets,
                      ),
                    );
                  }else{
                    return const Center(
                        child: CircularProgressIndicator(
                          backgroundColor: Colors.lightBlueAccent,
                        )
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}


