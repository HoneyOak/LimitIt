import 'package:flutter/material.dart';

void main() {
  runApp(const LimitIt());
}

class LimitIt extends StatelessWidget {
  const LimitIt({super.key});

  

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        brightness: Brightness.dark,
        colorScheme: ColorScheme.dark(
          primary: Color(0xffF1F7ED),
          secondary: Color(0xffA3C9A8),
          surface: Color(0xff1A1A1A),
          onPrimary: Colors.black,
          onSecondary: Colors.black,
          onSurface: Colors.white,
        ),
        primaryColor: Color(0xffF1F7ED),
        scaffoldBackgroundColor: Color(0xff272727),
        appBarTheme: AppBarTheme(
          backgroundColor: Color(0xff272727),
          foregroundColor: Color(0xff272727)
        ),

       ),
      home: const MyWidget(),
    );
  }
}

class MyWidget extends StatefulWidget {
  const MyWidget({super.key});

  @override
  State<MyWidget> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget> {
  @override
  Widget build(BuildContext context) {
   return Scaffold(
    body: Center(
      child: Container(
        margin: const EdgeInsets.all(100),
        padding: const EdgeInsets.all(10),
        color: Color(0xff00A7E1),
        height: 100,
        width: 100,
        child: const Text('Hi Mom 🐣'),
        
      ),
    ),
   );
  }
}
 
  