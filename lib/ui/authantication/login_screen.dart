// ignore_for_file: unused_field

import 'package:flutter/material.dart';
import 'package:iot_basic/ui/authantication/signup_screen.dart';
import 'package:iot_basic/widget/input_field.dart';
import 'package:iot_basic/widget/rounded_button.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  final _formKey = GlobalKey<FormState>();

  var _emailText = '';
  var _passwordText = '';
  bool _isLogin = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/images/chat.png',
                  height: 120,
                ),
                const SizedBox(height: 30),
            
                Text(
                  "Welcome Back!",
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue[800],
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  "Login to continue chatting",
                  style: TextStyle(color: Colors.grey),
                ),
                const SizedBox(height: 40),
                InputField(
                  prefixIcon: Icons.email_outlined,
                  hintText: "Email",
                  validator: (value) {
                    if(value == null || value.isEmpty){
                      return 'please enter email';
                    }
                    if(!value.contains('@')){
                      return 'please enter valid email';
                    }
                    return null;
                  },
                  onSaved: (value){
                    _emailText = value!;
                  },
                  ),
              
                const SizedBox(height: 15),
            
                 InputField(
                  prefixIcon: Icons.lock_outline,
                  hintText: "Password",
                  obscureText: true,
                   validator: (value) {
                    if(value == null || value.isEmpty){
                      return 'please enter password';
                    }
                    if(value.length < 6){
                      return 'please enter 6 digit password';
                    }
                    return null; 
                  },
                   onSaved: (value){
                    _passwordText = value!;
                  },
                  ),
            
                const SizedBox(height: 20),
                RoundedButton(lable: 'Login', onTap: (){}, isUploading: _isLogin),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Don't have an account? "),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(builder: (context) => SignupScreen()));
                      },
                      child: const Text("Sign Up"),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
