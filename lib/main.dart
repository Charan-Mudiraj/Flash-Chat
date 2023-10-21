import 'package:firebase_core/firebase_core.dart';
import 'package:flashchat/screens/add_group_screen.dart';
import 'package:flashchat/screens/change_group_name_screen.dart';
import 'package:flashchat/screens/group_screeen.dart';
import 'package:flutter/material.dart';
import 'package:flashchat/screens/welcome_screen.dart';
import 'package:flashchat/screens/login_screen.dart';
import 'package:flashchat/screens/registration_screen.dart';
import 'package:flashchat/screens/chat_screen.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform
  );
  runApp(FlashChat());
}

class FlashChat extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: WelcomeScreen.id,
      routes: {
        WelcomeScreen.id: (context) => WelcomeScreen(),
        RegistrationScreen.id: (context) => RegistrationScreen(),
        LoginScreen.id: (context) => LoginScreen(),
        GroupScreen.id: (context) => GroupScreen(),
        AddGroupScreen.id: (context) => AddGroupScreen(),
        ChangeGroupNameScreen.id: (context) => ChangeGroupNameScreen(),
        ChatScreen.id: (context) => ChatScreen(),
      },
    );
  }
}
