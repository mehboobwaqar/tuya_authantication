import 'package:flutter/material.dart';
import 'package:iot_basic/channels/channels.dart';
import 'package:iot_basic/ui/authantication/login_screen.dart';
import 'package:iot_basic/utils/utils.dart';
import 'package:iot_basic/widget/country_picker.dart';
import 'package:iot_basic/widget/input_field.dart';
import 'package:iot_basic/widget/rounded_button.dart';
import 'package:country_picker/country_picker.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _verificationController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Country? _selectedCountry;
  bool _isUploading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _verificationController.dispose();
    _nameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _getVerifactionCode() {
    final email = _emailController.text.trim();

    if (_selectedCountry == null) {
      Utils.snackBar('Please select your country', context);
      return;
    }

    if (email.isEmpty || !RegExp(r"^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$").hasMatch(email)) {
      Utils.snackBar('Enter a valid email', context);
      return;
    }

    Channels.getVerifactionCode({
      "email": email,
      "country": _selectedCountry!.name,
      "countryCode": _selectedCountry!.phoneCode,
    });
    Utils.snackBar('Verification code requested', context);
  }

  void _onSubmitted() {
    if (_formKey.currentState!.validate()) {
      if (_selectedCountry == null) {
        Utils.snackBar('Please select your country', context);
        return;
      }

      final email = _emailController.text.trim();
      final password = _passwordController.text.trim();
      final name = _nameController.text.trim();
      final code = _verificationController.text.trim();

      print("Signup Data: $email, $name, $password, $code");
      // Call your signup API here
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
                // Country picker
                CountryPickerWidget(
                  onCountrySelected: (country) {
                    _selectedCountry = country;
                  },
                ),
                const SizedBox(height: 24),

                // Email + Get verification code (grouped)
                InputField(
                  controller: _emailController,
                  prefixIcon: Icons.email_outlined,
                  hintText: "Email",
                ),
                const SizedBox(height: 12),
                RoundedButton(
                  lable: 'Get verification code',
                  onTap: _getVerifactionCode,
                ),
                const SizedBox(height: 24),

                // Verification code
                InputField(
                  controller: _verificationController,
                  prefixIcon: Icons.lock_outline,
                  hintText: "Verification code",
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) return 'Please enter verification code';
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Full name
                InputField(
                  controller: _nameController,
                  prefixIcon: Icons.person_outline,
                  hintText: "Full Name",
                  validator: (value) {
                    if (value == null || value.isEmpty) return 'Please enter name';
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Password
                InputField(
                  controller: _passwordController,
                  prefixIcon: Icons.lock_outline,
                  hintText: "Password",
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) return 'Please enter password';
                    if (value.length < 6) return 'Password must be at least 6 characters';
                    return null;
                  },
                ),
                const SizedBox(height: 24),

                // Sign Up button
                RoundedButton(
                  isUploading: _isUploading,
                  lable: 'Sign Up',
                  onTap: _onSubmitted,
                ),
                const SizedBox(height: 24),

                // Login link
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Already have an account? "),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (context) => const LoginScreen()),
                        );
                      },
                      child: const Text("Login"),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
