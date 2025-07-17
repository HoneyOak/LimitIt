import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import 'package:limit_it/auth_page.dart';
import 'package:limit_it/main_page.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  FlutterForegroundTask.initCommunicationPort();
  runApp(const LimitIt());
}

class LimitIt extends StatelessWidget {
  const LimitIt({super.key});

  

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'LimitIt',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        textTheme: TextTheme(bodyMedium: TextStyle()).apply(bodyColor: Color(0xffF1F7ED)),
        fontFamily: 'TikTokSans',
        brightness: Brightness.dark,
        colorScheme: ColorScheme.dark(
          primary: Color(0xff272727),
          secondary: Color(0xff7F7B82),
          surface: Color(0xff333333),
          onPrimary: Color(0xff00A7E1),
          onSecondary: Colors.black,
          onSurface: Color(0xffF1F7ED),
        ),
        primaryColor: Color(0xffF1F7ED),
        scaffoldBackgroundColor: Color(0xff272727),
        appBarTheme: AppBarTheme(
          backgroundColor: Color(0xff272727),
          foregroundColor: Color(0xffF1F7ED)
        ),

       ),
      home: MainPage(),
    );
  }
}

