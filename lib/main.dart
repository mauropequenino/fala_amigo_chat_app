import 'package:fala_amigo_chat_app/firebase_options.dart';
import 'package:fala_amigo_chat_app/screens/auth.dart';
import 'package:fala_amigo_chat_app/screens/chat.dart';
import 'package:fala_amigo_chat_app/screens/splash.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

var lightColorScheme = ColorScheme.fromSeed(seedColor: const Color.fromARGB(255, 36, 161, 211),);
var darkColorScheme = ColorScheme.fromSeed( 
  brightness: Brightness.dark,
  seedColor: const Color.fromARGB(255, 36, 161, 211),
);

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,  
  ); 
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FalaAmigo',
      darkTheme: ThemeData.dark().copyWith(
        colorScheme: lightColorScheme
      ),
      theme: ThemeData().copyWith(
        colorScheme: lightColorScheme
      ),
      themeMode: ThemeMode.system,
      home: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {  
          if(snapshot.connectionState == ConnectionState.waiting) {
            return const SplashScreen();
          }

          if(snapshot.hasData) {
            return const ChatScreen();
          } else {
            return const AuthScreen();
          }
        },),
    );
  }
}