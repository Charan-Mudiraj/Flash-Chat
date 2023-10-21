import 'package:firebase_auth/firebase_auth.dart';
import 'package:flashchat/screens/group_screeen.dart';
import 'package:flashchat/screens/login_screen.dart';
import 'package:flashchat/screens/registration_screen.dart';
import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flashchat/resources/authentication_button.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:shared_preferences/shared_preferences.dart';


class WelcomeScreen extends StatefulWidget {
  static String id = 'welcome_screen';
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> with SingleTickerProviderStateMixin{
  late AnimationController controller;
  late Animation animation;
  bool showSpinner = false;
  @override
  void initState() {
    super.initState();
    autoSignIn();
    controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
      // lowerBound: 0.0,
      // upperBound: 1.0    //default
    );
    animation = CurvedAnimation(parent: controller, curve: Curves.easeIn);    //for logo image
    controller.forward();

    // controller.addStatusListener((status) {
    //   if(status == AnimationStatus.completed){
    //     controller.reverse(from: 1.0);
    //   }else if(status == AnimationStatus.dismissed){
    //     controller.forward();
    //   }
    // });

    controller.addListener(() {setState(() {});});
  }

  void autoSignIn() async {
    setState(() {
      showSpinner = true;
    });
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final bool? isSignedIn = prefs.getBool('isSignedIn');
    if(isSignedIn != null && isSignedIn == true){
      final _auth = FirebaseAuth.instance;
      final String? email = prefs.getString('email');
      final String? password = prefs.getString('password');
      if(email != null && password != null){
        await _auth.signInWithEmailAndPassword(email: email, password: password);
        Navigator.pushNamed(context, GroupScreen.id);
      }
    }
    setState(() {
      showSpinner = false;
    });
  }
  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: const BottomAppBar(
        color: Colors.transparent,
        child: Padding(
          padding: EdgeInsets.all(3.0),
          child: Text(
            '© 2023 Charan M',
            textAlign: TextAlign.center,
            style: TextStyle(
                color: Colors.black54,
                fontSize: 15.0
            ),
          ),
        ),
      ),
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('images/background.png'),
              fit: BoxFit.cover,
            )
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Hero(
                      tag: 'logo',
                      child: Container(
                        height: animation.value * 70.0,
                        child: Image.asset('images/logo.png'),
                      ),
                    ),
                    DefaultTextStyle(
                      style: const TextStyle(
                        fontSize: 45.0,
                        fontWeight: FontWeight.w900,
                        color: Colors.grey,
                      ),
                      child: AnimatedTextKit(
                        animatedTexts: [
                          TypewriterAnimatedText(
                            'Flash Chat',
                            speed: const Duration(milliseconds: 30 * 8),
                            curve: Curves.decelerate,
                            textStyle: const TextStyle(
                              color: Colors.black45,
                            )
                          ),
                          TypewriterAnimatedText(
                              'A Project by Charan',
                              speed: const Duration(milliseconds: 30 * 8),
                              curve: Curves.decelerate,
                            textStyle: const TextStyle(
                              color: Colors.black45,
                              fontSize: 27.0,
                            )
                          ),
                        ],
                        totalRepeatCount: 1,
                        repeatForever: true,
                      )
                    )
                  ],
                ),
                const SizedBox(
                  height: 48.0,
                ),
                Hero(
                  tag: 'login',
                  child: AuthenticationButton(
                    'Log In',
                    color: Colors.lightBlueAccent,
                    onTap: (){
                      Navigator.pushNamed(context, LoginScreen.id);
                    },
                  ),
                ),
                Hero(
                  tag: 'register',
                  child: AuthenticationButton(
                    'Register',
                    color: Colors.amberAccent,
                    onTap: (){
                      Navigator.pushNamed(context, RegistrationScreen.id);
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


