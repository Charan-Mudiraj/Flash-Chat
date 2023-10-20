import 'package:flashchat/screens/login_screen.dart';
import 'package:flashchat/screens/registration_screen.dart';
import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flashchat/resources/authentication_button.dart';


class WelcomeScreen extends StatefulWidget {
  static String id = 'welcome_screen';
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> with SingleTickerProviderStateMixin{
  late AnimationController controller;
  late Animation animation;
  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      duration: Duration(seconds: 2),
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

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: BottomAppBar(
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
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('images/background.png'),
            fit: BoxFit.cover,
          )
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Hero(
                    tag: 'logo',
                    child: Container(
                      child: Image.asset('images/logo.png'),
                      height: animation.value * 70.0,
                    ),
                  ),
                  DefaultTextStyle(
                    style: TextStyle(
                      fontSize: 45.0,
                      fontWeight: FontWeight.w900,
                      color: Colors.grey,
                    ),
                    child: AnimatedTextKit(
                      animatedTexts: [
                        TypewriterAnimatedText(
                          'Flash Chat',
                          speed: Duration(milliseconds: 30 * 8),
                          curve: Curves.decelerate,
                          textStyle: TextStyle(
                            color: Colors.black45,
                          )
                        ),
                        TypewriterAnimatedText(
                            'A Project by Charan',
                            speed: Duration(milliseconds: 30 * 8),
                            curve: Curves.decelerate,
                          textStyle: TextStyle(
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
              SizedBox(
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
    );
  }
}


