import 'package:flutter/services.dart';


const platform = MethodChannel("com.iot.basic.channel");

  // Get Verification Code
  Future<String> getVerificationCode(Map<String, dynamic> data) async {
    try {
      final result = await platform.invokeMethod('getVerificationCode', data);
      return result.toString();
    } on PlatformException catch (e) {
      return "Error: ${e.message}";
    } catch (e) {
      return "Unexpected error: $e";
    }
  }

  // Signup with Verification Code
  Future<String> signupWithVerificationCode(
      Map<String, String> data) async {
    try {
      final result =
          await platform.invokeMethod('signupWithVerificationCode', data);
      return result.toString();
    } on PlatformException catch (e) {
      return "Error: ${e.message}";
    } catch (e) {
      return "Unexpected error: $e";
    }
  }

