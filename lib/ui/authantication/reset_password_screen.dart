import 'package:flutter/material.dart';
import 'package:iot_basic/channels/reset_password.dart';
import 'package:iot_basic/channels/signup_channel.dart';
import 'package:iot_basic/ui/authantication/login_screen.dart';
import 'package:iot_basic/utils/utils.dart';
import 'package:iot_basic/widget/country_picker.dart';
import 'package:iot_basic/widget/input_field.dart';
import 'package:iot_basic/widget/phone_field.dart';
import 'package:iot_basic/widget/rounded_button.dart';
import 'package:country_picker/country_picker.dart';
import 'package:iot_basic/widget/toggle_button.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _verificationController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Country? _selectedCountry;
  bool _isUploading = false;
  bool _isEmailMode = true;
  int _type = 3;

  @override
  void dispose() {
    _emailController.dispose();
    _phoneController.dispose();
    _verificationController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _getVerificationCode() async {
    if (_selectedCountry == null) {
      Utils.snackBar('Please select your country', Colors.red, context);
      return;
    }

    if (_isEmailMode) {
      if (_emailController.text.isEmpty ||
          !RegExp(r"^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$")
              .hasMatch(_emailController.text)) {
        Utils.snackBar('Enter a valid email', Colors.red, context);
        return;
      }
    } else {
      if (_phoneController.text.isEmpty ||
          !RegExp(r'^[0-9]{6,15}$').hasMatch(_phoneController.text)) {
        Utils.snackBar('Enter a valid phone number', Colors.red, context);
        return;
      }
    }

    setState(() => _isUploading = true);

    final response = await getVerificationCode({
      "email": _isEmailMode ? _emailController.text : "",
      "phoneNo": !_isEmailMode ? _phoneController.text : "",
      "country": _selectedCountry!.name,
      "countryCode": _selectedCountry!.phoneCode,
      "isEmailMode": _isEmailMode,
      "type": _type
    });

    setState(() => _isUploading = false);

    if (response == "Verification code sent successfully") {
      Utils.snackBar(response, Colors.blue, context);
    } else {
      Utils.snackBar(response, Colors.red, context);
    }
  }

  void _onSubmitted() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isUploading = true);

      final response = await resetPasswordEmail({
        "email": _isEmailMode ? _emailController.text : "",
        "phone": !_isEmailMode ? _phoneController.text : "",
        "country": _selectedCountry!.name,
        "countryCode": _selectedCountry!.phoneCode,
        "password": _passwordController.text,
        "verificationCode": _verificationController.text
      });

      setState(() => _isUploading = false);

      if (response.contains("Password reset successful with email")) {
        Utils.snackBar("Password reset successful", Colors.blue, context);
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const LoginScreen()),
        );
      } else {
        Utils.snackBar(" $response", Colors.red, context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                EmailPhoneToggle(
                  isEmailMode: _isEmailMode,
                  onToggle: (val) {
                    setState(() => _isEmailMode = val);
                  },
                ),
                const SizedBox(height: 24),
                CountryPickerWidget(
                  onCountrySelected: (country) {
                    setState(() {
                      _selectedCountry = country;
                    });
                  },
                ),
                const SizedBox(height: 24),
                if (_isEmailMode)
                  InputField(
                    controller: _emailController,
                    prefixIcon: Icons.email_outlined,
                    hintText: "Email",
                  )
                else
                  PhoneInputField(
                    countryCode: _selectedCountry?.phoneCode ?? "92",
                    controller: _phoneController,
                  ),
                const SizedBox(height: 12),
                RoundedButton(
                  lable: 'Get verification code',
                  isUploading: _isUploading,
                  onTap: _getVerificationCode,
                ),
                const SizedBox(height: 24),
                InputField(
                  controller: _verificationController,
                  prefixIcon: Icons.lock_outline,
                  hintText: "Verification code",
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter verification code';
                    }
                    return null;
                  },
                ),
               
                const SizedBox(height: 16),
                InputField(
                  controller: _passwordController,
                  prefixIcon: Icons.lock_outline,
                  hintText: "New Password",
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
                const SizedBox(height: 24),
                RoundedButton(
                  lable: 'Reset Password',
                  isUploading: _isUploading,
                  onTap: _onSubmitted,
                ), 
              ],
            ),
          ),
        ),
      ),
    );
  }
}
