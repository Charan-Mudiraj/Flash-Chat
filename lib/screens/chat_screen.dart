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
  late String messageText;
  final _firestore = FirebaseFirestore.instance;
  final TextEditingController _textController = TextEditingController();
  late int messageCounter;
  final ScrollController _scrollController = ScrollController();
  @override
  void initState() {
    super.initState();
    getCurrentUser();
    updateMessageCounter();
  }

  void getCurrentUser() {
    final user = _auth.currentUser;
    if (user != null) {
      loggedInUser = user;
    }
  }

  // void getCurrentMessages() async {
  //   final messages = await _firestore.collection('messages').doc('ueipDywXOAwr4lcoJ8Ae');
  //   messages.get().then((value){
  //     final data = value.data() as Map<String, dynamic>;
  //     print(data);
  //   });
  // }
  // void messagesStream() async {
  //   await for (var snapshot in _firestore.collection('messages').snapshots()){
  //     for(var message in snapshot.size){
  //       print(message.data());
  //     }
  //   }
  // }
  void _scrollDown(){
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: const Duration(seconds: 1),
      curve: Curves.fastOutSlowIn,
    );
  }
  void updateMessageCounter() async {
    await _firestore.collection(ChatScreen.groupName).count().get().then(
          (res) => messageCounter = res.count,
          onError: (e) => print(e),
        );
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
                  onYes: () {
                    _firestore.collection(ChatScreen.groupName).get().then((snapShot){
                      for(QueryDocumentSnapshot doc in snapShot.docs){
                        _firestore.collection(ChatScreen.groupName).doc(doc.id).delete();
                      }
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
                    final messages = snapshot.data?.docs;
                    List<Widget> messageWidgets = [];
                    for (var message in messages!) {
                      final int docID = message['docID'];
                      final String senderName = message['name'];
                      final String messageSender = message['sender'];
                      final String messageText = message['text'];
                      if (messageSender == loggedInUser.email) {
                        messageWidgets.add(FloatingMessage(
                            docID: docID,
                            groupName: ChatScreen.groupName,
                            name: senderName,
                            text: messageText,
                            isCurrentUser: true));
                      } else {
                        messageWidgets.add(FloatingMessage(
                            docID: docID,
                            groupName: ChatScreen.groupName,
                            name: senderName,
                            text: messageText,
                            isCurrentUser: false));
                      }
                    }
                    return Expanded(
                      child: ListView(
                        controller: _scrollController,
                        children: messageWidgets,
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
                  // decoration: kMessageContainerDecoration,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Expanded(
                        child: TextField(
                          onChanged: (value) {
                            messageText = value;
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
                          onPressed: () {
                            if(messageText != ''){
                              _firestore
                                  .collection(ChatScreen.groupName)
                                  .doc((++messageCounter).decToHex(20).toString())
                                  .set({
                                //SCHEMA FOR MESSAGE
                                'docID': messageCounter,
                                'sender': loggedInUser.email,
                                'name': loggedInUser.displayName,
                                'text': messageText
                              });
                              _textController.clear();
                              messageText = '';
                              _scrollDown();
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
