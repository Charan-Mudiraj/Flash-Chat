import 'package:flutter/material.dart';
import 'package:flashchat/resources/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flashchat/resources/floating_message.dart';
import 'package:number_system/number_system.dart';
import '../resources/alert_box.dart';

enum ChatOptions { deleteAll }

class ChatScreen extends StatefulWidget {
  static late int groupID;
  static late String groupName;

  static String id = 'chat_screen';
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _auth = FirebaseAuth.instance;
  late User loggedInUser;
  String messageText = '';
  final _firestore = FirebaseFirestore.instance;
  final TextEditingController _textController = TextEditingController();
  late int messageCounter;
  final ScrollController _scrollController = ScrollController();
  bool counterAccessPermit = false;
  final String hexGroupID = ChatScreen.groupID.decToHex(20).toString();
  int _scrollJumpCount = 1;
  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }

  void getCurrentUser() {
    final user = _auth.currentUser;
    if (user != null) {
      loggedInUser = user;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Row(
          children: [
            const Icon(
              Icons.group,
              size: 35.0,
            ),
            const SizedBox(width: 15.0),
            Text(ChatScreen.groupName),
          ],
        ),
        actions: [
          PopupMenuButton(
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: ChatOptions.deleteAll,
                child: Row(
                  children: [
                    Icon(
                      Icons.delete,
                      color: Colors.red,
                    ),
                    Text('  Delete all messages'),
                  ],
                ),
              ),
            ],
            onSelected: (option) {
              showDialog(
                context: context,
                builder: (context) => AlertBox(
                  icon: const Icon(
                    Icons.delete,
                    size: 60.0,
                    color: Colors.red,
                  ),
                  title: 'Confirm deletion',
                  description:
                      'Are you sure you want to delete all the messages?',
                  onYes: (){
                    _firestore.collection(ChatScreen.groupName).get().then((snapShot){
                      for(QueryDocumentSnapshot doc in snapShot.docs){
                        _firestore.collection(ChatScreen.groupName).doc(doc.id).delete();
                      }
                    });
                    setState(() {
                      messageCounter = 0;
                    });
                    Navigator.pop(context);
                  },
                ),
              );
            },
          ),
        ],
        titleSpacing: 0.0,
        backgroundColor: Colors.lightBlueAccent,
      ),
      body: Container(
        decoration: const BoxDecoration(
            image: DecorationImage(
          image: AssetImage('images/img.jpg'),
          fit: BoxFit.cover,
        )),
        child: SafeArea(
          child: Column(
            children: <Widget>[
              StreamBuilder<QuerySnapshot>(
                stream: _firestore.collection(ChatScreen.groupName).snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    final messages = snapshot.data!.docs;
                    List<Widget> dbMessageWidgets = [];
                    for (var message in messages) {
                      final int docID = message['docID'];
                      final String senderName = message['name'];
                      final String messageSender = message['sender'];
                      final String messageText = message['text'];
                      if (messageSender == loggedInUser.email) {
                        dbMessageWidgets.add(FloatingMessage(
                            docID: docID,
                            groupName: ChatScreen.groupName,
                            name: senderName,
                            text: messageText,
                            isCurrentUser: true));
                      } else {
                        dbMessageWidgets.add(FloatingMessage(
                            docID: docID,
                            groupName: ChatScreen.groupName,
                            name: senderName,
                            text: messageText,
                            isCurrentUser: false));
                      }
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        if(_scrollJumpCount > 0){
                          _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
                          _scrollJumpCount--;
                        }else{
                          _scrollController.animateTo(
                            _scrollController.position.maxScrollExtent,
                            duration: Duration(milliseconds: 250),
                            curve: Curves.fastOutSlowIn,
                          );
                        }
                      });
                    }
                    return Expanded(
                      child: ListView(
                        controller: _scrollController,
                        children: dbMessageWidgets,
                      ),
                    );
                  } else {
                    return const Center(
                      child: CircularProgressIndicator(
                        backgroundColor: Colors.lightBlueAccent,
                      ),
                    );
                  }
                },
              ),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Container(
                  decoration: BoxDecoration(
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.grey,
                        spreadRadius: 2.0,
                        blurRadius: 5.0,
                      )
                    ],
                    color: Colors.white,
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Expanded(
                        child: TextField(
                          onChanged: (value) {
                            setState(() {
                              messageText = value;
                            });
                          },
                          controller: _textController,
                          decoration: kMessageTextFieldDecoration,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 6.0),
                        child: MaterialButton(
                          minWidth: 0.0,
                          padding: const EdgeInsets.symmetric(horizontal: 10.0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                          onPressed: () async {
                            if(messageText != ''){
                              _textController.clear();
                              //Synchronizing Messages
                              while(!counterAccessPermit) {
                                //[1] loop until counterAccessPermit == true
                                await _firestore.collection('groups').doc(hexGroupID).get().then(
                                        (doc){
                                      setState(() {
                                        counterAccessPermit = doc.data()!['canAccess'];
                                      });
                                    }
                                );
                              }
                              //[2] set access permission to false for other incoming messages until this message gets updated
                              await _firestore.collection('groups').doc(hexGroupID).update({
                                'canAccess' : false,
                              });
                              //[3] access the message counter to place the message widget at bottom
                              await _firestore.collection('groups').doc(hexGroupID).get().then(
                                  (doc){
                                    setState(() {
                                      messageCounter = doc.data()!['msgCounter'];
                                    });
                                  }
                              );
                              //[4] add the message doc into the DB collection
                              await _firestore
                                  .collection(ChatScreen.groupName)
                                  .doc((messageCounter+1).decToHex(20).toString())
                                  .set({
                                //SCHEMA FOR MESSAGE
                                'docID': messageCounter+1,
                                'sender': loggedInUser.email,
                                'name': loggedInUser.displayName,
                                'text': messageText
                              });
                              //[5] increment the message counter by one
                              await _firestore.collection('groups').doc(hexGroupID).update({
                                'msgCounter' : messageCounter+1,
                              });
                              //[6] set the access permission to true
                              await _firestore.collection('groups').doc(hexGroupID).update({
                                'canAccess' : true,
                              });
                              setState(() {
                                messageText = '';
                              });
                            }
                          },
                          child: const Text(
                            'Send',
                            style: kSendButtonTextStyle,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
