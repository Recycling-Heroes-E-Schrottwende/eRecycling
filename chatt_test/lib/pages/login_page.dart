import 'package:chatt_test/components/my_button.dart';
import 'package:chatt_test/components/my_textfield.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

final emailcontroller = TextEditingController();
final passwordcontroller = TextEditingController();

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: SafeArea(
        child: Center(
          child: Column(
            children: [
              //Logo

              //Welcome Message

              //Email textfield
              MyTextField(
               controller: emailcontroller,
               hintText: 'Email',
               obscureText: false,
              ),

              //Password textfield
              MyTextField(
               controller: passwordcontroller,
               hintText: 'Password',
               obscureText: true,
              ),


              //sign in button
              MyButton(
                onTap: (){},
                text: "Sign In"
              ),

              //sign up button



            ],
          ),
        ),
      ),
      
    );
  }
}
