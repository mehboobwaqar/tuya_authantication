import 'package:flutter/material.dart';

class PhoneInputField extends StatelessWidget {
  final String countryCode; // like "92"
  final TextEditingController controller;

  const PhoneInputField({
    super.key,
    required this.countryCode,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
       
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: Text(
            "+$countryCode", 
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),

        const SizedBox(width: 10),

        // Phone Number Input
        Expanded(
          child: TextFormField(
            controller: controller,
            keyboardType: TextInputType.phone,
            decoration: InputDecoration(
              hintText: "Phone Number",
              filled: true,
              fillColor: Colors.white,
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
