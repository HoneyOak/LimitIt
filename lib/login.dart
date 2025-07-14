import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  Future signIn() async{
    await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: _emailController.text.trim(), 
      password: _passwordController.text.trim(),
      );

  }
  
  
  @override
  void dispose() {
  _emailController.dispose();
  _passwordController.dispose(); 
   super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
              //Hey! ready to limit it?
              Text(
                'LimitIt!',
                style: TextStyle(
                  fontWeight: FontWeight.bold, 
                  fontSize: 36,
                ),
              ),
              Text(
                'Hey! Ready to limit it?!',
                style: TextStyle(
                  fontSize: 20
                ),
              ),
              SizedBox(height: 50),
              //email textfield
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.secondary,
                    border: Border.all(color: Theme.of(context).colorScheme.primary),
                    borderRadius: BorderRadius.circular(13),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 18.0),
                    child: TextField(
                      controller: _emailController,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText:  'Email',
                        hintStyle: TextStyle(color: Color(0xffbfbdbd)),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 10),
            
              
              //password textfield
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: GestureDetector(
                  onTap: signIn,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.secondary,
                      border: Border.all(color: Theme.of(context).colorScheme.secondary),
                      borderRadius: BorderRadius.circular(13),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 18.0),
                      child: TextField(
                        controller: _passwordController,
                        obscureText: true,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText:  'Password',
                          hintStyle: TextStyle(color: Color(0xffbfbdbd)),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 10),
            
              
              //sign in button
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: Container(
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.onPrimary,
                    borderRadius: BorderRadius.circular(12)
                    ),
                  child: Center(
                    child: Text(
                      'Sign In',
                      style: TextStyle(
                        color:Theme.of(context).colorScheme.onSurface,
                        fontWeight: FontWeight.bold,
                        fontSize: 18, 
                        ),
                      ),
                  ),
                ),
              ),
              SizedBox(height: 25),
              //register button 
            
              //not limited it before?
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Not limited it before? '),
                  Text(
                    'Sign up', 
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onPrimary,
                      fontWeight: FontWeight.bold
                  ),
                  ),
                ],
              )
            ],
            ),
          ),
        ),
      )
    );
  }
}