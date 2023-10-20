import 'package:flashchat/screens/group_screeen.dart';
import 'package:flutter/material.dart';
import 'package:flashchat/resources/authentication_button.dart';
import 'package:flashchat/resources/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class RegistrationScreen extends StatefulWidget {
  static String id = 'registration_screen';
  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {

  final _auth = FirebaseAuth.instance;
  late String name;
  late String email;
  late String password;
  bool showSpinner = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('images/background.png'),
            fit: BoxFit.cover,
          )
        ),
        child: ModalProgressHUD(
          inAsyncCall: showSpinner,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Hero(
                  tag: 'logo',
                  child: SizedBox(
                    height: 200.0,
                    child: Image.asset('images/logo.png'),
                  ),
                ),
                const SizedBox(
                  height: 48.0,
                ),
                TextField(
                  onChanged: (value) {
                    name = value;
                  },
                  decoration: kInputDecorationField.copyWith(hintText: 'Enter Your Name'),
                  style: const TextStyle(
                    color: Colors.black,
                  ),
                  textAlign: TextAlign.center,
                  keyboardType: TextInputType.text,
                ),
                const SizedBox(
                  height: 8.0,
                ),
                TextField(
                  onChanged: (value) {
                    email = value;
                  },
                  decoration: kInputDecorationField.copyWith(hintText: 'Enter Your Email'),
                  style: const TextStyle(
                    color: Colors.black,
                  ),
                  textAlign: TextAlign.center,
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(
                  height: 8.0,
                ),
                TextField(
                  onChanged: (value) {
                    password = value;
                  },
                  decoration: kInputDecorationField.copyWith(hintText: 'Enter New Password (min 6)'),
                  style: const TextStyle(
                    color: Colors.black,
                  ),
                  textAlign: TextAlign.center,
                  obscureText: true,
                  keyboardType: TextInputType.visiblePassword,
                ),
                const SizedBox(
                  height: 24.0,
                ),
                Hero(
                  tag: 'register',
                  child: AuthenticationButton(
                    'Register',
                    color: Colors.amberAccent,
                    onTap: () async {
                      setState(() {
                        showSpinner = true;
                      });
                      try{
                        await _auth.createUserWithEmailAndPassword(email: email, password: password);
                        var user = _auth.currentUser;
                        if(user != null){
                          await user.updateDisplayName(name);
                          Navigator.pushNamed(context, GroupScreen.id);
                        }
                        setState(() {
                          showSpinner = false;
                        });
                      }
                      catch(e){
                        showDialog(
                          context: context,
                          builder: (context) => WillPopScope(
                            onWillPop: (){
                              return Future.value(false);   //don't let it pop(i.e., back button wont work)
                            },
                            child: AlertDialog(
                              icon: const Icon(
                                Icons.warning,
                                size: 60.0,
                                color: Colors.amber,
                              ),
                              title: const Text('Invalid Email/Password'),
                              content: const Text('Either your email is incorrect or password length is less than (6).'),
                              actions: [
                                MaterialButton(
                                  onPressed: (){
                                    Navigator.pop(context);
                                    setState(() {
                                      showSpinner = false;
                                    });
                                  },
                                  child: const Text('Ok', style: TextStyle(color: Colors.lightBlueAccent, fontSize: 18.0)),
                                ),
                              ],
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30.0),
                              ),
                              actionsAlignment: MainAxisAlignment.center,
                              actionsPadding: const EdgeInsets.only(bottom: 12.0),
                              buttonPadding: const EdgeInsets.symmetric(horizontal: 50.0),
                            ),
                          ),
                        );
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

