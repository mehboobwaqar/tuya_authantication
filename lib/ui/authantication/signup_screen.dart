// ignore_for_file: unused_field

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:iot_basic/widget/input_field.dart';
import 'package:iot_basic/widget/rounded_button.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  var _nameText = '';
  var _emailText = '';
  var _passwordText = '';
  File? _selectedImage;
  bool _isUploading = false;

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

            const SizedBox(height: 15),
            InputField(
              prefixIcon: Icons.person_outline,
              hintText: "Full Name",
               validator: (value) {
                    if(value == null || value.isEmpty){
                      return 'please enter name';
                    }      
                    return null; 
                  },
                   onSaved: (value){
                    _nameText = value!;
                  },
            ),
            const SizedBox(height: 15),

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

            RoundedButton(
              isUploading: _isUploading,
              lable: 'Sign Up',
              onTap: (){},
            ),

            const SizedBox(height: 20),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [

                Text("Already have an account? "),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text("Login"),
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