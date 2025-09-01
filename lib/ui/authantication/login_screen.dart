import 'package:flutter/material.dart';
import 'package:iot_basic/channels/login_channel.dart';
import 'package:iot_basic/ui/authantication/reset_password_screen.dart';
import 'package:iot_basic/ui/authantication/signup_screen.dart';
import 'package:iot_basic/ui/home/homeScreen.dart';
import 'package:iot_basic/widget/input_field.dart';
import 'package:iot_basic/widget/rounded_button.dart';
import 'package:iot_basic/widget/phone_field.dart';
import 'package:iot_basic/widget/toggle_button.dart';
import 'package:iot_basic/widget/country_picker.dart';
import 'package:country_picker/country_picker.dart';
import 'package:iot_basic/utils/utils.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _isLogin = false;
  bool _isEmailMode = true;
  Country? _selectedCountry;

  @override
  void dispose() {
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _onLogin() async {
    if (!_formKey.currentState!.validate()) return;

    if (_selectedCountry == null) {
      Utils.snackBar("Please select your country", Colors.red, context);
      return;
    }

    setState(() => _isLogin = true);

    final response = await loginChannel({
      "email": _isEmailMode ? _emailController.text : "",
      "phone": !_isEmailMode ? _phoneController.text : "",
      "country": _selectedCountry!.name,
      "countryCode": _selectedCountry!.phoneCode,
      "password": _passwordController.text,
    });

    setState(() => _isLogin = false);

    if (response.contains("Login successful")) {
      Utils.snackBar(response, Colors.blue, context);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const Homescreen()),
      );
    } else {
      Utils.snackBar(response, Colors.red, context);
    }
  }

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
                const SizedBox(height: 30),

                EmailPhoneToggle(
                  isEmailMode: _isEmailMode,
                  onToggle: (val) {
                    setState(() => _isEmailMode = val);
                  },
                ),

                const SizedBox(height: 20),

                CountryPickerWidget(
                  onCountrySelected: (country) {
                    setState(() => _selectedCountry = country);
                  },
                ),

                const SizedBox(height: 20),

                _isEmailMode
                    ? InputField(
                        controller: _emailController,
                        prefixIcon: Icons.email_outlined,
                        hintText: "Email",
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter email';
                          }
                          if (!value.contains('@')) {
                            return 'Please enter valid email';
                          }
                          return null;
                        },
                      )
                    : PhoneInputField(
                        countryCode: _selectedCountry?.phoneCode ?? "92",
                        controller: _phoneController,
                      ),

                const SizedBox(height: 15),

                InputField(
                  controller: _passwordController,
                  prefixIcon: Icons.lock_outline,
                  hintText: "Password",
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter password';
                    }
                    if (value.length < 6) {
                      return 'Password must be at least 6 characters';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 10),

                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: (){
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => const ResetPasswordScreen()),
                      );
                    },
                    child: const Text(
                      "Forgot Password?",
                      style: TextStyle(color: Colors.blue),
                    ),
                  ),
                ),

                const SizedBox(height: 10),

                RoundedButton(
                  lable: 'Login',
                  onTap: _onLogin,
                  isUploading: _isLogin,
                ),

                const SizedBox(height: 20),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Don't have an account? "),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                              builder: (context) => const SignupScreen()),
                        );
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
