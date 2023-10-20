import 'package:firebase_auth/firebase_auth.dart';
import 'package:flashchat/screens/group_screeen.dart';
import 'package:flutter/material.dart';
import 'package:flashchat/resources/authentication_button.dart';
import 'package:flashchat/resources/constants.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
class LoginScreen extends StatefulWidget {
  static String id = 'login_screen';
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _auth = FirebaseAuth.instance;
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
                  decoration: kInputDecorationField.copyWith(hintText: 'Enter Your Password'),
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
                  tag: 'login',
                  child: AuthenticationButton(
                    'Log In',
                    color: Colors.lightBlueAccent,
                    onTap: () async {
                      setState(() {
                        showSpinner = true;
                      });
                      try{
                        final user = await _auth.signInWithEmailAndPassword(email: email, password: password);
                        if(user != null){
                          Navigator.pushNamed(context, GroupScreen.id);
                        };
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
                                content: const Text('Either your email is not registered yet or your password is incorrect.'),
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
                Center(
                  child: InkWell(
                    onTap: (){
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          icon: const Icon(
                            Icons.incomplete_circle,
                            size: 60.0,
                            color: Colors.amber,
                          ),
                          title: const Text('***Under Development***'),
                          content: const Text('This Feature is not developed yet. Please come back later.'),
                          actions: [
                            MaterialButton(
                              onPressed: (){
                                Navigator.pop(context);
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
                      );
                    },
                    child: const Text(
                      'Forgot Password ?',
                      style: TextStyle(
                        color: Colors.black54,
                        decoration: TextDecoration.underline,
                        fontSize: 16.0
                      ),
                    )

                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
